---
name: categories-feature
description: >
  Global shared categories feature for ATOZ app. CMS-managed product/store categories
  with shopping/discount/both mode support, flat-pagination, `makeDummyData` offline fallback,
  and `BaseCubit` + `doIntent` pattern. Located at `lib/core/shared/global/categories/`.
  Trigger on: "categories", "أقسام", "category list", "filter categories", "global shared categories",
  "shared categories", "categories cubit", "CategoryEntity", "CategoriesResponseDto".
---

# Categories Feature (Global Shared — ATOZ)

Full end-to-end reference for `lib/core/shared/global/categories/`. Production-ready as of July 2026.

> **API**: `GET /api/v1/categories`  
> **Reference impl**: `lib/core/shared/global/categories/`

---

## 1. Folder Structure

```
lib/core/shared/global/categories/
├── api/
│   └── data_sources/
│       └── categories_remote_data_source_impl.dart  # ApiConsumer + executeApi
├── data/
│   ├── data_sources/
│   │   └── categories_remote_data_source.dart       # Abstract contract
│   ├── fixtures/
│   │   └── categories_fixtures.dart                 # 8 dummy CategoryEntity items
│   ├── models/
│   │   ├── category_model.dart                      # extends CategoryEntity
│   │   └── categories_response_dto.dart             # extends BasePaginationDto
│   └── repositories/
│       └── categories_repository_impl.dart          # makeDummyData pattern
├── domain/
│   ├── entities/
│   │   ├── category_entity.dart                     # Equatable, empty(), fake()
│   │   └── category_params.dart                     # PaginationParams + ModeEnum
│   ├── repositories/
│   │   └── categories_repository.dart               # abstract contract
│   └── use_cases/
│       ├── get_categories_use_case.dart
│       └── get_category_by_id_use_case.dart
└── presentation/
    └── cubit/
        ├── categories_cubit.dart      # part files declared here
        ├── categories_state.dart      # part of categories_cubit.dart
        ├── categories_events.dart     # part of categories_cubit.dart
        └── categories_ui_events.dart  # part of categories_cubit.dart
```

---

## 2. API Response Format

```json
{
  "data": [
    {
      "_id": "6964f70b2cd01d7816f98a62",
      "name": "تيست قسم",
      "image": "1768224523073-65617-wallpaper.jpg",
      "position": 1,
      "mode": "shopping",
      "productCount": 0,
      "storeCount": 1,
      "isActive": true,
      "isDeleted": false,
      "createdAt": "2026-01-12T13:28:43.181Z",
      "updatedAt": "2026-07-01T05:52:00.035Z",
      "id": "6964f70b2cd01d7816f98a62"
    }
  ],
  "total": 4,
  "limit": 20,
  "page": 1
}
```

**Pagination format**: flat root-level (`total`, `limit`, `page`) — handled by `_extractMetadata()` in the DTO.

---

## 3. Entity & Model

### `CategoryEntity` (`domain/entities/category_entity.dart`)

```dart
class CategoryEntity extends Equatable {
  final String id;
  final String name;
  final String image;
  final int position;
  final ModeEnum mode;       // shopping | discount | both
  final int productCount;
  final int storeCount;
  final bool isActive;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory CategoryEntity.empty() { ... }  // all defaults
  factory CategoryEntity.fake()  { ... }  // realistic sample for Skeletonizer
}
```

### `CategoryModel` (`data/models/category_model.dart`)

`CategoryModel` is a **standalone class** — it does **NOT** extend `CategoryEntity`.
It owns all fields, converts from JSON, and produces entities via `toEntity()`.

