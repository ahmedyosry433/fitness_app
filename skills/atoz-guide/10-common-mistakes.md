# 10 — Common Mistakes & Fixes

---

## M0 — Using raw strings instead of enums (CRITICAL)

```dart
// ❌ — storing mode as string
class CategoryEntity {
  final String mode;  // "shopping", "discount", "both"
}

// ✅ — use existing ModeEnum
class CategoryEntity {
  final ModeEnum mode;  // shopping | discount | both

  factory CategoryEntity.empty() => CategoryEntity(
    mode: ModeEnum.shopping,  // type-safe default
    // ...
  );
}

// ✅ In model fromJson — use ModeEnum.fromString() with fallback
factory CategoryModel.fromJson(Map<String, dynamic> json) {
  return CategoryModel(
    mode: ModeEnum.fromString(json['mode'] ?? 'shopping'), // safe, never throws
    // ...
  );
}

// ✅ In model toJson — use .value NOT .name
Map<String, dynamic> toJson() => {
  'mode': mode.value,  // ← .value is the explicit API string
  // ❌ mode.name  ← Dart identifier, breaks if enum case is renamed
};
```

**ModeEnum has 3 cases**: `shopping`, `discount`, `both` — all in `lib/shared/model/mode_enum.dart`  
**Where to find enums**: `lib/shared/model/` and `lib/core/enums/`

---

## M1 — Hardcoded string in widget

```dart
// ❌
headerText: 'الاسم الكامل',
validator: (v) => 'الرجاء إدخال الاسم الكامل',

// ✅
headerText: AppStrings.fullName,
validator: (v) => AppStrings.validate(AppStrings.fullName),
```

---

## M2 — try/catch in repository

```dart
// ❌
@override
Future<Result<UserModel>> register({required Params params}) async {
  try {
    final result = await _remoteDataSource.register(params);
    return Success(data: result);
  } catch (e) {
    return Error(exception: Exception(e.toString()));
  }
}

// ✅ — errors already wrapped by executeApi, just delegate
@override
Future<Result<UserModel>> register({required Params params}) =>
    _remoteDataSource.register(params);
```

---

## M3 — Private widget class with multiple params

```dart
// ❌ — private class stays in same file, can't be tested or reused
class _Step1Fields extends StatelessWidget {
  final TextEditingController nameCtrl;
  // 6 more params...
}

// ✅ — separate file: step1_fields_widget.dart
class Step1FieldsWidget extends StatelessWidget {
  final TextEditingController nameCtrl;
  // same params, public, reusable, testable
}
```

---

## M4 — Widget method instead of widget class

```dart
// ❌
Widget _buildHeader() => Text('إنشاء حساب');

// ✅
class MerchantSignUpHeader extends StatelessWidget { ... }
```

---

## M5 — Navigation from cubit

```dart
// ❌ — cubits have no context
void _submit(...) async {
  context.go(AppRouter.home);  // compile error or wrong context
}

// ✅ — emit a UiEvent, handle in page
void _submit(...) async {
  emitEvent(const RegistrationSuccessUiEvent());
}
// In page: case RegistrationSuccessUiEvent(): context.go(AppRouter.home);
```

---

## M6 — BlocBuilder without buildWhen

```dart
// ❌ — rebuilds entire widget on every state change
BlocBuilder<XCubit, XState>(
  builder: (context, state) => Text(state.name),
)

// ✅ — only rebuilds when the watched slice changes
BlocBuilder<XCubit, XState>(
  buildWhen: (prev, curr) => prev.registrationState != curr.registrationState,
  builder: (context, state) => ...,
)
```

---

## M7 — Missing loading guard in cubit

```dart
// ❌ — user can tap submit multiple times → multiple API calls
Future<void> _submit(...) async {
  emit(state.copyWith(registrationState: const BaseState.loading()));
  ...
}

// ✅
Future<void> _submit(...) async {
  if (state.registrationState.isLoading) return;
  emit(state.copyWith(registrationState: const BaseState.loading()));
  ...
}
```

