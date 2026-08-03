# 11 — Validation Guide

Run these checks in order after finishing each layer.
Do NOT move to the next layer if the current one has errors.

---

## Layer 0 — Before You Write Code

```
[ ] AppStrings: searched for existing keys, added new ones under labeled comment
[ ] EndPoints: added new endpoint constant
[ ] AppRouter: added new route constant
[ ] Folder structure created matching 01-stack-and-structure.md
```

---

## Layer 1 — After Params Model

```
[ ] All fields have default values in constructor (no required params)
[ ] copyWith covers every field
[ ] toJson / toFormData adds AppConstants.phoneCode for phone fields
[ ] File? used for image fields (import dart:io)
[ ] FormData / MultipartFile imported from dio only if needed
```

Run: `flutter analyze lib/app_versions/{role}/{feature}/data/models/`
Expected: **No issues found**

---

## Layer 1b — After Entity & Response Model (if GET/response exists)

```
[ ] Entity file: standalone class — NO `part of`, declares its OWN imports
[ ] Entity: does NOT reference the model at all
[ ] Model file: standalone class — NO `part`, NO `extends {Feature}Entity`
[ ] Model file: imports the entity so toEntity() can build it
[ ] Entity: every class has empty() and fake()
[ ] Entity: enum-like fields are enums (not raw strings)
[ ] fromJson: uses  json['_id'] ?? json['id'] ?? ''  for id fields
[ ] fromJson: uses  (json['num'] ?? 0).toDouble()  for numbers
[ ] fromJson: uses  DateTime.tryParse(...)?.toLocal() ?? DateTime.now()  for dates
[ ] fromJson: uses  NestedModel.fromJson(json['x'] ?? {})  for objects
[ ] fromJson: uses  (json['list'] ?? []).map<XModel>((x) => XModel.fromJson(x)).toList()  for lists
[ ] toEntity: maps DTO → entity (string → enum conversion happens here)
[ ] fromEntity: present ONLY if a write path needs a full entity → DTO
```

Run: `flutter analyze lib/app_versions/{role}/{feature}/domain/entities/`
         `flutter analyze lib/app_versions/{role}/{feature}/data/models/`
Expected: **No issues found**

---

## Layer 2 — After Domain Layer

```
[ ] Repo contract returns Result<T> (import core/base_response/result.dart)
[ ] UseCase extends BaseUseCase<T, P> (import core/base_response/base_use_case.dart)
[ ] UseCase const constructor
[ ] No ApiConsumer or Dio imports in domain layer
```

Run: `flutter analyze lib/app_versions/{role}/{feature}/domain/`
Expected: **No issues found**

---

## Layer 3 — After Data Layer

```
[ ] DataSource contract: abstract, returns Result<T>
[ ] ApiClient: const ctor, returns model (no Result, no try/catch)
[ ] RemoteDataSourceImpl: const ctor, uses executeApi, no try/catch
[ ] RepoImpl: non-const ctor, pure delegation, no try/catch
[ ] Read-mostly GET (profile/config/lookups): repo caches + method takes forceRefresh
[ ] Cache updated on successful writes; cleared on logout
```

Run: `flutter analyze lib/app_versions/{role}/{feature}/data/`
         `flutter analyze lib/app_versions/{role}/{feature}/api/`
Expected: **No issues found**

---

## Layer 4 — After Cubit Layer

```
[ ] State: extends Equatable, copyWith, all fields in props, BaseState<T> for async data
[ ] Events: sealed, const ctors
[ ] UiEvents: sealed, const ctors
[ ] Cubit: extends BaseCubit<State, UiEvent>
[ ] doIntent: exhaustive switch (every event handled)
[ ] Loading guard present on every async handler
[ ] Skeleton emitted only on first load (if (!state.x.isSuccess)) — no flash on reload
[ ] GET reload passes forceRefresh:false; pull-to-refresh passes forceRefresh:true
[ ] No navigation, no context, no showDialog in cubit
[ ] emitEvent used for side effects, emit(state.copyWith) for state
```

Run: `flutter analyze lib/app_versions/{role}/{feature}/presentation/cubit/`
Expected: **No issues found**

---

## Layer 5 — After Presentation Layer

### Widget checks (grep-based)
Search inside `presentation/widgets/` for violations:

| Pattern to search | Problem if found |
|-------------------|-----------------|
| `Widget _build` | Method widget instead of class |
| `EdgeInsets.only(right` | Not RTL-safe |
| `EdgeInsets.only(left` | Not RTL-safe |
| `'[أ-ي]` or `"[أ-ي]` | Hardcoded Arabic string |
| `Color(0x` | Hardcoded color |
| `BlocBuilder<` without `buildWhen` | Unnecessary rebuilds |

### Structural checks
```
[ ] Every widget class has its own file
[ ] No _PrivateClass with more than 3 fields in any widget file
[ ] Page: initState creates cubit + subscribes to eventStream
[ ] Page: dispose cancels _eventSub, closes cubit, disposes controllers
[ ] All controllers disposed: TextEditingController, PageController, FocusNode
[ ] BlocProvider.value(value: _cubit) wraps scaffold
```

Run: `flutter analyze lib/app_versions/{role}/{feature}/presentation/`
Expected: **No issues found**

---

## Layer 6 — After DI & Routing

```
[ ] DI order: api_client → data_source → repo (each depending on the previous)
[ ] All imports added to dependency_injection.dart
[ ] GoRoute added to app_router.dart with adaptivePage
[ ] GoRoute import added for new page
[ ] Route argument validated (non-null check with ArgumentError)
```

Run: `flutter analyze lib/core/routing/ lib/core/dependency_injection/`
Expected: **No issues found**

---

## Final — Full Feature Analyze

```bash
flutter analyze lib/app_versions/{role}/{feature}
```

Expected output:
```
Analyzing {feature}...
No issues found! (ran in X.Xs)
```

If there are issues:
1. **Errors** (red) → fix immediately, they prevent compilation.
2. **Warnings** (yellow) → fix, they indicate unused imports or deprecated APIs.
3. **Info** (blue) → fix `prefer_const_constructors` and `unnecessary_underscores`.

---

## Post-Feature Checklist

```
[ ] flutter analyze → No issues found
[ ] No hardcoded Arabic strings remain (grep '[أ-ي] in widgets)
[ ] No hardcoded colors (grep 'Color(0x' in widgets)
[ ] No Widget _buildX methods
[ ] No private classes with 3+ params in same file
[ ] All controllers/subscriptions disposed
[ ] Loading guard on every async cubit handler
[ ] All toast messages use AppStrings keys
[ ] Route argument validated in GoRoute
```
