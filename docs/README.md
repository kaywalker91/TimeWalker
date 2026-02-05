# TimeWalker Documentation Index

> Last updated: 2026-02-05

This folder contains planning, development, and reference documents for TimeWalker.

---

## Core Documents

| Document | Description |
|----------|-------------|
| [ARCHITECTURE.md](./ARCHITECTURE.md) | System architecture, layers, data flow, tech stack |
| [TimeWalker_PRD.md](./TimeWalker_PRD.md) | Product Requirements Document |
| [development_plan.md](./development_plan.md) | Development roadmap |
| [content_expansion_plan.md](./content_expansion_plan.md) | Content expansion plan |

---

## Project-Level Documents

| Document | Location | Description |
|----------|----------|-------------|
| [README.md](../README.md) | Root | Project overview and quick start |
| [CHANGELOG.md](../CHANGELOG.md) | Root | Version history |
| [CONTRIBUTING.md](../CONTRIBUTING.md) | Root | Contribution guidelines |
| [SECURITY.md](../SECURITY.md) | Root | Security policy |

---

## GitHub Templates

| Template | Location |
|----------|----------|
| [Pull Request Template](../.github/PULL_REQUEST_TEMPLATE.md) | `.github/` |
| [Bug Report](../.github/ISSUE_TEMPLATE/bug_report.md) | `.github/ISSUE_TEMPLATE/` |
| [Feature Request](../.github/ISSUE_TEMPLATE/feature_request.md) | `.github/ISSUE_TEMPLATE/` |

---

## Refactoring Documents

| Document | Description |
|----------|-------------|
| [refactoring_plan.md](./refactoring_plan.md) | Code refactoring plan |
| [ui_ux_refactoring_plan.md](./ui_ux_refactoring_plan.md) | UI/UX improvement plan |

---

## Asset Documents

| Document | Description |
|----------|-------------|
| [character_image_prompts.md](./character_image_prompts.md) | AI prompts for character images |
| [character_images_by_era.md](./character_images_by_era.md) | Character images by era |

---

## Weekly Development Plans

| Document | Description |
|----------|-------------|
| [week1_development_plan.md](./week1_development_plan.md) | Week 1 plan |
| [week2_development_plan.md](./week2_development_plan.md) | Week 2 plan |

---

## Feature Plans (`plans/`)

All detailed feature plans are in the [plans/](./plans/) folder.

### Scenario Plans

| Document | Era/Region |
|----------|------------|
| [goguryeo_scenario_plan.md](./plans/goguryeo_scenario_plan.md) | Goguryeo |
| [baekje_scenario_plan.md](./plans/baekje_scenario_plan.md) | Baekje |
| [silla_scenario_plan.md](./plans/silla_scenario_plan.md) | Silla |
| [gaya_scenario_plan.md](./plans/gaya_scenario_plan.md) | Gaya |
| [gaya_dialogue_detail_plan.md](./plans/gaya_dialogue_detail_plan.md) | Gaya dialogues |
| [joseon_dialogue_quiz_plan.md](./plans/joseon_dialogue_quiz_plan.md) | Joseon |
| [modern_and_future_era_plan.md](./plans/modern_and_future_era_plan.md) | Modern/Future |
| [contemporary_korea_subdivision_plan.md](./plans/contemporary_korea_subdivision_plan.md) | Contemporary Korea |

### Feature Plans

| Document | Feature |
|----------|---------|
| [quiz_expansion_plan.md](./plans/quiz_expansion_plan.md) | Quiz expansion |
| [quiz_achievement_plan.md](./plans/quiz_achievement_plan.md) | Quiz achievements |
| [bgm_addition_plan.md](./plans/bgm_addition_plan.md) | BGM addition |
| [civilization_portal_plan.md](./plans/civilization_portal_plan.md) | Civilization portal |

### Technical Plans

| Document | Description |
|----------|-------------|
| [code_refactoring_plan.md](./plans/code_refactoring_plan.md) | Code refactoring |
| [three_kingdoms_flow_improvement_plan.md](./plans/three_kingdoms_flow_improvement_plan.md) | Three Kingdoms flow |
| [three_kingdoms_navigation_improvement_plan.md](./plans/three_kingdoms_navigation_improvement_plan.md) | Three Kingdoms navigation |
| [three_kingdoms_location_images_plan.md](./plans/three_kingdoms_location_images_plan.md) | Three Kingdoms images |
| [location_accuracy_plan.md](./plans/location_accuracy_plan.md) | Location accuracy |
| [character_image_generation_plan.md](./plans/character_image_generation_plan.md) | Character image generation |
| [document_image_organization_plan.md](./plans/document_image_organization_plan.md) | Document/image organization |
| [docs_markdown_organization_plan.md](./plans/docs_markdown_organization_plan.md) | Markdown organization |

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
