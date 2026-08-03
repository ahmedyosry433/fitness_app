# ATOZ Skills Changelog

## 2026-07-02 — Repository caching (avoid refetching on navigation)

### New Rule: cache read-mostly data in the repo + `forceRefresh` GET

**What changed:**
- Read-mostly data (profile, config, contact info, lookups) is cached in the repo
  (a lazy singleton) and returned without a server request unless `forceRefresh` is passed.
- GET use cases for cacheable data take a `bool forceRefresh` param.
- Cubits show the loading skeleton only on the first load (`if (!state.x.isSuccess)`),
  refresh silently on later navigations, and expose `forceRefresh: true` for pull-to-refresh.
- The cache is updated on successful writes and cleared on logout.

**Why:**
- Each screen creates its own cubit and loads in `initState`; without a repo-level cache
  every navigation (open → back → open) triggered a redundant server request and a
  skeleton flash. The cache lives in the repo because cubits can't dedup across screens.

**Docs updated:** `03-data-layer.md` (Repository caching), `04-domain-layer.md`
(Pattern 3b), `05-cubit-layer.md` (Loading data once), `10-common-mistakes.md` (M29),
`11-validation-guide.md`.

---

## 2026-07-02 — Model (DTO) and Entity are separate classes (no inheritance)

### Breaking Rule Change: DTO ⊥ Entity

**What changed:**
- The model (DTO) MUST NOT extend the entity, and they MUST NOT be linked with
  `part` / `part of`. They are two standalone classes in two layers.
- The entity (`domain/entities/`) is a standalone class with its OWN imports and has no
  knowledge of the model. It is the UI-facing type (enums, non-null, `empty()`/`fake()`).
- The model (`data/models/`) is a standalone DTO that mirrors the API/JSON, imports the
  entity, and bridges via `toEntity()` (and `fromEntity()` only when a write path needs it).
- `fromParent` is removed as a required factory; use `fromEntity` only if needed.

**Why:**
- The DTO depends on the backend JSON shape; the entity depends on the UI. Coupling them by
  inheritance forces one to change when the other does. Separating them keeps the API shape
  and the UI shape evolving independently — the mapper is the single point of change.

**Docs updated:** `03-data-layer.md`, `04-domain-layer.md`, `10-common-mistakes.md`
(M13/M14/M17/M26), `11-validation-guide.md`, `12-feature-plan.md`, `13-global-shared-feature.md`,
`00-index.md`.

---

## 2026-07-01 — Major Update: No Retrofit + Enum Injection

### New Pattern: Direct ApiConsumer Usage (No Retrofit)

**What changed:**
- Removed intermediate `api_client` layer with Retrofit
- Remote data source implementations now use `ApiConsumer` directly
- All implementations moved to `api/data_sources/` layer

**Why:**
- Reduces boilerplate (one less layer)
- Simpler dependency chain: data_source_impl → data_source_contract → repo
- ApiConsumer already provides type-safe API calls
- Easier to maintain and debug

### Critical New Rule: Enum Injection

**What:**
- NEVER store raw strings for enum-like fields
- Always use existing enums from `lib/shared/model/` and `lib/core/enums/`

**Example:**
```dart
// ❌ WRONG
class CategoryEntity {
  final String mode;  // "shopping", "discount", "both"
}

// ✅ CORRECT
import 'package:atoz/shared/model/mode_enum.dart';

class CategoryEntity {
  final ModeEnum mode;  // Type-safe enum
}
```

**Common Enums:**
- `ModeEnum` (shopping, discount, both)
- `RoleEnum` (user, merchant, driver)
- `OrderStatus` (pending, confirmed, delivered, cancelled)

### New Skill File: 13-global-shared-feature.md

Complete guide for global shared features (categories, cities, countries):
- Structure in `lib/core/shared/global/`
- Enum injection rule with examples
- BasePaginationDto for flat pagination
- makeDummyData pattern with fixtures
- ApiConsumer direct usage
- Singleton cubit registration

### Updated Files

**02-api-layer.md:**
- Removed ApiClient class section
- Updated to show ApiConsumer direct usage in RemoteDataSourceImpl
- Added examples for GET/POST/multipart

**03-data-layer.md:**
- Added "Enum Injection" section at top (critical rule)
- Examples showing ModeEnum conversion in models
- Enum parsing helpers (_parseModeEnum)

**08-di-and-routing.md:**
- Updated DI registration order (removed api_client step)
- Separated role-specific vs global shared feature patterns
- Updated singleton usage for global cubits

**09-base-classes-reference.md:**
- Added `BasePaginationDto<T>` entry
- Added `BasePaginationEntity<T>` entry
- Added `ModeEnum` entry
- Added `RoleEnum` entry
- Updated `Result<T>` to include `.makeDummyData()`

**10-common-mistakes.md:**
- Added M0: Using raw strings instead of enums (CRITICAL)
- Added M18: Using Retrofit instead of ApiConsumer
- Added M19: Passing filterList to PaginationParams super
- Added M20: Remote data source impl in wrong layer
- Added M21: Forgetting makeDummyData for global features
- Added M22: Registering global cubit as factory instead of singleton

**12-feature-plan.md:**
- Added enum check in Step 0 (Prep)
- Updated Step 1b entity checklist to include enum fields
- Updated Step 3 to remove api_client, show ApiConsumer usage
- Updated Step 6 DI to show new registration order

**00-index.md:**
- Added reference to new file 13

### Key Takeaways for Developers

1. **Check for existing enums FIRST** before creating string fields
2. **Use ApiConsumer directly** in remote data source implementations
3. **Global shared features** need singleton cubits and makeDummyData
4. **PaginationParams subclasses** must override `filterList` getter
5. **Remote data source impls** go in `api/data_sources/`, contracts in `data/data_sources/`

### Migration Guide

If you have existing features using the old pattern:

1. **Remove api_client class** — delete the file
2. **Move network calls** to RemoteDataSourceImpl
3. **Import ApiConsumer** instead of api_client
4. **Update DI registration** — remove api_client step
5. **Search for string fields** that should be enums
6. **Add enum parsing** in model.fromJson()
7. **Convert enum to string** in model.toJson() using `.name`

### Files Modified

- `.kiro/skills/atoz-guide/00-index.md`
- `.kiro/skills/atoz-guide/02-api-layer.md`
- `.kiro/skills/atoz-guide/03-data-layer.md`
- `.kiro/skills/atoz-guide/08-di-and-routing.md`
- `.kiro/skills/atoz-guide/09-base-classes-reference.md`
- `.kiro/skills/atoz-guide/10-common-mistakes.md`
- `.kiro/skills/atoz-guide/12-feature-plan.md`

### Files Created

- `.kiro/skills/atoz-guide/13-global-shared-feature.md`
- `.kiro/skills/atoz-guide/CHANGELOG.md` (this file)

---

## Previous Updates

(No previous changelog — this is the first documented update)