---

## M8 — Phone code added in cubit instead of params

```dart
// ❌
params.copyWith(phone: '${AppConstants.phoneCode}$phoneNumber')

// ✅ — phone code added in toJson/toFormData
Map<String, dynamic> toJson() => {
  'phone': '${AppConstants.phoneCode}$phone',
};
```

---

## M9 — Forgetting to dispose

```dart
// ❌ — memory leak
@override
void dispose() {
  super.dispose();  // missing controller.dispose(), _eventSub.cancel(), cubit.close()
}

// ✅
@override
void dispose() {
  _nameCtrl.dispose();
  _usernameFocus.dispose();
  _eventSub?.cancel();
  _cubit.close();
  super.dispose();
}
```

---

## M10 — const constructor on class extending abstract without const ctor

```dart
// ❌ — MerchantSignUpRepo abstract has no const ctor
const MerchantSignUpRepoImpl(this._ds);  // compile error

// ✅ — just remove const from impl
MerchantSignUpRepoImpl(this._ds);
```

---

## M11 — RTL layout with left/right instead of start/end

```dart
// ❌ — breaks in RTL (Arabic)
EdgeInsets.only(right: 12)
CrossAxisAlignment.left

// ✅
EdgeInsetsDirectional.only(end: 12)
CrossAxisAlignment.end
```

---

## M12 — Not validating route arguments

```dart
// ❌ — crashes if extra is null or wrong type
final model = state.extra as CustomerStoreModel;

// ✅ — fail loudly with clear message
final model = state.extra as CustomerStoreModel?;
if (model == null) throw ArgumentError('CustomerStoreModel required');
```

---

## M13 — Model extends Entity / linked via `part of`

```dart
// ❌ — DTO inherits from entity and links via part/part of
// entity file:
part of '../../data/models/orders_model.dart';
class OrderEntity { ... }
// model file:
part '../../domain/entities/orders_entity.dart';
class OrderModel extends OrderEntity { ... }

// ✅ — two SEPARATE standalone classes, bridged by a mapper
// entity file (domain/entities/orders_entity.dart): its own imports, NO part of
class OrderEntity { ... }
// model file (data/models/orders_model.dart): imports the entity, NO extends
class OrderModel {
  // ...fromJson / toJson...
  OrderEntity toEntity() => OrderEntity(/* map fields */);
}
```

The model (DTO) lives with the API/JSON. The entity lives with the domain/UI. They must
never be the same class or share a compilation unit.

---

## M14 — Entity depends on the model (or has no imports)

```dart
// ❌ — entity as a `part of` the model, relying on the model's imports
part of '../../data/models/profile_model.dart';
class ProfileEntity { ... }

// ✅ — entity is standalone and declares its OWN imports
// domain/entities/profile_entity.dart
import 'package:atoz/shared/model/roles.dart';
class ProfileEntity { ... }   // no knowledge of ProfileModel
```

---

## M15 — Missing `empty()` or `fake()` factory

```dart
// ❌ — no empty/fake, causes null errors in state and Skeletonizer
class OrderEntity {
  final String id;
  OrderEntity({required this.id});
}

// ✅
class OrderEntity {
  final String id;
  OrderEntity({required this.id});

  factory OrderEntity.empty() => OrderEntity(id: '');
  factory OrderEntity.fake() => OrderEntity(id: 'fake-id-001');
}
```

---

## M16 — Unsafe JSON parsing

```dart
// ❌ — crashes if field is missing or wrong type
id: json['_id'],
price: json['price'],
createdAt: DateTime.parse(json['createdAt']),

// ✅ — always defensive
id: json['_id'] ?? json['id'] ?? '',
price: (json['price'] ?? 0).toDouble(),
createdAt: DateTime.tryParse(json['createdAt'] ?? '')?.toLocal() ?? DateTime.now(),
```

---

## M17 — Serializing a nested entity directly

