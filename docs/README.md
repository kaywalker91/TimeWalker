# 📚 TimeWalker 문서 인덱스

> 최종 업데이트: 2026-01-10

이 폴더는 TimeWalker 프로젝트의 기획, 개발, 리팩토링 관련 문서를 포함합니다.

---

## 📋 핵심 문서

| 문서 | 설명 | 용량 |
|------|------|------|
| [TimeWalker_PRD.md](./TimeWalker_PRD.md) | Product Requirements Document (전체 기획서) | 80KB |
| [development_plan.md](./development_plan.md) | 전체 개발 계획 및 로드맵 | 15KB |
| [content_expansion_plan.md](./content_expansion_plan.md) | 콘텐츠 확장 계획 | 3KB |

---

## 🔧 리팩토링 문서

| 문서 | 설명 |
|------|------|
| [refactoring_plan.md](./refactoring_plan.md) | 코드 리팩토링 계획 |
| [ui_ux_refactoring_plan.md](./ui_ux_refactoring_plan.md) | UI/UX 개선 계획 |

---

## 🎨 에셋 관련 문서

| 문서 | 설명 |
|------|------|
| [character_image_prompts.md](./character_image_prompts.md) | 캐릭터 이미지 생성 AI 프롬프트 |
| [character_images_by_era.md](./character_images_by_era.md) | 시대별 캐릭터 이미지 목록 |

---

## 📅 주차별 개발 계획

| 문서 | 설명 |
|------|------|
| [week1_development_plan.md](./week1_development_plan.md) | 1주차 개발 계획 |
| [week2_development_plan.md](./week2_development_plan.md) | 2주차 개발 계획 |

---

## 📁 세부 기획 (`plans/`)

모든 세부 기획 문서는 [plans/](./plans/) 폴더에 위치합니다.

### 🏛️ 시나리오 기획

| 문서 | 시대/지역 |
|------|----------|
| [goguryeo_scenario_plan.md](./plans/goguryeo_scenario_plan.md) | 고구려 |
| [baekje_scenario_plan.md](./plans/baekje_scenario_plan.md) | 백제 |
| [silla_scenario_plan.md](./plans/silla_scenario_plan.md) | 신라 |
| [gaya_scenario_plan.md](./plans/gaya_scenario_plan.md) | 가야 |
| [gaya_dialogue_detail_plan.md](./plans/gaya_dialogue_detail_plan.md) | 가야 대화 상세 |
| [joseon_dialogue_quiz_plan.md](./plans/joseon_dialogue_quiz_plan.md) | 조선 대화/퀴즈 |
| [modern_and_future_era_plan.md](./plans/modern_and_future_era_plan.md) | 현대/미래 시대 |
| [contemporary_korea_subdivision_plan.md](./plans/contemporary_korea_subdivision_plan.md) | 현대 한국 세분화 |

### 🎮 기능 기획

| 문서 | 기능 |
|------|------|
| [quiz_expansion_plan.md](./plans/quiz_expansion_plan.md) | 퀴즈 확장 |
| [quiz_achievement_plan.md](./plans/quiz_achievement_plan.md) | 퀴즈 업적 시스템 |
| [bgm_addition_plan.md](./plans/bgm_addition_plan.md) | BGM 추가 계획 |
| [civilization_portal_plan.md](./plans/civilization_portal_plan.md) | 문명 포털 기능 |

### 🛠️ 기술/개선 기획

| 문서 | 내용 |
|------|------|
| [code_refactoring_plan.md](./plans/code_refactoring_plan.md) | 코드 리팩토링 상세 |
| [three_kingdoms_flow_improvement_plan.md](./plans/three_kingdoms_flow_improvement_plan.md) | 삼국시대 플로우 개선 |
| [three_kingdoms_navigation_improvement_plan.md](./plans/three_kingdoms_navigation_improvement_plan.md) | 삼국시대 네비게이션 개선 |
| [three_kingdoms_location_images_plan.md](./plans/three_kingdoms_location_images_plan.md) | 삼국시대 장소 이미지 |
| [location_accuracy_plan.md](./plans/location_accuracy_plan.md) | 장소 정확도 개선 |
| [character_image_generation_plan.md](./plans/character_image_generation_plan.md) | 캐릭터 이미지 생성 계획 |
| [document_image_organization_plan.md](./plans/document_image_organization_plan.md) | 📂 문서/이미지 정리 계획 |

---

## 📌 문서 작성 가이드라인

### 파일 명명 규칙
- `snake_case.md` 형식 사용
- 기능 문서: `{기능명}_plan.md`
- 시나리오 문서: `{시대/국가}_scenario_plan.md`

### 구조 가이드
```markdown
# 문서 제목

> 작성일: YYYY-MM-DD
> 상태: 초안/검토중/승인됨

## 1. 개요
## 2. 상세 내용
## 3. 실행 계획
```

### 문서 추가 시
1. 적절한 폴더에 파일 생성
2. 이 인덱스(README.md) 업데이트
3. 관련 문서 링크 추가

---

## 🔗 관련 링크

- [프로젝트 README](/README.md)
- [AGENTS.md](/AGENTS.md) - 개발 가이드라인
