# 13 — Global Shared Features

Global shared features are **reusable cross-role data sources** (categories, cities, countries) that live in `lib/core/shared/global/`. These are built once and consumed by customer, merchant, and driver features.

---

## Structure

```
lib/core/shared/global/
└── {feature_name}/          # e.g., categories, cities
    ├── README.md            # Feature documentation
    ├── api/
    │   └── data_sources/    # Remote data source impl (uses ApiConsumer)
    │       └── {feature}_remote_data_source_impl.dart
    ├── data/
    │   ├── data_sources/    # Abstract contract
    │   │   └── {feature}_remote_data_source.dart
    │   ├── fixtures/        # Dummy data for offline/dev mode
    │   │   └── {feature}_fixtures.dart
    │   ├── models/          # DTOs (extend entities)
    │   │   ├── {feature}_model.dart
    │   │   └── {feature}_response_dto.dart
    │   └── repositories/    # Repo impl with makeDummyData
    │       └── {feature}_repository_impl.dart
    ├── domain/
    │   ├── entities/        # Business entities
    │   │   ├── {feature}_entity.dart
    │   │   └── {feature}_params.dart
    │   ├── repositories/    # Abstract repo contract
    │   │   └── {feature}_repository.dart
    │   └── use_cases/
    │       ├── get_{feature}.dart
    │       └── get_{feature}_by_id.dart
    └── presentation/
        └── cubit/           # Global cubit (cached state)
            ├── {feature}_cubit.dart
            ├── {feature}_events.dart
            └── {feature}_state.dart
```

**Key differences from role-specific features:**
- Lives in `lib/core/shared/global/` (not `app_versions/`)
- Remote data source impl in `api/data_sources/` layer
- Repository uses `makeDummyData()` with fixtures for offline fallback
- Cubit registered as **singleton** (shared state across app)

---

## Critical Rule: Enum Injection

**NEVER** store raw strings for enum-like fields. Always use existing enums.

### Example: ModeEnum

```dart
// ❌ WRONG — category_entity.dart
class CategoryEntity {
  final String mode;  // "shopping", "discount", "both" — bad!
  // ...
}

// ✅ CORRECT — category_entity.dart
import 'package:atoz/shared/model/mode_enum.dart';

class CategoryEntity {
  final ModeEnum mode;  // enum with type safety
  // ...
  
  factory CategoryEntity.empty() {
    return CategoryEntity(
      // ...
      mode: ModeEnum.shopping,  // default enum value
    );
  }
}
```

### Model (standalone — does NOT extend entity)

```dart
// ✅ CORRECT — standalone model, no inheritance
import 'package:atoz/core/shared/global/{feature}/domain/entities/{feature}_entity.dart';
import 'package:atoz/shared/model/mode_enum.dart';

class {Feature}Model {
  final String id;
  final ModeEnum mode;
  // ... all fields declared here

  factory {Feature}Model.fromJson(Map<String, dynamic> json) {
    return {Feature}Model(
      // ...
      mode: ModeEnum.fromString(json['mode'] ?? 'shopping'),  // string → enum via .fromString()
    );
  }

  Map<String, dynamic> toJson() => {
    // ...
    'mode': mode.value,  // enum → string via .value (NOT .name)
  };

  {Feature}Entity toEntity() => {Feature}Entity(/* all fields */);
  // fromEntity: only if a write path needs a full entity → DTO
  factory {Feature}Model.fromEntity({Feature}Entity entity) => {Feature}Model(/* all fields */);
}

// ❌ WRONG — do not extend the entity; DTO and entity are separate classes
// class {Feature}Model extends {Feature}Entity { ... }
```

**Where to find enums:**
- `lib/shared/model/mode_enum.dart` — `ModeEnum.shopping | discount | both`
- `lib/shared/model/roles.dart` — `RoleEnum.user | merchant | driver`
- `lib/core/enums/order_status.dart` — Order states
- Always search `lib/shared/model/` and `lib/core/enums/` before creating new enum fields

