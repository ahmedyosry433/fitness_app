# Skills Quick Index

## 🎯 What Do You Need?

### 📖 I want to understand the architecture / build a feature
→ Start: `atoz-guide/00-index.md` (master index for every layer)
- API → data → domain → presentation, layer by layer
- Base classes, DI, routing, strings/tokens, validation
- Step-by-step feature plan

### 📋 I need a quick code template
→ Use: `flutter-feature-templates.md`
- ATOZ new-stack recipe (Result + BaseState + BaseCubit)
- Copy-paste starting points for each layer

### 🐛 I'm getting errors / avoiding pitfalls
→ Check: `atoz-guide/10-common-mistakes.md`
- Real mistakes (M0–M28) with wrong/right code
→ Validate: `atoz-guide/11-validation-guide.md`

### 🚀 I'm creating a new feature
→ Follow this order:
1. `atoz-guide/12-feature-plan.md` (plan template)
2. `atoz-guide/01`–`08` (build each layer)
3. `atoz-guide/10-common-mistakes.md` + `11-validation-guide.md` (avoid errors, validate)

### 📚 I need a categories/subjects feature (global shared)
→ Read: `categories-feature.md`
- Real ATOZ implementation (July 2026)
- Flat pagination, `ModeEnum.both` catch-all, `makeDummyData`
- `ApiConsumer` + `executeApi` data source pattern
→ Also: `atoz-guide/13-global-shared-feature.md`

### 🃏 I need a role selection card
→ Read: `role-card-widget.md`

### 🔄 I need to work with app mode (shopping/discount/both)
→ Read: `mode-enum.md`

### 📥 I need a category picker field (bottom sheet)
→ Read: `category-dropdown-field.md`

### 🎨 I'm turning a Figma screen into Flutter
→ Read: `figma-mcp-implementation.md`

---

## 📁 Files Overview

| File | Purpose |
|------|---------|
| `README.md` | Overview of all skills |
| `INDEX.md` | Quick navigation (this file) |
| `atoz-guide/` | Authoritative per-layer ATOZ feature guide (00–14) |
| `flutter-feature-templates.md` | ATOZ new-stack code templates |
| `categories-feature.md` | Global shared categories (ATOZ real impl) |
| `category-dropdown-field.md` | Category picker bottom-sheet field |
| `role-card-widget.md` | Animated role selection card widget |
| `mode-enum.md` | Shared `ModeEnum` (shopping / discount / both) |
| `figma-mcp-implementation.md` | Figma → ATOZ Flutter playbook |

---

## 💡 Pro Tips

1. `atoz-guide/09-base-classes-reference.md` — quick table of every base class + import
2. Reference `lib/app_versions/merchant/sign_up/` for a real feature example
3. Reference `lib/core/shared/global/categories/` for global shared data
4. Enum fields: `ModeEnum.fromString()` in `fromJson`, `.value` in `toJson`
5. Paginated lists use `PaginationState<T>`, single objects use `BaseState<T>`

---

**Last Updated**: July 2026