```dart
import 'package:atoz/core/shared/global/categories/domain/entities/category_entity.dart';
import 'package:atoz/shared/model/mode_enum.dart';

class CategoryModel {
  final String id;
  final String name;
  final String image;
  final int position;
  final ModeEnum mode;
  final int productCount;
  final int storeCount;
  final bool isActive;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CategoryModel({ required this.id, required this.name, ... });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id:           json['_id'] ?? json['id'] ?? '',
      name:         json['name'] ?? '',
      image:        json['image'] ?? '',
      position:     json['position'] ?? 0,
      mode:         ModeEnum.fromString(json['mode'] ?? 'shopping'),
      productCount: json['productCount'] ?? 0,
      storeCount:   json['storeCount'] ?? 0,
      isActive:     json['isActive'] ?? false,
      isDeleted:    json['isDeleted'] ?? false,
      createdAt:    json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt:    json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
    );
  }

  factory CategoryModel.fromParent(CategoryEntity parent) {
    return CategoryModel(
      id: parent.id, name: parent.name, image: parent.image,
      position: parent.position, mode: parent.mode,
      productCount: parent.productCount, storeCount: parent.storeCount,
      isActive: parent.isActive, isDeleted: parent.isDeleted,
      createdAt: parent.createdAt, updatedAt: parent.updatedAt,
    );
  }

  CategoryEntity toEntity() => CategoryEntity(
    id: id, name: name, image: image, position: position, mode: mode,
    productCount: productCount, storeCount: storeCount,
    isActive: isActive, isDeleted: isDeleted,
    createdAt: createdAt, updatedAt: updatedAt,
  );

  Map<String, dynamic> toJson() => {
    '_id': id, 'name': name, 'image': image, 'position': position,
    'mode': mode.value,   // ← always .value, never raw string
    'productCount': productCount, 'storeCount': storeCount,
    'isActive': isActive, 'isDeleted': isDeleted,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}
```

**Key rules:**
- `CategoryModel` does **NOT** extend `CategoryEntity` — it is a standalone data class.
- Import `category_entity.dart` explicitly with the full `package:atoz/core/shared/global/categories/...` path.
- `mode` is always `ModeEnum` — parsed via `ModeEnum.fromString()` in `fromJson`.
- `mode.value` used in `toJson()` — never a raw string.

---

## 4. Params (`domain/entities/category_params.dart`)

```dart
class CategoryParams extends PaginationParams {
  final ModeEnum? mode;
  final bool? isActive;

  const CategoryParams({
    this.mode,
    this.isActive,
    super.page,
    super.limit,
  }) : super(filterList: const []);

  @override
  List<FilterParam> get filterList => [
    if (mode != null)     FilterParam(key: 'mode',     value: mode!.value),
    if (isActive != null) FilterParam(key: 'isActive', value: isActive!),
  ];

  @override
  CategoryParams copyWith({ ModeEnum? mode, bool? isActive, int? page, int? limit }) { ... }

  @override
  Map<String, dynamic> toJson() {
    final base = <String, dynamic>{
      if (page != null)  'page':  page,
      if (limit != null) 'limit': limit,
    };
    for (final f in filterList) { base[f.key] = f.value; }
    return base;
  }
}
```

---

## 5. Response DTO (`data/models/categories_response_dto.dart`)

### OOP Design

`BasePaginationDto<T>` owns all shared pagination behaviour. Subclasses **delegate fully** to the base factory then just wrap the result — no manual JSON parsing at all.

| Responsibility | Where it lives |
|---|---|
| Parse `message`, detect flat/nested metadata, parse `data` list | `BasePaginationDto.fromJson()` |
| Serialize `message` + `total` / `limit` / `page` + `data` | `BasePaginationDto.toJson()` |
| Map items to domain entities | `BasePaginationDto.toEntity<E>()` |
| **Wrap typed result from base factory** | ✅ Subclass `fromJson` only |
| **Serialize typed `data` list** | ✅ Subclass `toJson` only |

Principles applied:
- **Single Responsibility** — base handles all parsing logic; subclass only wraps
- **Open/Closed** — new DTOs extend base without touching it
- **DRY** — zero duplication of pagination detection logic

### Implementation

```dart
// 4 imports only — no meta_dto.dart needed in subclass
import 'package:atoz/core/base_response/entity/base_pagination_entity.dart';
import 'package:atoz/core/base_response/model/base_pagination_dto.dart';
import 'package:atoz/core/shared/global/categories/data/models/category_model.dart';
import 'package:atoz/core/shared/global/categories/domain/entities/category_entity.dart';

class CategoriesResponseDto extends BasePaginationDto<CategoryModel> {
  final List<CategoryModel>? categories;

  const CategoriesResponseDto({ super.message, super.metadata, this.categories })
      : super(data: categories);

  factory CategoriesResponseDto.fromJson(Map<String, dynamic> json) {
    // ✅ Delegate ALL parsing to the base factory — zero manual extraction
    final parsed = BasePaginationDto<CategoryModel>.fromJson(
      json,
      (e) => CategoryModel.fromJson(e as Map<String, dynamic>),
    );
    return CategoriesResponseDto(
      message:    parsed.message,
      metadata:   parsed.metadata,
      categories: parsed.data,
    );
  }

  // ✅ Only override the typed data — base writes message + total/limit/page
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['data'] = categories?.map((e) => e.toJson()).toList();
    return json;
  }

  BasePaginationEntity<CategoryEntity> toCategoryEntity() =>
      toEntity<CategoryEntity>((dto) => dto.toEntity());
}
```

