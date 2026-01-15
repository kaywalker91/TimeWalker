# Supabase 마이그레이션 가이드

이 문서는 TimeWalker 앱의 콘텐츠 데이터를 Supabase로 마이그레이션하는 방법을 설명합니다.

## 📋 목차

1. [사전 준비](#사전-준비)
2. [Phase 1: Supabase 프로젝트 설정](#phase-1-supabase-프로젝트-설정)
3. [Phase 2: 데이터 마이그레이션](#phase-2-데이터-마이그레이션)
4. [Phase 3: 앱 연동 테스트](#phase-3-앱-연동-테스트)
5. [문제 해결](#문제-해결)

---

## 사전 준비

### 필수 도구

```bash
# Python 패키지 설치
pip install supabase python-dotenv

# 또는 requirements.txt 사용
pip install -r tools/supabase/requirements.txt
```

### 파일 구조

```
tools/supabase/
├── README.md              # 이 문서
├── requirements.txt       # Python 의존성
├── schema.sql             # 데이터베이스 스키마
├── load.sql               # Staging → Main 테이블 변환
├── migrate_data.py        # JSON → Supabase 마이그레이션
└── validate_data.py       # 데이터 검증
```

---

## Phase 1: Supabase 프로젝트 설정

### Step 1.1: 프로젝트 생성

1. [Supabase](https://supabase.com) 접속
2. **New Project** 클릭
3. 프로젝트 정보 입력:
   - **Name**: `timewalker` (또는 원하는 이름)
   - **Database Password**: 안전한 비밀번호 설정
   - **Region**: `Northeast Asia (Seoul)` 권장
4. **Create new project** 클릭

### Step 1.2: 스키마 배포

1. Supabase Dashboard → **SQL Editor** 이동
2. **New query** 클릭
3. `schema.sql` 내용 복사 & 붙여넣기
4. **Run** 클릭
5. 성공 메시지 확인

### Step 1.3: API 키 확보

1. Dashboard → **Settings** → **API** 이동
2. 다음 정보 복사:
   - **Project URL**: `https://xxx.supabase.co`
   - **anon public key**: `eyJxxx...`
   - **service_role key**: `eyJxxx...` (관리용)

### Step 1.4: 환경변수 설정

프로젝트 루트에 `.env` 파일 생성:

```bash
# .env (gitignore에 포함됨)
SUPABASE_URL=https://xxx.supabase.co
SUPABASE_ANON_KEY=eyJxxx...
SUPABASE_SERVICE_ROLE_KEY=eyJxxx...
```

⚠️ **주의**: `.env` 파일은 절대 Git에 커밋하지 마세요!

---

## Phase 2: 데이터 마이그레이션

### Step 2.1: Staging 테이블 생성

SQL Editor에서 `load.sql`의 staging 테이블 생성 부분 실행:

```sql
create table if not exists stg_characters (payload jsonb not null);
create table if not exists stg_dialogues (payload jsonb not null);
create table if not exists stg_locations (payload jsonb not null);
create table if not exists stg_encyclopedia_entries (payload jsonb not null);
create table if not exists stg_quiz_categories (payload jsonb not null);
create table if not exists stg_quizzes (payload jsonb not null);
```

### Step 2.2: 데이터 업로드

```bash
cd /path/to/time_walker

# 전체 데이터 마이그레이션
python tools/supabase/migrate_data.py

# 특정 데이터셋만 마이그레이션
python tools/supabase/migrate_data.py --datasets characters locations

# Dry run (실제 업로드 없이 확인)
python tools/supabase/migrate_data.py --dry-run
```

### Step 2.3: Staging → Main 테이블 변환

SQL Editor에서 `load.sql` 전체 실행:

1. Dashboard → **SQL Editor** 이동
2. **New query** 클릭
3. `load.sql` 내용 복사 & 붙여넣기
4. **Run** 클릭

### Step 2.4: 데이터 검증

```bash
python tools/supabase/validate_data.py
```

예상 출력:
```
🔍 TimeWalker Supabase 데이터 검증
============================================================
URL: https://xxx.supabase.co

🔍 characters 검증...
  로컬: 52개, 원격: 52개 [✓]

🔍 locations 검증...
  로컬: 65개, 원격: 65개 [✓]

...

✅ 모든 데이터가 정상적으로 마이그레이션되었습니다!
```

---

## Phase 3: 앱 연동 테스트

### 환경변수로 실행

```bash
# iOS Simulator
flutter run -d iPhone \
  --dart-define=SUPABASE_URL=https://xxx.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJxxx...

# Android Emulator
flutter run -d android \
  --dart-define=SUPABASE_URL=https://xxx.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJxxx...
```

### VS Code launch.json 설정

`.vscode/launch.json` 파일에 추가:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "TimeWalker (Supabase)",
      "type": "dart",
      "request": "launch",
      "program": "lib/main.dart",
      "toolArgs": [
        "--dart-define=SUPABASE_URL=https://xxx.supabase.co",
        "--dart-define=SUPABASE_ANON_KEY=eyJxxx..."
      ]
    },
    {
      "name": "TimeWalker (Mock)",
      "type": "dart",
      "request": "launch",
      "program": "lib/main.dart"
    }
  ]
}
```

### 테스트 시나리오

1. **정상 연결**: 앱 실행 후 캐릭터/장소 데이터 로드 확인
2. **캐싱 테스트**: 앱 재시작 후 빠른 로드 확인
3. **오프라인 모드**: 비행기 모드에서 캐시 데이터 로드 확인
4. **Fallback**: 환경변수 없이 실행 → 로컬 JSON 사용 확인

---

## 문제 해결

### 오류: "relation does not exist"

스키마가 제대로 적용되지 않았습니다.
```sql
-- SQL Editor에서 확인
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public';
```

### 오류: "new row violates row-level security policy"

Service Role Key를 사용하지 않았습니다. 마이그레이션 시에는 Service Role Key 필요.

### 데이터가 로드되지 않음

1. 앱 로그에서 Supabase 연결 상태 확인
2. `SupabaseConfig.isConfigured` 값 확인
3. 환경변수가 올바르게 전달되는지 확인

### 캐시 초기화

Hive 캐시를 삭제하려면:
```dart
// 개발 중 캐시 초기화가 필요한 경우
await Hive.deleteBoxFromDisk('content_cache');
await Hive.deleteBoxFromDisk('content_meta');
```

---

## 추가 참고

- [Supabase Flutter 공식 문서](https://supabase.com/docs/reference/dart/introduction)
- [Row Level Security 가이드](https://supabase.com/docs/guides/auth/row-level-security)
- [Flutter 환경변수](https://dart.dev/guides/environment-declarations)
