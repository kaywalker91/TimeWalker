#!/usr/bin/env python3
"""
TimeWalker Supabase 데이터 검증 스크립트

마이그레이션 후 데이터 무결성을 검증합니다.

사용법:
    python validate_data.py --url <SUPABASE_URL> --key <ANON_KEY>
"""

import argparse
import json
import os
import sys
from pathlib import Path
from typing import Any

try:
    from supabase import create_client, Client
    from dotenv import load_dotenv
except ImportError:
    print("필수 패키지를 설치하세요: pip install supabase python-dotenv")
    sys.exit(1)

# 프로젝트 루트 디렉토리
PROJECT_ROOT = Path(__file__).parent.parent.parent
ASSETS_DATA_DIR = PROJECT_ROOT / "assets" / "data"

# 검증할 데이터셋
DATASETS = {
    "characters": {
        "file": "characters.json",
        "table": "characters",
        "id_field": "id",
    },
    "dialogues": {
        "file": "dialogues.json",
        "table": "dialogues",
        "id_field": "id",
    },
    "locations": {
        "file": "locations.json",
        "table": "locations",
        "id_field": "id",
    },
    "encyclopedia_entries": {
        "file": "encyclopedia.json",
        "table": "encyclopedia_entries",
        "id_field": "id",
    },
    "quizzes": {
        "file": "quizzes.json",
        "table": "quizzes",
        "id_field": "id",
    },
}


def load_json(file_path: Path) -> list[dict[str, Any]]:
    """JSON 파일 로드"""
    with open(file_path, "r", encoding="utf-8") as f:
        return json.load(f)


def count_remote(client: Client, table: str) -> int:
    """원격 테이블 레코드 수 조회"""
    try:
        # count 대신 select로 ID만 가져와서 카운트
        response = client.table(table).select("id").execute()
        return len(response.data)
    except Exception as e:
        print(f"  ✗ {table} 조회 오류: {e}")
        return -1


def get_remote_ids(client: Client, table: str) -> set[str]:
    """원격 테이블의 모든 ID 조회"""
    try:
        response = client.table(table).select("id").execute()
        return {row["id"] for row in response.data}
    except Exception as e:
        print(f"  ✗ {table} ID 조회 오류: {e}")
        return set()


def validate_dataset(client: Client, name: str, config: dict) -> dict:
    """단일 데이터셋 검증"""
    file_path = ASSETS_DATA_DIR / config["file"]
    table = config["table"]
    id_field = config["id_field"]

    print(f"\n🔍 {name} 검증...")

    if not file_path.exists():
        return {"status": "error", "message": "로컬 파일 없음"}

    # 로컬 데이터 로드
    local_data = load_json(file_path)
    local_count = len(local_data)
    local_ids = {item[id_field] for item in local_data}

    # 원격 데이터 조회
    remote_count = count_remote(client, table)
    if remote_count < 0:
        return {"status": "error", "message": "원격 조회 실패"}

    remote_ids = get_remote_ids(client, table)

    # 비교
    missing_ids = local_ids - remote_ids
    extra_ids = remote_ids - local_ids

    result = {
        "status": "success",
        "local_count": local_count,
        "remote_count": remote_count,
        "match": local_count == remote_count and not missing_ids and not extra_ids,
        "missing_ids": list(missing_ids)[:10],  # 최대 10개만 표시
        "extra_ids": list(extra_ids)[:10],
    }

    # 출력
    match_icon = "✓" if result["match"] else "✗"
    print(f"  로컬: {local_count}개, 원격: {remote_count}개 [{match_icon}]")

    if missing_ids:
        print(f"  ⚠ 누락된 ID ({len(missing_ids)}개): {list(missing_ids)[:5]}...")
    if extra_ids:
        print(f"  ⚠ 추가된 ID ({len(extra_ids)}개): {list(extra_ids)[:5]}...")

    return result


def check_content_versions(client: Client) -> None:
    """content_versions 테이블 확인"""
    print("\n📋 content_versions 테이블:")
    try:
        response = client.table("content_versions").select("*").execute()
        for row in response.data:
            print(f"  - {row['dataset']}: {row.get('version', 'N/A')}")
    except Exception as e:
        print(f"  ✗ 조회 오류: {e}")


def main():
    parser = argparse.ArgumentParser(description="TimeWalker Supabase 데이터 검증")
    parser.add_argument("--url", help="Supabase URL")
    parser.add_argument("--key", help="Supabase Anon Key (또는 Service Role Key)")
    args = parser.parse_args()

    # 환경변수 로드
    load_dotenv(PROJECT_ROOT / ".env")

    supabase_url = args.url or os.getenv("SUPABASE_URL")
    supabase_key = args.key or os.getenv("SUPABASE_ANON_KEY") or os.getenv("SUPABASE_SERVICE_ROLE_KEY")

    if not supabase_url or not supabase_key:
        print("❌ Supabase URL과 Key가 필요합니다.")
        sys.exit(1)

    print("=" * 60)
    print("🔍 TimeWalker Supabase 데이터 검증")
    print("=" * 60)
    print(f"URL: {supabase_url}")

    # Supabase 클라이언트 생성
    client: Client = create_client(supabase_url, supabase_key)

    # 각 데이터셋 검증
    results = {}
    for name, config in DATASETS.items():
        results[name] = validate_dataset(client, name, config)

    # content_versions 확인
    check_content_versions(client)

    # 결과 요약
    print("\n" + "=" * 60)
    print("📊 검증 결과 요약")
    print("=" * 60)

    all_match = True
    for name, result in results.items():
        if result.get("match"):
            print(f"  ✓ {name}: 일치 ({result.get('local_count', 0)}개)")
        else:
            print(f"  ✗ {name}: 불일치 (로컬 {result.get('local_count', 0)} vs 원격 {result.get('remote_count', 0)})")
            all_match = False

    if all_match:
        print("\n✅ 모든 데이터가 정상적으로 마이그레이션되었습니다!")
    else:
        print("\n⚠️  일부 데이터에 불일치가 있습니다. 마이그레이션을 다시 확인하세요.")


if __name__ == "__main__":
    main()