---

## 6. Data Source

### Abstract contract (`data/data_sources/categories_remote_data_source.dart`)

```dart
abstract class BaseCategoriesRemoteDataSource {
  Future<Result<CategoriesResponseDto>> getCategories({ required CategoryParams params });
  Future<Result<CategoryModel>> getCategoryById(String id);
}
```

### Impl (`api/data_sources/categories_remote_data_source_impl.dart`)

Uses **`ApiConsumer`** (not Retrofit). No try/catch — wrapped in `executeApi`.

```dart
class CategoriesRemoteDataSourceImpl implements BaseCategoriesRemoteDataSource {
  final ApiConsumer client;
  const CategoriesRemoteDataSourceImpl(this.client);

  @override
  Future<Result<CategoriesResponseDto>> getCategories({ required CategoryParams params }) =>
      executeApi(() async {
        final response = await client.get(
          path: EndPoints.categories,
          queryParameters: params.toJson(),
        );
        return CategoriesResponseDto.fromJson(response);
      });

  @override
  Future<Result<CategoryModel>> getCategoryById(String id) =>
      executeApi(() async {
        final response = await client.get(path: '${EndPoints.categories}/$id');
        return CategoryModel.fromJson(response);
      });
}
```

---

## 7. Repository (`data/repositories/categories_repository_impl.dart`)

Uses `makeDummyData` — filters dummy list by `mode` and `isActive`. Items with `ModeEnum.both` pass every mode filter.

```dart
class CategoriesRepositoryImpl implements CategoriesRepository {
  final BaseCategoriesRemoteDataSource remoteDataSource;
  const CategoriesRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<BasePaginationEntity<CategoryEntity>>> getCategories(CategoryParams params) async {
    final result = await remoteDataSource.getCategories(params: params);

    return result.makeDummyData(
      dummyData: BasePaginationEntity.dummyData<CategoryEntity>(
        params: params,
        allData: CategoriesFixtures.dummyCategories.where((cat) {
          // ModeEnum.both passes every mode filter
          if (params.mode != null && cat.mode != params.mode && cat.mode != ModeEnum.both)
            return false;
          if (params.isActive != null && cat.isActive != params.isActive)
            return false;
          return true;
        }).toList(),
      ),
      success: (data) => Success(data: data?.toCategoryEntity()),
      error:   (exception) => Error(exception: exception),
    );
  }

  @override
  Future<Result<CategoryEntity>> getCategoryById(String id) async {
    final result = await remoteDataSource.getCategoryById(id);
    return result.when(
      success: (data) => Success(data: data?.toEntity()),
      error:   (exception) => Error(exception: exception),
    );
  }
}
```

---

## 8. Cubit Layer

### State (`categories_state.dart` — `part of categories_cubit.dart`)

```dart
class CategoriesState extends Equatable {
  final BaseState<BasePaginationEntity<CategoryEntity>> categoriesState;
  final ModeEnum? selectedMode;

  const CategoriesState({
    this.categoriesState = const BaseState.initial(),
    this.selectedMode,
  });

  CategoriesState copyWith({ ... });
}
```

### Events (`categories_events.dart`)

```dart
sealed class CategoriesEvent { const CategoriesEvent(); }

class LoadCategoriesEvent     extends CategoriesEvent { final CategoryParams? params; ... }
class LoadMoreCategoriesEvent extends CategoriesEvent { final CategoryParams  params; ... }
class FilterByModeEvent       extends CategoriesEvent { final ModeEnum mode; ... }
class ClearFiltersEvent       extends CategoriesEvent { const ClearFiltersEvent(); }
```

### UI Events (`categories_ui_events.dart`)

```dart
sealed class CategoriesUiEvent { const CategoriesUiEvent(); }

class ShowErrorUiEvent                 extends CategoriesUiEvent { final String message; ... }
class NavigateToCategoryDetailsUiEvent extends CategoriesUiEvent { final String categoryId; ... }
```

### Cubit (`categories_cubit.dart`)

