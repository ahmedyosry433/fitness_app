# 14 — Clean Architecture & DI Guidelines

Core rules that apply to **every** layer in every feature.

---

## 1. Layer Boundaries — What Each Layer Must Never Do

| Layer | Never do |
|---|---|
| **Domain** | Import Dio, DTO classes, `dart:io`, database, or API clients |
| **Data** | Contain business logic; expose DTOs to domain |
| **API** | Accept or return domain entities; contain mapping logic |
| **Presentation** | Call repositories or data sources directly; hold raw JSON |

---

## 2. Dependency Injection — Inject, Never Create

```dart
// ❌ — manually instantiating a dependency inside a class
class MerchantSignUpRepoImpl implements MerchantSignUpRepo {
  final _ds = MerchantSignUpRemoteDataSourceImpl(DioConsumer()); // ❌
}

// ✅ — receive it through the constructor
class MerchantSignUpRepoImpl implements MerchantSignUpRepo {
  final MerchantSignUpRemoteDataSource _ds;
  MerchantSignUpRepoImpl(this._ds); // ✅ — injected via getIt
}
```

**Register in order**: impl → contract → repo → use_case → cubit  
See `08-di-and-routing.md` for the full pattern.

---

## 3. Entity Injection Pattern — Always Pass Full Entities

When working with domain objects like categories, **always pass the full entity** through events, cubits, and params. Extract primitives only at the API boundary in `toFormData()`.

```dart
// ✅ — Entity injected through all domain/presentation layers
class MerchantSignUpParams {
  final CategoryDiscountEntity? category;  // ✅ full entity injected
  
  Future<FormData> toFormData() async {
    return FormData.fromMap({
      if (category != null) 'category': category?.id,  // ✅ extract ID only here
    });
  }
}

// In cubit
void _saveStep2(SaveStep2Event e) {
  params = params.copyWith(
    category: e.category,  // ✅ inject full entity
  );
}

// In widget
CategoryDropdownField(
  onSelected: (CategoryDiscountEntity category) {
    _selectedCategory = category;  // ✅ hold entity reference
  },
)

// In event
class SaveStep2Event extends MerchantSignUpEvent {
  final CategoryDiscountEntity? category;  // ✅ pass entity through event
}
```

**Why**: The entity contains all data needed across the flow (name for display, discount for calculations, id for API). This keeps domain logic clean and avoids re-fetching.

### API Layer Never Receives Entities Directly

The API layer must never import or accept domain entities. Params handle the extraction internally:

```dart
// ❌ — API layer depends on domain entity
abstract class MerchantSignUpDataSource {
  Future<Result<void>> register({ required CategoryEntity category }); // ❌ NEVER
}

// ✅ — API layer receives params that internally extract primitives
abstract class MerchantSignUpDataSource {
  Future<Result<void>> register(MerchantSignUpParams params); // ✅
}

// In impl — params extracts ID internally via toFormData()
await client.post(
  path: EndPoints.merchantRegister,
  data: await params.toFormData(), // ✅ ID extracted inside params
);
```

**Key Rule**: Entities flow through **domain**, **events**, **cubit**, and **params**, but are **extracted to primitives** in `toFormData()` / `toJson()` before reaching the API layer.

---

## 4. Data Mapping — Only at Layer Boundaries

```
API response (JSON)
      ↓  [API layer]  fromJson → DTO
      ↓  [Data layer] DTO.toEntity() → Entity
      ↓  [Domain / Cubit] uses Entity only
```

- **Never** call `DTO.toEntity()` inside the API layer.
- **Never** call `Entity.toJson()` directly from a cubit.
- Mapping belongs in the **repository** (data layer boundary).

```dart
// ✅ — mapping in RepoImpl (data layer)
@override
Future<Result<CategoryEntity>> getCategoryById(String id) async {
  final result = await remoteDataSource.getCategoryById(id); // Result<CategoryModel>
  return result.when(
    success: (model) => Success(data: model?.toEntity()),    // map here
    error:   (e)     => Error(exception: e),
  );
}
```

---

## 5. Entity Leakage — Checklist

Before shipping any layer:

```
[ ] API layer methods accept only: primitives, DTOs, Params (never Entity directly)
[ ] API layer never imports: CategoryEntity, UserEntity, *Entity
[ ] Domain layer never imports: Dio, FormData, DTO classes
[ ] Mapping (toEntity / fromJson) happens only in Data layer
[ ] Params class can hold entities when UI needs them; extracts primitives in toFormData()
[ ] Events can pass entities from widgets to cubit (e.g., SaveStep2Event)
[ ] DI: every class receives its dependencies via constructor, never creates them
```

---

## 6. Params Class Rules

Params accumulate input across a wizard or form. They live in `domain/entity/` or `domain/entities/`.

```dart
class MerchantSignUpParams {
  // Step 1
  final String fullName;
  final String phone;
  final String password;

  // Step 2
  final String storeName;
  final CategoryDiscountEntity? category;  // ✅ full entity when UI needs it
  final AddressModel? storeAddress;
  final File? storeLogo;

  // Step 3
  final int discountPercentage;

  // Phone code and ID extraction happen HERE, not in cubit
  Future<FormData> toFormData() async {
    return FormData.fromMap({
      'phone': '${AppConstants.phoneCode}$phone',     // ✅
      if (category != null) 'category': category?.id, // ✅ extract ID at serialization
      // ...
    });
  }
}
```

Key rules:
- **Entities allowed in params** when UI needs to display/use entity properties (name, discount, etc.)
- **Extract primitives in `toFormData()`** — never pass entity objects to API layer
- Phone code/formatting belongs in `toFormData()` / `toJson()`, **not** in the cubit
- `File?` fields use `MultipartFile.fromFile()` inside `toFormData()`
- `copyWith` uses a `clearXxx` bool flag to clear nullable fields:
  ```dart
  storeAddress: clearStoreAddress ? null : storeAddress ?? this.storeAddress,
  ```

### Full Pattern: Entity → Event → Cubit → Params → API

```dart
// 1. Widget captures entity from dropdown
CategoryDropdownField(
  onSelected: (CategoryDiscountEntity category) {
    _selectedCategory = category;  // ✅ hold entity locally
  },
)

// 2. Widget passes entity via event
SaveStep2Event(
  category: _selectedCategory,  // ✅ entity in event
)

// 3. Cubit stores entity in params
void _saveStep2(SaveStep2Event e) {
  params = params.copyWith(
    category: e.category,  // ✅ store full entity
  );
}

// 4. Params extracts ID when serializing for API
Future<FormData> toFormData() async {
  return FormData.fromMap({
    if (category != null) 'category': category?.id,  // ✅ extract here
  });
}

// 5. API layer never sees the entity
await client.post(
  path: EndPoints.merchantRegister,
  data: await params.toFormData(),  // ✅ FormData with primitives only
);
```

---

## Summary

- **Inject, never create** — all dependencies through constructor + getIt
- **Entities in params are OK** when UI needs entity properties; extract primitives in `toFormData()`
- **API layer never receives entities directly** — only primitives, DTOs, or Params (which serialize internally)
- **Mapping at boundaries** — DTO ↔ Entity conversion in Data layer only
- **Phone code** in `toFormData()`, not cubit
- **Clear nullable fields** with `clearXxx` bool flags in `copyWith`

---

## Related

- `02-api-layer.md` — ApiConsumer + executeApi pattern
- `03-data-layer.md` — Params, Model, Repo patterns
- `08-di-and-routing.md` — DI registration order
- `10-common-mistakes.md` → M8, M28