```dart
// ❌ — toJson can't convert a nested entity to JSON
Map<String, dynamic> toJson() => {
  'store': store,   // entity object, not serializable
};

// ✅ — the DTO holds nested DTOs; serialize those
Map<String, dynamic> toJson() => {
  'store': store.toJson(),   // store is a StoreModel (DTO), not an entity
};
```


---

## M18 — Using Retrofit instead of ApiConsumer

```dart
// ❌ — creating unnecessary api_client with Retrofit
@RestApi()
abstract class CategoriesApiClient {
  factory CategoriesApiClient(Dio dio) = _CategoriesApiClient;
  @GET('/categories')
  Future<List<CategoryModel>> getCategories();
}

// ✅ — use ApiConsumer directly in remote data source impl
class CategoriesRemoteDataSourceImpl implements BaseCategoriesRemoteDataSource {
  final ApiConsumer _apiConsumer;

  const CategoriesRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Result<CategoriesResponseDto>> getCategories({
    required CategoryParams params,
  }) {
    return executeApi<CategoriesResponseDto>(
      () async {
        final response = await _apiConsumer.get(
          path: EndPoints.categories,
          queryParameters: params.toJson(),
        );
        return CategoriesResponseDto.fromJson(response);
      },
    );
  }
}
```

---

## M19 — Passing filterList to PaginationParams super

```dart
// ❌ — PaginationParams doesn't have filterList constructor param
class CategoryParams extends PaginationParams {
  final String? mode;

  const CategoryParams({
    super.page,
    super.limit,
    super.filterList,  // WRONG! No such parameter
    this.mode,
  });
}

// ✅ — override filterList as a getter
class CategoryParams extends PaginationParams {
  final String? mode;

  const CategoryParams({
    super.page,
    super.limit,
    this.mode,
  });

  @override
  Map<String, dynamic> get filterList => {
    if (mode != null) 'mode': mode,
  };
}
```

---

## M20 — Remote data source impl in wrong layer

```dart
// ❌ — putting impl in data/data_sources/
lib/features/categories/
├── data/
│   └── data_sources/
│       └── categories_remote_data_source_impl.dart  // WRONG location!

// ✅ — impl goes in api/data_sources/, contract in data/data_sources/
lib/features/categories/
├── api/
│   └── data_sources/
│       └── categories_remote_data_source_impl.dart  // Implementation
└── data/
    └── data_sources/
        └── categories_remote_data_source.dart       // Contract
```

---

## M21 — Forgetting makeDummyData for global shared features

```dart
// ❌ — global feature returns error when offline (blocks entire app)
@override
Future<Result<BasePaginationEntity<CategoryEntity>>> getCategories({
  required CategoryParams params,
}) async {
  final result = await remoteDataSource.getCategories(params: params);
  return result.map((dto) => dto.toCategoryEntity());
}

// ✅ — provide dummy data fallback
@override
Future<Result<BasePaginationEntity<CategoryEntity>>> getCategories({
  required CategoryParams params,
}) async {
  final result = await remoteDataSource.getCategories(params: params);
  
  return result
      .makeDummyData(() => CategoriesFixtures.dummyResponse)
      .map((dto) => dto.toCategoryEntity());
}
```

---

## M23 — `BaseState<BasePaginationEntity<T>>` instead of `PaginationState<T>`

