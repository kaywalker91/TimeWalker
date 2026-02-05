# TimeWalker Documentation Index

> Last updated: 2026-02-05

This folder contains planning, development, and reference documents for TimeWalker.

---

## Directory Structure

```
docs/
├── README.md                    # This index
├── TimeWalker_PRD.md           # Product Requirements Document
├── architecture/               # System design & architecture
├── content/                    # Content specifications
├── development/                # Development plans & guides
├── reviews/                    # Code reviews & test reports
├── plans/                      # Detailed feature plans
│   ├── scenario/              # Era/region scenario plans
│   ├── content-generation/    # Image & BGM generation plans
│   ├── infrastructure/        # Technical infrastructure plans
│   └── feature/               # Feature implementation plans
├── reports/                    # Status reports
└── assets/                     # Screenshots & media files
```

---

## Core Documents

| Document | Description |
|----------|-------------|
| [TimeWalker_PRD.md](./TimeWalker_PRD.md) | Product Requirements Document |
| [architecture/ARCHITECTURE.md](./architecture/ARCHITECTURE.md) | System architecture, layers, data flow |

---

## Architecture (`architecture/`)

| Document | Description |
|----------|-------------|
| [ARCHITECTURE.md](./architecture/ARCHITECTURE.md) | System architecture overview |
| [refactoring_plan.md](./architecture/refactoring_plan.md) | Code refactoring plan |
| [ui_ux_refactoring_plan.md](./architecture/ui_ux_refactoring_plan.md) | UI/UX improvement plan |

---

## Content (`content/`)

| Document | Description |
|----------|-------------|
| [character_image_prompts.md](./content/character_image_prompts.md) | AI prompts for character images |
| [character_images_by_era.md](./content/character_images_by_era.md) | Character images organized by era |
| [content_expansion_plan.md](./content/content_expansion_plan.md) | Content expansion roadmap |

---

## Development (`development/`)

| Document | Description |
|----------|-------------|
| [development_plan.md](./development/development_plan.md) | Overall development roadmap |
| [week1_development_plan.md](./development/week1_development_plan.md) | Week 1 plan |
| [week2_development_plan.md](./development/week2_development_plan.md) | Week 2 plan |
| [admin_mode_implementation.md](./development/admin_mode_implementation.md) | Admin mode guide |
| [plan_goguryeo_content_update.md](./development/plan_goguryeo_content_update.md) | Goguryeo content update |

---

## Reviews & Testing (`reviews/`)

| Document | Description |
|----------|-------------|
| [code_review_2026_01_12.md](./reviews/code_review_2026_01_12.md) | Code review report |
| [test_plan_2026_01_14.md](./reviews/test_plan_2026_01_14.md) | Test plan |
| [phase2_test_foundation_complete.md](./reviews/phase2_test_foundation_complete.md) | Phase 2 completion report |
| [phase3_refactoring_complete.md](./reviews/phase3_refactoring_complete.md) | Phase 3 completion report |

---

## Feature Plans (`plans/`)

### Scenario Plans (`plans/scenario/`)

| Document | Era/Region |
|----------|------------|
| [goguryeo_scenario_plan.md](./plans/scenario/goguryeo_scenario_plan.md) | Goguryeo |
| [baekje_scenario_plan.md](./plans/scenario/baekje_scenario_plan.md) | Baekje |
| [silla_scenario_plan.md](./plans/scenario/silla_scenario_plan.md) | Silla |
| [gaya_scenario_plan.md](./plans/scenario/gaya_scenario_plan.md) | Gaya |
| [gaya_dialogue_detail_plan.md](./plans/scenario/gaya_dialogue_detail_plan.md) | Gaya dialogues |
| [joseon_dialogue_quiz_plan.md](./plans/scenario/joseon_dialogue_quiz_plan.md) | Joseon |
| [three_kingdoms_flow_improvement_plan.md](./plans/scenario/three_kingdoms_flow_improvement_plan.md) | Three Kingdoms flow |