---

## BasePaginationDto — Flat Pagination Support

Global shared features often return flat pagination (no nested `metadata` or `pagination` object):

```json
{
  "data": [
    {"_id": "123", "name": "Category 1", "mode": "shopping"},
    {"_id": "456", "name": "Category 2", "mode": "discount"}
  ],
  "total": 4,
  "limit": 20,
  "page": 1
}
```

### Response DTO Pattern

`BasePaginationDto<T>` owns all shared pagination behaviour. Subclasses **delegate fully** to the base factory then just wrap the result.

```
BasePaginationDto<T>                    ← owns
  ├── fromJson(json, mapper)            ← parses message + metadata (all formats) + typed list
  ├── toJson()                          ← serializes message + total/limit/page + data
  └── toEntity<E>(mapper)              ← converts list to BasePaginationEntity<E>

{Feature}sResponseDto                   ← owns only
  ├── fromJson()  → BasePaginationDto<T>.fromJson() then wraps result
  └── toJson()    → super.toJson() then overrides data with typed list
```

**OOP principles applied:**
- **Single Responsibility** — base parses; subclass wraps
- **Open/Closed** — new DTO = extend base, never modify it
- **DRY** — zero duplication of pagination / metadata logic

```dart
// {feature}s_response_dto.dart — 4 imports only, no meta_dto.dart
import 'package:atoz/core/base_response/entity/base_pagination_entity.dart';
import 'package:atoz/core/base_response/model/base_pagination_dto.dart';
import 'package:atoz/core/shared/global/{feature}/data/models/{feature}_model.dart';
import 'package:atoz/core/shared/global/{feature}/domain/entities/{feature}_entity.dart';

class {Feature}sResponseDto extends BasePaginationDto<{Feature}Model> {
  final List<{Feature}Model>? items;

  const {Feature}sResponseDto({ super.message, super.metadata, this.items })
      : super(data: items);

  factory {Feature}sResponseDto.fromJson(Map<String, dynamic> json) {
    // ✅ Delegate ALL parsing to base — no manual JSON extraction
    final parsed = BasePaginationDto<{Feature}Model>.fromJson(
      json,
      (e) => {Feature}Model.fromJson(e as Map<String, dynamic>),
    );
    return {Feature}sResponseDto(
      message:  parsed.message,
      metadata: parsed.metadata,
      items:    parsed.data,
    );
  }

  // ✅ Only override data — base toJson() writes message + total/limit/page
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['data'] = items?.map((e) => e.toJson()).toList();
    return json;
  }

  BasePaginationEntity<{Feature}Entity> to{Feature}Entity() =>
      toEntity<{Feature}Entity>((m) => m.toEntity());
}
```

`BasePaginationDto.fromJson()` automatically detects:
1. Flat root-level: `{"data": [...], "total": 4, "limit": 20, "page": 1}`
2. Nested `metadata`: `{"data": [...], "metadata": {...}}`
3. Nested `pagination`: `{"data": [...], "pagination": {...}}`

---

## PaginationParams — filterList Override

Params extending `PaginationParams` must override `filterList` getter (not pass to super):

```dart
// category_params.dart
import 'package:atoz/core/uses_cases/params.dart';

class CategoryParams extends PaginationParams {
  final String? mode;
  final bool? isActive;

  const CategoryParams({
    super.page,
    super.limit,
    this.mode,
    this.isActive,
  });

  // ✅ CORRECT — override filterList
  @override
  Map<String, dynamic> get filterList => {
    if (mode != null) 'mode': mode,
    if (isActive != null) 'isActive': isActive,
  };

  CategoryParams copyWith({
    int? page,
    int? limit,
    String? mode,
    bool? isActive,
  }) {
    return CategoryParams(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      mode: mode ?? this.mode,
      isActive: isActive ?? this.isActive,
    );
  }
}
```