```dart
// ❌ — wrong state type for paginated data
class CategoriesState extends Equatable {
  final BaseState<BasePaginationEntity<CategoryEntity>> categoriesState;
  // manual page-merging required everywhere
}

// ✅ — correct type
import 'package:atoz/core/base_state/pagination_state.dart'; // NOT base_state.dart

class CategoriesState extends Equatable {
  final PaginationState<CategoryEntity> categoriesState;
  const CategoriesState({
    this.categoriesState = const PaginationState.initial(),
  });
}

// ✅ — transitions
emit(state.copyWith(
  categoriesState: state.categoriesState.toLoading(query: params),      // fresh load
));
emit(state.copyWith(
  categoriesState: state.categoriesState.toLoadingMore(),               // append
));
emit(state.copyWith(
  categoriesState: state.categoriesState.toSuccessFromEntity(data),     // auto-merges pages
));
emit(state.copyWith(
  categoriesState: state.categoriesState.toErrorMore(exception),        // keeps existing data
));

// ✅ — guards
if (state.categoriesState.isLoading) return;       // fresh load guard
if (!state.categoriesState.canLoadMore) return;    // load-more guard (built-in)

// ✅ — data access — flat List<T>, not wrapped in BasePaginationEntity
List<CategoryEntity> get categories => state.categoriesState.data;
bool get hasNextPage => state.categoriesState.hasMore;
int  get currentPage => state.categoriesState.currentPage;

// ✅ — UI: 6-case when()
state.categoriesState.when(
  initial:     ()           => const SizedBox.shrink(),
  loading:     ()           => const CategoriesShimmer(),
  loadingMore: (data)       => CategoriesList(items: data, isLoadingMore: true),
  success:     (data, meta) => CategoriesList(items: data),
  error:       (e)          => ErrorWidget(...),
  errorMore:   (data, e)    => CategoriesList(items: data, error: e.toString()),
);
```

**Rule**: Use `PaginationState<T>` for any paginated list. Use `BaseState<T>` for single-object / non-paginated responses.

---

## M24 — Duplicating metadata extraction in DTO subclasses

```dart
// ❌ — _extractMetadata copy-pasted in every DTO subclass
factory CategoriesResponseDto.fromJson(Map<String, dynamic> json) {
  return CategoriesResponseDto(
    message:    json['message'],
    metadata:   _extractMetadata(json),   // ❌ duplicated logic
    categories: (json['data'] as List?)?.map(...).toList(),
  );
}

static MetaDto? _extractMetadata(Map<String, dynamic> json) { ... } // ❌ duplicated

// ✅ — delegate ALL parsing to BasePaginationDto.fromJson()
factory CategoriesResponseDto.fromJson(Map<String, dynamic> json) {
  final parsed = BasePaginationDto<CategoryModel>.fromJson(
    json,
    (e) => CategoryModel.fromJson(e as Map<String, dynamic>),
  );
  return CategoriesResponseDto(
    message:    parsed.message,   // ← from base
    metadata:   parsed.metadata,  // ← from base (handles flat + nested automatically)
    categories: parsed.data,      // ← typed list from base
  );
}
```

Also **no `meta_dto.dart` import** needed in the subclass — `MetaDto` stays inside the base.

---

## M25 — Not calling `super.toJson()` in DTO subclass

```dart
// ❌ — loses message + pagination fields
@override
Map<String, dynamic> toJson() {
  return {
    'data': categories?.map((e) => e.toJson()).toList(),
  };
}

// ✅ — call super first, then override data
@override
Map<String, dynamic> toJson() {
  final json = super.toJson(); // writes message + total/limit/page
  json['data'] = categories?.map((e) => e.toJson()).toList();
  return json;
}
```

---

## M26 — Global shared model extending entity

```dart
// ❌ — inherits from entity (wrong pattern for global shared models)
import 'package:atoz/shared/categories/domain/entities/category_entity.dart'; // ❌ wrong path

class CategoryModel extends CategoryEntity { // ❌ no inheritance
  const CategoryModel({ required super.id, ... });
}

// ✅ — standalone class with explicit import
import 'package:atoz/core/shared/global/categories/domain/entities/category_entity.dart'; // ✅

class CategoryModel {          // ✅ standalone — no extends
  final String id;
  final ModeEnum mode;
  // ... own fields

  const CategoryModel({ required this.id, required this.mode, ... });

  factory CategoryModel.fromJson(Map<String, dynamic> json) { ... }
  CategoryEntity toEntity() => CategoryEntity(id: id, mode: mode, ...);
  Map<String, dynamic> toJson() => { '_id': id, 'mode': mode.value, ... };
}
```

---

## M27 — Missing `ModeEnum.both` catch-all in mode filters