```dart
class CategoriesCubit extends BaseCubit<CategoriesState, CategoriesUiEvent> {
  // Single entry point
  Future<void> doIntent(CategoriesEvent event) async => switch (event) {
    LoadCategoriesEvent()     => _loadCategories(event),
    LoadMoreCategoriesEvent() => _loadMoreCategories(event),
    FilterByModeEvent()       => _filterByMode(event),
    ClearFiltersEvent()       => _clearFilters(),
  };

  // Helper getters
  List<CategoryEntity> get categories => state.categoriesState.data?.data ?? [];

  List<CategoryEntity> getCategoriesByMode(ModeEnum mode) =>
      categories.where((c) => c.mode == mode || c.mode == ModeEnum.both).toList();

  List<CategoryEntity> getActiveCategories() =>
      categories.where((c) => c.isActive && !c.isDeleted).toList();

  bool get hasNextPage => state.categoriesState.data?.meta.hasNextPage ?? false;
  int? get currentPage => state.categoriesState.data?.meta.currentPage;
}
```

---

## 9. Dependency Injection

```dart
getIt.registerLazySingleton<BaseCategoriesRemoteDataSource>(
  () => CategoriesRemoteDataSourceImpl(getIt<ApiConsumer>()),
);
getIt.registerLazySingleton<CategoriesRepository>(
  () => CategoriesRepositoryImpl(getIt<BaseCategoriesRemoteDataSource>()),
);
getIt.registerLazySingleton<GetCategoriesUseCase>(
  () => GetCategoriesUseCase(getIt<CategoriesRepository>()),
);
getIt.registerLazySingleton<GetCategoryByIdUseCase>(
  () => GetCategoryByIdUseCase(getIt<CategoriesRepository>()),
);
getIt.registerFactory<CategoriesCubit>(
  () => CategoriesCubit(getCategoriesUseCase: getIt<GetCategoriesUseCase>()),
);
```

---

## 10. UI Usage

### Provide & load
```dart
BlocProvider(
  create: (_) => getIt<CategoriesCubit>()
    ..doIntent(const LoadCategoriesEvent(params: CategoryParams(isActive: true))),
  child: CategoriesScreen(),
);
```

### React to state
```dart
BlocBuilder<CategoriesCubit, CategoriesState>(
  builder: (context, state) => state.categoriesState.when(
    initial: () => const SizedBox.shrink(),
    loading: () => const CategoriesShimmer(),
    success: (paginatedData) => ListView.builder(
      itemCount: paginatedData.data.length,
      itemBuilder: (_, i) => CategoryCard(category: paginatedData.data[i]),
    ),
    error: (e) => ErrorWidget(
      message: e.toString(),
      onRetry: () => context.read<CategoriesCubit>().doIntent(const LoadCategoriesEvent()),
    ),
  ),
);
```

### Load more (pagination)
```dart
_scrollController.addListener(() {
  if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
    final cubit = context.read<CategoriesCubit>();
    if (cubit.hasNextPage) {
      cubit.doIntent(LoadMoreCategoriesEvent(
        params: CategoryParams(page: (cubit.currentPage ?? 1) + 1),
      ));
    }
  }
});
```

### Filter by mode
```dart
cubit.doIntent(FilterByModeEvent(ModeEnum.discount));
// Reset:
cubit.doIntent(const ClearFiltersEvent());
```

---

## 11. Key Rules

### OOP
- **`CategoryModel` does NOT extend `CategoryEntity`** — standalone data class, no inheritance.
- **`CategoriesResponseDto` extends `BasePaginationDto<CategoryModel>`** — only overrides `data` serialization; all common logic is inherited.
- **`BasePaginationDto.extractMetadata(json)`** — call the static base method, never duplicate the detection logic.
- **`super.toJson()` first** — call it, then override only `data`; never repeat message/pagination fields.

### Imports & paths
- Import path for entity/model must be **`package:atoz/core/shared/global/categories/...`**, not `package:atoz/shared/categories/...`.
- **No `meta_dto.dart` import** needed in subclass DTOs — `MetaDto` is used only inside `BasePaginationDto`.

### Data & modes
- **Never use raw strings for mode** — always `ModeEnum.fromString()` in `fromJson`, `.value` in `toJson`.
- **`ModeEnum.both`** = catch-all; always include it alongside any mode filter in repository and cubit helpers.

### Architecture
- **No try/catch** in data source or repository — `executeApi` handles it.
- **`makeDummyData`** in repo = offline development works without a backend.
- **Flat pagination** (`total`, `limit`, `page` at root) handled by `BasePaginationDto.extractMetadata()`.
- **`part of`** — state, events, ui_events are parts of `categories_cubit.dart`.
- **Loading guard** — `if (state.categoriesState.isLoading) return;` at top of every async handler.
- **`ApiConsumer`** (not Retrofit) — real HTTP client used in the impl.

---

**Last updated**: July 2026  
**Pattern**: Global Shared Data — Clean Architecture  
**Status**: ✅ Production Ready
