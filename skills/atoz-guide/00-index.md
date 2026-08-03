---
name: atoz-feature-guide
description: >
  Master index for building any feature in ATOZ Flutter. Covers every layer
  (API → data → domain → presentation), base classes, widget rules, zero-hardcode
  strings, DI, routing, validation, global shared data, and a step-by-step plan.
  Split into focused files to keep token usage low. Read 00-index first, then open
  only the file you need.
  Trigger on: feature, cubit, repository, use case, data source, clean architecture,
  new screen, global shared, categories, enum injection, انشاء feature, نيو فيتشر,
  sign-up, wizard, widget, pagination, BasePaginationDto, ModeEnum, makeDummyData.
---

# ATOZ Feature Guide — Master Index

> Reference implementation: `lib/app_versions/merchant/sign_up/`
> Global shared reference: `lib/core/shared/global/categories/`
> Every pattern here is verified against those features.

---

## How to Use This Guide

1. **Planning a new feature** → read `12-feature-plan.md` first.
2. **Building a feature layer** → open the matching numbered file.
3. **Building global shared data** → read `13-global-shared-feature.md`.
4. **Stuck on an error** → `10-common-mistakes.md`.
5. **Adding strings / avoiding hardcode** → `07-strings-and-tokens.md`.
6. **Validating your work** → `11-validation-guide.md` last.

---

## File Map

| File | Contents |
|------|----------|
| `01-stack-and-structure.md` | Tech stack table, folder layout, naming conventions |
| `02-api-layer.md` | ApiConsumer (not Retrofit) + RemoteDataSourceImpl patterns |
| `03-data-layer.md` | Entity (standalone) + Response Model/DTO (standalone, fromJson/toJson/toEntity), Params, DataSource contract, RepoImpl |
| `04-domain-layer.md` | Repository contract, UseCase (5 patterns: with params, no params, string, void, legacy) |
| `05-cubit-layer.md` | BaseCubit, State (BaseState<T>), Events (sealed), UiEvents — all 4 files |
| `06-presentation-layer.md` | Page (StatefulWidget + eventStream), Widget rules |
| `07-strings-and-tokens.md` | Zero-hardcode policy, AppStrings usage table |
| `08-di-and-routing.md` | DI registration order, GoRoute setup |
| `09-base-classes-reference.md` | Quick-reference table of every base class + import |
| `10-common-mistakes.md` | Real mistakes with wrong/right code |
| `11-validation-guide.md` | How to validate each layer before moving on |
| `12-feature-plan.md` | Step-by-step plan template for any feature |
| `13-global-shared-feature.md` | Global shared data (categories etc.) — flat pagination, ModeEnum.both, makeDummyData, full templates |

---

## Quick Checklist (full detail in `12-feature-plan.md`)

- [ ] Strings + Endpoints added (`07`, `08`)
- [ ] Enum fields use existing enums — never raw strings (`ModeEnum` has `shopping`/`discount`/`both`); use `.value` in `toJson`, `.fromString()` in `fromJson` — never `.name` (`M0`)
- [ ] Params model extends `PaginationParams` with `copyWith` + `filterList` **override** (not super constructor) (`M19`)
- [ ] Domain repo + use case returning `Result<T>` (not `Either`) (`04`)
- [ ] DataSource contract returns `Result<T>`, impl uses `executeApi` — no try/catch (`02`, `03`)
- [ ] RepoImpl uses `makeDummyData` for global shared features; `ModeEnum.both` passes every mode filter (`13`, `M27`)
- [ ] Response DTO subclass: delegates to `BasePaginationDto<T>.fromJson()`, calls `super.toJson()` first (`13`, `M24`, `M25`)
- [ ] Paginated state uses `PaginationState<T>` — never `BaseState<BasePaginationEntity<T>>` (`M23`)
- [ ] Cubit: `BaseCubit`, `doIntent`, loading guard `isLoading`, load-more guard `canLoadMore`, `toSuccessFromEntity` (`05`, `M23`)
- [ ] Page: `eventStream` subscription, dispose correctly (`06`)
- [ ] Widgets: one class per file, no `_buildX`, `AppStrings` everywhere (`06`, `07`)
- [ ] DI: data_source_impl → data_source → repo → use_case → cubit registered in order (`08`)
- [ ] Route: constant + GoRoute + argument validation (`08`)
- [ ] `flutter analyze` → No issues found (`11`)
