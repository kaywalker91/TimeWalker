# 📂 문서/이미지 파일 정리 계획

> 작성일: 2026-01-10  
> 작성자: AI Assistant (100년차 Flutter 리팩토링 전문가 역할)  
> 상태: **승인됨** (3회 자체 점검 완료)

---

## 📋 목차

1. [현재 상태 분석](#1-현재-상태-분석)
2. [문제점 식별](#2-문제점-식별)
3. [정리 계획](#3-정리-계획)
4. [자체 점검 결과](#4-자체-점검-결과)
5. [단계별 실행 방법](#5-단계별-실행-방법)
6. [활용 도구 및 기법](#6-활용-도구-및-기법)

---

## 1. 현재 상태 분석

### 1.1 문서 파일 현황 (`docs/`)

| 경로 | 파일 수 | 설명 |
|------|---------|------|
| `docs/` (루트) | 9개 | PRD, 개발계획, 리팩토링 계획 등 |
| `docs/plans/` | 18개 | 시나리오별, 기능별 세부 기획서 |
| 프로젝트 루트 | 2개 | README.md, AGENTS.md |

**총 29개 문서 파일**

### 1.2 이미지 파일 현황 (`assets/images/`)

| 폴더 | 파일 수 | 설명 |
|------|---------|------|
| `characters/` | 9개 하위폴더 + 2개 파일 | 시대별 캐릭터 일러스트 |
| `locations/` | 30개 | 배경 이미지 (bg + thumb) |
| `encyclopedia/` | 6개 | 백과사전 이미지 |
| `eras/` | 2개 | 시대 대표 이미지 |
| `map/` | 2개 | 지도 이미지 |
| `ui/` | 0개 | 빈 폴더 |
| `screenshoot/` | 2개 | 앱 스크린샷 (폴더명 오타) |

**총 약 80개 이미지 파일**

---

## 2. 문제점 식별

### 🔴 Critical (즉시 수정 필요)

| # | 문제 | 위치 | 영향도 |
|---|------|------|--------|
| 1 | 폴더명 오타: `screenshoot` | `assets/images/screenshoot/` | 개발자 혼란, 비표준 |
| 2 | 비표준 파일명 | `KakaoTalk_Photo_*.jpeg` | 프로젝트 컨벤션 위반 |

### 🟡 Warning (개선 권장)

| # | 문제 | 위치 | 영향도 |
|---|------|------|--------|
| 3 | Orphan 파일 | `characters/sebastian_munster.png` | 분류 누락 |
| 4 | 문서 인덱스 부재 | `docs/` | 문서 발견성 저하 |
| 5 | 빈 폴더 | `assets/images/ui/` | 향후 사용 대비 여부 불명확 |

### ✅ Good (유지)

- `characters/placeholder.png`: 공용 fallback 이미지로 적절한 위치
- `docs/plans/` 구조: 일관된 네이밍 (`*_plan.md`)
- 시대별 캐릭터 폴더 구조: 확장성 우수

---

## 3. 정리 계획

### 3.1 이미지 파일 정리

```
# Before
assets/images/
├── screenshoot/                    ❌ 오타
│   ├── KakaoTalk_Photo_2025-12-23-14-31-02.jpeg  ❌ 비표준
│   └── KakaoTalk_Photo_2025-12-23-16-11-13.jpeg  ❌ 비표준
├── characters/
│   ├── placeholder.png             ✓ 유지
│   ├── sebastian_munster.png       ❌ 잘못된 위치
│   └── renaissance/                (빈 폴더)

# After
assets/images/
├── screenshots/                    ✓ 수정됨
│   ├── app_screenshot_20251223_01.jpeg  ✓ 표준화
│   └── app_screenshot_20251223_02.jpeg  ✓ 표준화
├── characters/
│   ├── placeholder.png             ✓ 유지
│   └── renaissance/
│       └── sebastian_munster.png   ✓ 이동됨
```

### 3.2 문서 파일 정리

```
# Before
docs/
├── TimeWalker_PRD.md
├── development_plan.md
├── ... (인덱스 없음)
└── plans/
    └── (18개 파일)

# After
docs/
├── README.md                       ✓ 신규 (문서 인덱스)
├── TimeWalker_PRD.md
├── development_plan.md
├── ...
└── plans/
    └── (18개 파일, 본 계획서 포함)
```

---

## 4. 자체 점검 결과

### 점검 알고리즘

```
FOR iteration IN [1, 2, 3]:
  CHECK_1: 일관성 검증 (명명 규칙, 정렬 기준)
  CHECK_2: 실용성 검증 (코드 변경 최소화, pubspec 영향)
  CHECK_3: 확장성 검증 (향후 콘텐츠 추가 대응)
  CHECK_4: 호환성 검증 (경로 참조, Git 히스토리)
  CHECK_5: 복잡도 검증 (폴더 깊이, 빈 폴더)
```

### 점검 이력

| 회차 | 결과 | 수정 사항 |
|------|------|----------|
| 1차 | ⚠️ 부분 실패 | docs 과도한 세분화 → plans 폴더 유지로 변경 |
| 2차 | ⚠️ 부분 실패 | 확장성 우려 → README 인덱스로 대응, 재구조화는 보류 |
| 3차 | ✅ 통과 | 최종 계획 승인 |

### 코드 참조 검증 결과

```bash
# screenshoot 경로 참조 검색
grep -ri "screenshoot" lib/ → 결과 없음 ✓

# sebastian_munster.png 참조 검색  
grep -ri "sebastian_munster" lib/ → 결과 없음 ✓
```

**결론: 코드 수정 없이 파일 이동 가능**

---

## 5. 단계별 실행 방법

### Phase 1: 사전 검증 (예상 2분)

```bash
# Step 1.1: Git 상태 확인
cd /Users/kaywalker/AndroidStudioProjects/time_walker
git status

# Step 1.2: 현재 구조 백업 (선택)
# git stash 또는 별도 브랜치 생성
git checkout -b refactor/organize-docs-images
```

### Phase 2: 이미지 파일 정리 (예상 5분)

```bash
# Step 2.1: 폴더명 수정
mv assets/images/screenshoot assets/images/screenshots

# Step 2.2: 파일명 표준화
mv "assets/images/screenshots/KakaoTalk_Photo_2025-12-23-14-31-02.jpeg" \
   "assets/images/screenshots/app_screenshot_20251223_01.jpeg"
mv "assets/images/screenshots/KakaoTalk_Photo_2025-12-23-16-11-13.jpeg" \
   "assets/images/screenshots/app_screenshot_20251223_02.jpeg"

# Step 2.3: sebastian_munster.png 이동
mv assets/images/characters/sebastian_munster.png \
   assets/images/characters/renaissance/

# Step 2.4: ui 폴더에 .gitkeep 확인
ls -la assets/images/ui/
# .gitkeep 없으면: touch assets/images/ui/.gitkeep
```

### Phase 3: 문서 파일 정리 (예상 5분)

```bash
# Step 3.1: docs/README.md 생성 (아래 템플릿 사용)
# (별도 파일로 생성 예정)

# Step 3.2: 현재 계획서를 plans 폴더에 저장 (이미 완료)
```

### Phase 4: 최종 검증 (예상 3분)

```bash
# Step 4.1: Flutter 정적 분석
flutter analyze

# Step 4.2: 애셋 등록 확인 (pubspec.yaml 변경 불필요 확인)
# screenshots 폴더는 images/ 하위이므로 자동 포함

# Step 4.3: Git 커밋
git add -A
git commit -m "Refactor: organize docs and image assets

- Rename screenshoot → screenshots (typo fix)
- Standardize screenshot filenames
- Move sebastian_munster.png to renaissance/
- Add docs index README.md"
```

---

## 6. 활용 도구 및 기법

### 6.1 Sequential Thinking MCP

**용도**: 체계적 분석 및 3회 자체 점검

**활용 시점**:
- 1단계: 현재 상태 분석
- 2단계: 정리 계획 수립
- 3-6단계: 점검 알고리즘 생성 및 3회 반복 점검
- 7-8단계: 실행 계획 및 최종 결론

**효과**: 
- 초기 계획의 과도한 세분화 문제 발견 및 수정
- 호환성/실용성 측면 검증으로 안전한 계획 도출

### 6.2 파일 탐색 도구

| 도구 | 용도 |
|------|------|
| `list_dir` | 폴더 구조 파악 |
| `find_by_name` | 문서/이미지 파일 전체 목록 |
| `grep_search` | 코드 내 경로 참조 확인 |
| `view_file` | 기존 문서 내용 분석 |

### 6.3 적용한 리팩토링 원칙

1. **최소 변경 원칙**: 기존 구조 대부분 유지
2. **일관성 우선**: 네이밍 규칙 통일
3. **점진적 개선**: 인덱스 추가 → 향후 재구조화
4. **안전성 확보**: 코드 참조 사전 검증

---

## 📎 부록: docs/README.md 템플릿

```markdown
# 📚 TimeWalker 문서 인덱스

## 프로젝트 문서

| 문서 | 설명 |
|------|------|
| [TimeWalker_PRD.md](./TimeWalker_PRD.md) | Product Requirements Document |
| [development_plan.md](./development_plan.md) | 전체 개발 계획 |
| [refactoring_plan.md](./refactoring_plan.md) | 코드 리팩토링 계획 |
| [ui_ux_refactoring_plan.md](./ui_ux_refactoring_plan.md) | UI/UX 개선 계획 |

## 캐릭터/에셋 문서

| 문서 | 설명 |
|------|------|
| [character_image_prompts.md](./character_image_prompts.md) | 캐릭터 이미지 생성 프롬프트 |
| [character_images_by_era.md](./character_images_by_era.md) | 시대별 캐릭터 이미지 목록 |

## 세부 기획 (plans/)

[📁 plans 폴더 보기](./plans/)

### 시나리오
- [baekje_scenario_plan.md](./plans/baekje_scenario_plan.md)
- [silla_scenario_plan.md](./plans/silla_scenario_plan.md)
- [goguryeo_scenario_plan.md](./plans/goguryeo_scenario_plan.md)
- [gaya_scenario_plan.md](./plans/gaya_scenario_plan.md)

### 기능
- [quiz_expansion_plan.md](./plans/quiz_expansion_plan.md)
- [bgm_addition_plan.md](./plans/bgm_addition_plan.md)
- [civilization_portal_plan.md](./plans/civilization_portal_plan.md)
```

---

**문서 끝**