**Never do this:**
```dart
// ❌ WRONG
const CategoryParams({
  super.page,
  super.limit,
  super.filterList,  // NO! PaginationParams doesn't have filterList constructor param
});
```

---

## API Layer — Direct ApiConsumer Usage

**No Retrofit**. Use `DioConsumer` (ApiConsumer) directly with `EndPoints` constants.

### Step 1: Add endpoint

```dart
// lib/core/api/end_points.dart
class EndPoints {
  // ... existing
  static String categories = 'categories';
}
```

### Step 2: Remote Data Source Implementation

```dart
// api/data_sources/categories_remote_data_source_impl.dart
import 'package:atoz/core/api/api_consumer.dart';
import 'package:atoz/core/api/end_points.dart';
import 'package:atoz/core/base_response/api_execute.dart';
import 'package:atoz/core/base_response/result.dart';

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

  @override
  Future<Result<CategoryModel>> getCategoryById(String id) {
    return executeApi<CategoryModel>(
      () async {
        final response = await _apiConsumer.get(
          path: '${EndPoints.categories}/$id',
        );
        return CategoryModel.fromJson(response);
      },
    );
  }
}
```

**Rules:**
- `const` constructor
- Use `_apiConsumer.get/post/put/delete` directly
- Wrap in `executeApi<T>()` — never add try/catch
- Lives in `api/data_sources/` layer (not `data/data_sources/`)

---

## Repository — makeDummyData Pattern

Global shared features use **dummy data fallback** for offline/dev mode:

```dart
// data/repositories/categories_repository_impl.dart
import 'package:atoz/core/shared/global/categories/data/fixtures/categories_fixtures.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  final BaseCategoriesRemoteDataSource remoteDataSource;

  const CategoriesRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<BasePaginationEntity<CategoryEntity>>> getCategories({
    required CategoryParams params,
  }) async {
    final result = await remoteDataSource.getCategories(params: params);

    // makeDummyData: if API fails, return dummy data
    return result
        .makeDummyData(() => CategoriesFixtures.dummyResponse)
        .map((dto) => dto.toCategoryEntity());
  }

  @override
  Future<Result<CategoryEntity>> getCategoryById(String id) async {
    final result = await remoteDataSource.getCategoryById(id);

    return result
        .makeDummyData(() => CategoriesFixtures.dummyCategories.first)
        .map((model) => model.toEntity());
  }
}
```

### Fixtures File

```dart
// data/fixtures/categories_fixtures.dart
import '../models/categories_response_dto.dart';
import '../models/category_model.dart';

class CategoriesFixtures {
  static final List<CategoryModel> dummyCategories = [
    CategoryModel(
      id: 'cat_001',
      name: 'إلكترونيات',
      mode: ModeEnum.shopping,
      image: 'https://via.placeholder.com/150',
      isActive: true,
      position: 1,
      productCount: 42,
      storeCount: 8,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    ),
    // ... 7 more
  ];

  static final CategoriesResponseDto dummyResponse = CategoriesResponseDto(
    data: dummyCategories,
    metadata: const MetaDto(
      total: 8,
      limit: 20,
      currentPage: 1,
      numberOfPages: 1,
    ),
  );
}
```

**Why makeDummyData?**
- Global data is needed app-wide — can't block on network failure
- Enables offline-first development
- Provides instant UI/UX testing without backend

---

## Cubit Pattern — BaseCubit + doIntent

Global shared cubits follow the new pattern:

```dart
// presentation/cubit/categories_cubit.dart
import 'package:atoz/core/base_state/base_cubit.dart';
import 'package:atoz/core/base_state/base_state.dart';
// ... imports

part 'categories_events.dart';
part 'categories_state.dart';

class CategoriesCubit extends BaseCubit<CategoriesState, void> {
  final GetCategoriesUseCase _getCategoriesUseCase;

  CategoryParams _params = const CategoryParams();

  CategoriesCubit({required GetCategoriesUseCase getCategoriesUseCase})
      : _getCategoriesUseCase = getCategoriesUseCase,
        super(const CategoriesState());

  Future<void> doIntent(CategoriesEvent event) async => switch (event) {
    LoadCategoriesEvent() => _loadCategories(event),
    FilterByModeEvent() => _filterByMode(event),
    RefreshCategoriesEvent() => _refresh(),
  };

  Future<void> _loadCategories(LoadCategoriesEvent event) async {
    if (state.categoriesState.isLoading) return;

    _params = event.isInitialLoad
        ? const CategoryParams(page: 1, limit: 20)
        : _params.copyWith(page: _params.page + 1);

    emit(state.copyWith(categoriesState: const BaseState.loading()));

    final result = await _getCategoriesUseCase(_params);

    result.when(
      success: (data) {
        final existingData = state.categoriesState.data?.data ?? [];
        final newData = event.isInitialLoad
            ? data.data
            : [...existingData, ...data.data];

        final updatedPagination = BasePaginationEntity(
          meta: data.meta,
          data: newData,
        );

        emit(state.copyWith(
          categoriesState: BaseState.success(updatedPagination),
        ));
      },
      error: (exception) {
        emit(state.copyWith(
          categoriesState: BaseState.error(exception ?? Exception('خطأ')),
        ));
      },
    );
  }

  Future<void> _filterByMode(FilterByModeEvent event) async {
    _params = _params.copyWith(mode: event.mode.name);
    await _loadCategories(const LoadCategoriesEvent(isInitialLoad: true));
  }

  Future<void> _refresh() async {
    _params = const CategoryParams(page: 1, limit: 20);
    await _loadCategories(const LoadCategoriesEvent(isInitialLoad: true));
  }
}
```

### State

```dart
// categories_state.dart
part of 'categories_cubit.dart';

class CategoriesState extends Equatable {
  final BaseState<BasePaginationEntity<CategoryEntity>> categoriesState;

  const CategoriesState({
    this.categoriesState = const BaseState.initial(),
  });

  CategoriesState copyWith({
    BaseState<BasePaginationEntity<CategoryEntity>>? categoriesState,
  }) {
    return CategoriesState(
      categoriesState: categoriesState ?? this.categoriesState,
    );
  }

  @override
  List<Object?> get props => [categoriesState];
}
```

### Events

```dart
// categories_events.dart
part of 'categories_cubit.dart';

sealed class CategoriesEvent {
  const CategoriesEvent();
}

class LoadCategoriesEvent extends CategoriesEvent {
  final bool isInitialLoad;
  const LoadCategoriesEvent({this.isInitialLoad = false});
}

class FilterByModeEvent extends CategoriesEvent {
  final ModeEnum mode;
  const FilterByModeEvent(this.mode);
}

class RefreshCategoriesEvent extends CategoriesEvent {
  const RefreshCategoriesEvent();
}
```

---

## DI Registration

**Order:** data_source_impl → data_source_contract → repository → use_cases → cubit

```dart
// lib/core/dependency_injection/dependency_injection.dart

// 1. Remote data source implementation (depends on ApiConsumer)
getIt.registerLazySingleton<CategoriesRemoteDataSourceImpl>(
  () => CategoriesRemoteDataSourceImpl(getIt.get<ApiConsumer>()),
);

// 2. Bind implementation to abstract contract
getIt.registerLazySingleton<BaseCategoriesRemoteDataSource>(
  () => getIt.get<CategoriesRemoteDataSourceImpl>(),
);

// 3. Repository (depends on abstract data source)
getIt.registerLazySingleton<CategoriesRepository>(
  () => CategoriesRepositoryImpl(
        getIt.get<BaseCategoriesRemoteDataSource>()),
);

// 4. Use cases
getIt.registerLazySingleton<GetCategoriesUseCase>(
  () => GetCategoriesUseCase(getIt.get<CategoriesRepository>()),
);
getIt.registerLazySingleton<GetCategoryByIdUseCase>(
  () => GetCategoryByIdUseCase(getIt.get<CategoriesRepository>()),
);

// 5. Cubit — SINGLETON (shared state across app)
getIt.registerSingleton<CategoriesCubit>(
  CategoriesCubit(
    getCategoriesUseCase: getIt.get<GetCategoriesUseCase>(),
  ),
);
```