```dart
// ❌ — hides categories that belong to all modes
if (params.mode != null && cat.mode != params.mode) return false;

// ✅ — ModeEnum.both passes every mode filter
if (params.mode != null && cat.mode != params.mode && cat.mode != ModeEnum.both)
  return false;

// ✅ — cubit helper must also include both
List<CategoryEntity> getCategoriesByMode(ModeEnum mode) =>
    categories
        .where((c) => c.mode == mode || c.mode == ModeEnum.both)
        .toList();
```

```dart
// ❌ — fresh instance per screen, loses cached data
getIt.registerFactory<CategoriesCubit>(
  () => CategoriesCubit(getCategoriesUseCase: getIt()),
);

// ✅ — singleton for global state (shared across customer/merchant/driver)
getIt.registerSingleton<CategoriesCubit>(
  CategoriesCubit(getCategoriesUseCase: getIt()),
);
```

---

## M28 — Passing domain entity to API layer instead of primitive value

```dart
// ❌ — API layer depends on a domain entity
class MerchantSignUpParams {
  final CategoryEntity? category;  // ❌ whole entity in params
}

abstract class MerchantSignUpDataSource {
  Future<Result<void>> register({ required CategoryEntity category }); // ❌
}

// In impl — unpacking entity inside API layer (entity leaks into API)
data: { 'categoryId': category.id }

// ❌ — Cubit passes entity to params
params.copyWith(category: selectedCategory);
```

```dart
// ✅ — only the primitive the endpoint needs
class MerchantSignUpParams {
  final String? categoryId;  // ✅ primitive
}

abstract class MerchantSignUpDataSource {
  Future<Result<void>> register({ required String categoryId }); // ✅
}

// In toFormData — no entity import needed anywhere in API/Data layer
Future<FormData> toFormData() async {
  return FormData.fromMap({
    if (categoryId != null) 'categoryId': categoryId,
  });
}

// ✅ Cubit passes the id
params.copyWith(categoryId: selectedCategory.id);
```

**Rule**: If the endpoint only needs an ID (or any scalar), pass that scalar — never the entity.  
The API layer must **never** import `*Entity` classes.  
See: `14-clean-arch-di-guidelines.md`

---

## M29 — Refetching cached data on every navigation

```dart
// ❌ — every screen open fires a fresh server request for unchanged data
// repo: no cache, always hits the network
Future<Result<ProfileEntity>> getProfile() async {
  final result = await _remoteDataSource.getProfile();  // server EVERY time
  return result.when(success: (m) => Success(data: m?.toEntity()), error: ...);
}

// cubit: always shows the skeleton on reload
Future<void> _loadProfile() async {
  emit(state.copyWith(profileState: const BaseState.loading())); // flashes skeleton
  // ...
}
```

```dart
// ✅ — repo (lazy singleton) caches; GET use case carries forceRefresh
Future<Result<ProfileEntity>> getProfile({bool forceRefresh = false}) async {
  if (!forceRefresh && _cachedProfile != null) return Success(data: _cachedProfile);
  // ...fetch, then cache the resolved entity...
}

// ✅ — cubit only shows the skeleton on first load; reloads are silent cache reads
Future<void> _loadProfile(bool forceRefresh) async {
  if (state.profileState.isLoading) return;
  if (!state.profileState.isSuccess) {
    emit(state.copyWith(profileState: const BaseState.loading()));
  }
  final result = await _getProfileUseCase(forceRefresh);
  // ...
}
```

**Rules:**
- Cache read-mostly data in the **repo** (singleton), not the cubit (recreated per screen).
- GET use case takes `bool forceRefresh`; navigation loads pass `false`, pull-to-refresh passes `true`.
- Update the cache on successful writes; clear it on logout.
- Gate `emit(loading)` behind `if (!state.x.isSuccess)` so cached data never flashes a skeleton.
- Do NOT short-circuit with `if (isSuccess) return;` — that shows stale data after edits elsewhere.

See `03-data-layer.md` → "Repository caching" and `05-cubit-layer.md` → "Loading data once".