### Content Generation (`plans/content-generation/`)

| Document | Description |
|----------|-------------|
| [character_image_generation_plan.md](./plans/content-generation/character_image_generation_plan.md) | Character image generation |
| [location_image_generation_plan.md](./plans/content-generation/location_image_generation_plan.md) | Location image generation |
| [missing_image_generation_plan.md](./plans/content-generation/missing_image_generation_plan.md) | Missing images |
| [three_kingdoms_location_images_plan.md](./plans/content-generation/three_kingdoms_location_images_plan.md) | Three Kingdoms location images |
| [bgm_addition_plan.md](./plans/content-generation/bgm_addition_plan.md) | BGM addition |

### Infrastructure (`plans/infrastructure/`)

| Document | Description |
|----------|-------------|
| [supabase_migration_plan.md](./plans/infrastructure/supabase_migration_plan.md) | Supabase migration |
| [code_refactoring_plan.md](./plans/infrastructure/code_refactoring_plan.md) | Code refactoring |
| [docs_markdown_organization_plan.md](./plans/infrastructure/docs_markdown_organization_plan.md) | Markdown organization |
| [document_image_organization_plan.md](./plans/infrastructure/document_image_organization_plan.md) | Document/image organization |

### Feature Implementation (`plans/feature/`)

| Document | Description |
|----------|-------------|
| [civilization_portal_plan.md](./plans/feature/civilization_portal_plan.md) | Civilization portal |
| [contemporary_korea_subdivision_plan.md](./plans/feature/contemporary_korea_subdivision_plan.md) | Contemporary Korea subdivision |
| [goguryeo_content_plan.md](./plans/feature/goguryeo_content_plan.md) | Goguryeo content |
| [location_accuracy_plan.md](./plans/feature/location_accuracy_plan.md) | Location accuracy |
| [modern_and_future_era_plan.md](./plans/feature/modern_and_future_era_plan.md) | Modern/Future era |
| [quiz_achievement_plan.md](./plans/feature/quiz_achievement_plan.md) | Quiz achievements |
| [quiz_expansion_plan.md](./plans/feature/quiz_expansion_plan.md) | Quiz expansion |
| [three_kingdoms_navigation_improvement_plan.md](./plans/feature/three_kingdoms_navigation_improvement_plan.md) | Three Kingdoms navigation |
| [three_kingdoms_ui_redesign_plan.md](./plans/feature/three_kingdoms_ui_redesign_plan.md) | Three Kingdoms UI redesign |

---

## Reports (`reports/`)

| Document | Description |
|----------|-------------|
| [image_generation_status.md](./reports/image_generation_status.md) | Image generation status |

---

## Assets (`assets/`)

| Content | Description |
|---------|-------------|
| [screenshots/](./assets/screenshots/) | App screenshots |
| [index.html](./assets/index.html) | HTML preview page |

---

## Project-Level Documents

| Document | Location | Description |
|----------|----------|-------------|
| [README.md](../README.md) | Root | Project overview |
| [CHANGELOG.md](../CHANGELOG.md) | Root | Version history |
| [CONTRIBUTING.md](../CONTRIBUTING.md) | Root | Contribution guidelines |
| [SECURITY.md](../SECURITY.md) | Root | Security policy |

---

## Documentation Guidelines

### File Naming

- Use `snake_case.md`
- Feature docs: `{feature}_plan.md`
- Scenario docs: `{era}_scenario_plan.md`

### Document Structure

```markdown
# Document Title

> Created: YYYY-MM-DD
> Status: Draft | Review | Approved

## 1. Overview
## 2. Details
## 3. Implementation Plan
```

### Adding New Documents

1. Create file in appropriate folder
2. Update this index (README.md)
3. Add links to related documents

---

## Related Links

- [Project README](../README.md)
- [Contributing Guide](../CONTRIBUTING.md)
- [Agent Skills](../.agent/skills/)
