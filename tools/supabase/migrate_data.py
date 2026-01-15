#!/usr/bin/env python3
"""
TimeWalker Supabase 데이터 마이그레이션 스크립트

이 스크립트는 로컬 JSON 파일을 읽어 Supabase 데이터베이스에 업로드합니다.

사용법:
    python migrate_data.py --url <SUPABASE_URL> --key <SERVICE_ROLE_KEY>

필수 패키지:
    pip install supabase python-dotenv

환경변수 (.env 파일):
    SUPABASE_URL=https://xxx.supabase.co
    SUPABASE_SERVICE_ROLE_KEY=eyJxxx...
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

# 데이터셋 정의 (JSON 파일 -> 테이블 매핑)
DATASETS = {
    "characters": {
        "file": "characters.json",
        "table": "characters",
        "staging_table": "stg_characters",
    },
    "dialogues": {
        "file": "dialogues.json",
        "table": "dialogues",
        "staging_table": "stg_dialogues",
    },
    "locations": {
        "file": "locations.json",
        "table": "locations",
        "staging_table": "stg_locations",
    },
    "encyclopedia_entries": {
        "file": "encyclopedia.json",
        "table": "encyclopedia_entries",
        "staging_table": "stg_encyclopedia_entries",
    },
    "quizzes": {
        "file": "quizzes.json",
        "table": "quizzes",
        "staging_table": "stg_quizzes",
    },
}


def load_json(file_path: Path) -> list[dict[str, Any]]:
    """JSON 파일 로드"""
    with open(file_path, "r", encoding="utf-8") as f:
        return json.load(f)


def clear_staging_table(client: Client, table_name: str) -> None:
    """Staging 테이블 비우기"""
    try:
        # Delete all rows (Supabase doesn't have TRUNCATE via API)
        client.table(table_name).delete().neq("payload", {}).execute()
        print(f"  ✓ {table_name} 비우기 완료")
    except Exception as e:
        print(f"  ⚠ {table_name} 비우기 실패 (테이블이 없을 수 있음): {e}")


def insert_to_staging(client: Client, table_name: str, data: list[dict]) -> int:
    """Staging 테이블에 데이터 삽입"""
    if not data:
        return 0

    # JSONB payload 형태로 변환
    payloads = [{"payload": item} for item in data]

    # 배치 삽입 (최대 1000개씩)
    batch_size = 500
    inserted = 0

    for i in range(0, len(payloads), batch_size):
        batch = payloads[i : i + batch_size]
        try:
            client.table(table_name).insert(batch).execute()
            inserted += len(batch)
            print(f"  ✓ {table_name}: {inserted}/{len(payloads)} 삽입됨")
        except Exception as e:
            print(f"  ✗ {table_name} 삽입 오류: {e}")
            raise

    return inserted


def run_load_sql(client: Client) -> None:
    """load.sql 실행 (staging -> main 테이블)
    
    Note: Supabase Python 클라이언트는 직접 SQL 실행을 지원하지 않습니다.
    load.sql은 Supabase Dashboard의 SQL Editor에서 실행해야 합니다.
    """
    print("\n⚠️  load.sql은 Supabase Dashboard에서 수동 실행이 필요합니다.")
    print("   1. Supabase Dashboard -> SQL Editor 이동")
    print("   2. tools/supabase/load.sql 내용 복사 & 실행")


def update_content_versions(client: Client, datasets: list[str], version: str = "v1") -> None:
    """content_versions 테이블 업데이트"""
    for dataset in datasets:
        try:
            client.table("content_versions").upsert({
                "dataset": dataset,
                "version": version,
                "checksum": None,
            }).execute()
            print(f"  ✓ content_versions: {dataset} -> {version}")
        except Exception as e:
            print(f"  ⚠ content_versions 업데이트 실패: {e}")


def migrate_dataset(client: Client, dataset_name: str, config: dict) -> dict:
    """단일 데이터셋 마이그레이션"""
    file_path = ASSETS_DATA_DIR / config["file"]
    staging_table = config["staging_table"]

    print(f"\n📦 {dataset_name} 마이그레이션...")
    print(f"   파일: {file_path}")

    if not file_path.exists():
        print(f"   ✗ 파일이 존재하지 않습니다!")
        return {"status": "error", "count": 0}

    # JSON 로드
    data = load_json(file_path)
    print(f"   로드된 항목: {len(data)}개")

    # Staging 테이블 비우기
    clear_staging_table(client, staging_table)

    # Staging 테이블에 삽입
    inserted = insert_to_staging(client, staging_table, data)

    return {"status": "success", "count": inserted}


def main():
    parser = argparse.ArgumentParser(description="TimeWalker Supabase 데이터 마이그레이션")
    parser.add_argument("--url", help="Supabase URL")
    parser.add_argument("--key", help="Supabase Service Role Key")
    parser.add_argument(
        "--datasets",
        nargs="+",
        choices=list(DATASETS.keys()) + ["all"],
        default=["all"],
        help="마이그레이션할 데이터셋 (기본: all)",
    )
    parser.add_argument("--dry-run", action="store_true", help="실제 업로드 없이 시뮬레이션")
    args = parser.parse_args()

    # 환경변수 로드
    load_dotenv(PROJECT_ROOT / ".env")

    supabase_url = args.url or os.getenv("SUPABASE_URL")
    supabase_key = args.key or os.getenv("SUPABASE_SERVICE_ROLE_KEY")

    if not supabase_url or not supabase_key:
        print("❌ Supabase URL과 Service Role Key가 필요합니다.")
        print("   --url, --key 옵션 또는 .env 파일을 설정하세요.")
        sys.exit(1)

    print("=" * 60)
    print("🚀 TimeWalker Supabase 데이터 마이그레이션")
    print("=" * 60)
    print(f"URL: {supabase_url}")
    print(f"Data Dir: {ASSETS_DATA_DIR}")

    if args.dry_run:
        print("\n⚠️  DRY RUN 모드 - 실제 업로드 없음")
        for name, config in DATASETS.items():
            file_path = ASSETS_DATA_DIR / config["file"]
            if file_path.exists():
                data = load_json(file_path)
                print(f"  {name}: {len(data)}개 항목")
            else:
                print(f"  {name}: 파일 없음")
        return

    # Supabase 클라이언트 생성
    client: Client = create_client(supabase_url, supabase_key)

    # 마이그레이션할 데이터셋 결정
    target_datasets = list(DATASETS.keys()) if "all" in args.datasets else args.datasets

    results = {}
    for name in target_datasets:
        config = DATASETS[name]
        results[name] = migrate_dataset(client, name, config)

    # 결과 요약
    print("\n" + "=" * 60)
    print("📊 마이그레이션 결과")
    print("=" * 60)
    
    success_count = 0
    for name, result in results.items():
        status_icon = "✓" if result["status"] == "success" else "✗"
        print(f"  {status_icon} {name}: {result['count']}개")
        if result["status"] == "success":
            success_count += 1

    print(f"\n총 {success_count}/{len(results)} 데이터셋 성공")

    # load.sql 실행 안내
    run_load_sql(client)

    # content_versions 업데이트
    print("\n📝 content_versions 업데이트...")
    successful_datasets = [name for name, result in results.items() if result["status"] == "success"]
    update_content_versions(client, successful_datasets)

    print("\n✅ 마이그레이션 완료!")
    print("\n다음 단계:")
    print("  1. Supabase Dashboard -> SQL Editor 이동")
    print("  2. tools/supabase/load.sql 내용 실행")
    print("  3. 앱에서 Supabase 연동 테스트")


if __name__ == "__main__":
    main()