**Why singleton cubit?**
- Global data should be cached and shared across screens
- Prevents redundant API calls when navigating between customer/merchant/driver features
- Use `getIt.get<CategoriesCubit>()` or `context.read<CategoriesCubit>()` anywhere

---

## Usage in Features

```dart
// In customer/merchant/driver screen
class ProductsScreen extends StatefulWidget {
  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late final CategoriesCubit categoriesCubit;

  @override
  void initState() {
    super.initState();
    categoriesCubit = context.read<CategoriesCubit>();
    
    // Load if not already loaded
    if (categoriesCubit.state.categoriesState.isInitial) {
      categoriesCubit.doIntent(const LoadCategoriesEvent(isInitialLoad: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      bloc: categoriesCubit,
      builder: (context, state) {
        return state.categoriesState.when(
          initial: () => const SizedBox.shrink(),
          loading: () => const CircularProgressIndicator(),
          success: (data) => CategoryList(categories: data!.data),
          error: (e) => ErrorWidget(message: e.toString()),
        );
      },
    );
  }
}
```

---

## Checklist for New Global Shared Feature

- [ ] Structure: `lib/core/shared/global/{feature}/` with 5 layers
- [ ] Entity: standalone file, own imports, `.empty()` and `.fake()` factories, `ModeEnum` field
- [ ] Model: **standalone class — does NOT extend entity**, own fields, `fromJson` (ModeEnum.fromString), `toEntity()`, `toJson()` (mode.value not mode.name)
- [ ] Model import: use full `package:atoz/core/shared/global/{feature}/...` path — never `package:atoz/shared/{feature}/...`
- [ ] Params: extends `PaginationParams`, **overrides `filterList` getter** (not super constructor)
- [ ] Response DTO: extends `BasePaginationDto<T>`, imports `meta_dto.dart` explicitly, handles flat + nested pagination via `_extractMetadata()`
- [ ] Remote data source impl: in `api/data_sources/`, uses `ApiConsumer` + `EndPoints`, `executeApi`, no try/catch
- [ ] Repository: `makeDummyData()` with `ModeEnum.both` catch-all filter
- [ ] Fixtures: 5–8 dummy items covering `shopping`, `discount`, and `both` modes
- [ ] Cubit: extends `BaseCubit`, `doIntent` entry point, loading guard, load-more merges pages
- [ ] DI: data_source_impl → contract → repo → use_cases → cubit (registerFactory for cubit)
- [ ] Use case imports: correct `package:atoz/core/shared/global/{feature}/...` paths
- [ ] Run `flutter analyze lib/core/shared/global/{feature}` — **No issues found!**

---

## Common Mistakes

1. **`CategoryModel extends CategoryEntity`** — global shared models must be standalone, not inherit from entity
2. **Wrong import path** — `package:atoz/shared/categories/...` instead of `package:atoz/core/shared/global/categories/...`
3. **Missing `meta_dto.dart` import** — `MetaDto` is not re-exported from `base_pagination_dto.dart`; import it explicitly
4. **Storing raw strings instead of enums** — always use `ModeEnum.fromString()` / `.value`
5. **Serializing with `mode.name`** — always use `mode.value` (they may differ if enum name ≠ API string)
6. **Passing filterList to PaginationParams super** — must override the getter, not pass in constructor
7. **Creating api_client with Retrofit** — use `ApiConsumer` directly
8. **Putting remote data source in `data/data_sources/`** — impl must be in `api/data_sources/`
9. **Forgetting `ModeEnum.both` in mode filter** — items with `both` must pass every mode filter
10. **Forgetting `makeDummyData`** — global features need offline fallback
