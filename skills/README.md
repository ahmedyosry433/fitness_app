# ATOZ Project Skills

This directory contains reusable skills and templates for the **ATOZ** Flutter app.
All skills follow the current ATOZ stack: `ApiConsumer` (no Retrofit), `Result<T>`,
`executeApi` (no try/catch in repos), standalone global-shared models (no `Model extends Entity`),
`BaseCubit` + `doIntent`, `BaseState<T>` / `PaginationState<T>`, and manual `getIt` DI.

## 📚 Available Skills

### 1. ATOZ Feature Guide (`atoz-guide/`)
The authoritative, layer-by-layer guide for building any feature. Split into focused files
to keep token usage low — read `atoz-guide/00-index.md` first, then open only what you need.

| File | Contents |
|------|----------|
| `00-index.md` | Master index + quick checklist |
| `01-stack-and-structure.md` | Tech stack, folder layout, naming |
| `02-api-layer.md` | `ApiConsumer` + `RemoteDataSourceImpl` (`executeApi`) |
| `03-data-layer.md` | Entity, Model, Params, DataSource contract, RepoImpl |
| `04-domain-layer.md` | Repository contract + `BaseUseCase` |
| `05-cubit-layer.md` | `BaseCubit`, State, Events, UiEvents |
| `06-presentation-layer.md` | Page (`eventStream`) + widget rules |
| `07-strings-and-tokens.md` | Zero-hardcode policy (`AppStrings`, `AppColors`, sizing) |
| `08-di-and-routing.md` | Manual `getIt` DI order + `go_router` |
| `09-base-classes-reference.md` | Every base class + import path |
| `10-common-mistakes.md` | Real mistakes (M0–M28) with fixes |
| `11-validation-guide.md` | Per-layer validation checklist |
| `12-feature-plan.md` | Step-by-step feature plan template |
| `13-global-shared-feature.md` | Global shared data (categories, cities, …) |
| `14-clean-arch-di-guidelines.md` | Layer boundaries + entity-leakage rules |

### 2. Flutter Feature Templates (`flutter-feature-templates.md`)
Copy-paste recipe for a new feature on the ATOZ new stack.

### 3. Feature / Widget Skills
- `categories-feature.md` — Global shared categories (real reference implementation)
- `category-dropdown-field.md` — Category picker bottom-sheet field
- `role-card-widget.md` — Animated role selection card
- `mode-enum.md` — Shared `ModeEnum` (shopping / discount / both)
- `figma-mcp-implementation.md` — Figma → ATOZ Flutter playbook

---

## 🎯 Quick Start (new feature)

1. Read `atoz-guide/12-feature-plan.md` and copy the plan.
2. Build each layer following `atoz-guide/01`–`08`.
3. Use `flutter-feature-templates.md` for scaffolding.
4. Avoid pitfalls with `atoz-guide/10-common-mistakes.md`.
5. Validate with `atoz-guide/11-validation-guide.md` → `flutter analyze` clean.

---

## 📝 Naming Conventions

See `atoz-guide/01-stack-and-structure.md` for the full naming table
(feature folders, classes, params, cubits, states, events, use cases, widgets).

---

## 📚 Real Reference Implementations

- **Role-specific feature**: `lib/app_versions/merchant/sign_up/`
- **Global shared data**: `lib/core/shared/global/categories/`

---

**Last Updated**: July 2026
**Maintained by**: ATOZ Mobile Team
