# 04 — Domain Layer

Files: **Repository contract**, **UseCase**.
Note: Entity files live under `domain/entities/` and are **standalone** classes (see
`03-data-layer.md`). They are NOT `part of` the model and the model does NOT extend them —
the DTO's `toEntity()` mapper is the only bridge.

---

## Repository Contract (`domain/repositories/{feature}_repo.dart`)

```dart
import 'package:atoz/app_versions/merchant/orders/domain/entities/orders_entity.dart';
import 'package:atoz/core/base_response/result.dart';

abstract class OrdersRepo {
  // GET list with query params (entity as query holder)
  Future<Result<OrdersEntity>> getOrders(OrderQueryEntity query);

  // GET single item
  Future<Result<OrderDetailsEntity>> getOrderById(String id);

  // POST / PUT action
  Future<Result<void>> updateOrderStatus(String id, String status);
}
```

**Rules:**
- Abstract only — no `ApiConsumer`, `Dio`, or `DioConsumer` imports.
- Returns `Result<T>` from `package:atoz/core/base_response/result.dart`.
- Entity/params imports come from `domain/entities/` (standalone classes) — the domain
  contract must return **entities**, never DTOs.
- `Future<Result<void>>` for actions that return nothing meaningful.
- For legacy Either features: keep as-is, don't mix patterns mid-feature.

---

## UseCase (`domain/use_cases/{action}_use_case.dart`)

### Pattern 1 — With params

```dart
import 'package:atoz/app_versions/merchant/orders/domain/entities/orders_entity.dart';
import 'package:atoz/app_versions/merchant/orders/domain/repositories/orders_repo.dart';
import 'package:atoz/core/base_response/base_use_case.dart';
import 'package:atoz/core/base_response/result.dart';

class GetOrdersUseCase extends BaseUseCase<OrdersEntity, OrderQueryEntity> {
  final OrdersRepo _repository;

  const GetOrdersUseCase(this._repository);

  @override
  Future<Result<OrdersEntity>> call(OrderQueryEntity params) =>
      _repository.getOrders(params);
}
```

### Pattern 2 — No params

```dart
import 'package:atoz/core/base_response/base_use_case.dart';
import 'package:atoz/core/base_response/result.dart';
import 'package:atoz/core/uses_cases/params.dart';   // NoParams

class GetProfileUseCase extends BaseUseCase<StoreDetailsEntity, NoParams> {
  final ProfileRepo _repository;

  const GetProfileUseCase(this._repository);

  @override
  Future<Result<StoreDetailsEntity>> call(NoParams params) =>
      _repository.getProfile();
}
```

### Pattern 3 — String / primitive param

```dart
class GetOrderByIdUseCase extends BaseUseCase<OrderDetailsEntity, String> {
  final OrdersRepo _repository;

  const GetOrderByIdUseCase(this._repository);

  @override
  Future<Result<OrderDetailsEntity>> call(String id) =>
      _repository.getOrderById(id);
}
```

### Pattern 3b — Cacheable GET (`forceRefresh` flag)

For read-mostly data cached in the repo (see `03-data-layer.md` → "Repository caching"),
the GET use case takes a `bool` param = `forceRefresh`. `false` returns the cache (no
server request); `true` (pull-to-refresh / retry) bypasses it.

```dart
class GetProfileUseCase extends BaseUseCase<ProfileEntity, bool> {
  final ProfileRepo _repository;

  const GetProfileUseCase(this._repository);

  @override
  Future<Result<ProfileEntity>> call(bool forceRefresh) =>
      _repository.getProfile(forceRefresh: forceRefresh);
}
```

### Pattern 4 — Void return (action/mutation)

```dart
class UpdateOrderStatusUseCase extends BaseUseCase<void, UpdateStatusParams> {
  final OrdersRepo _repository;

  const UpdateOrderStatusUseCase(this._repository);

  @override
  Future<Result<void>> call(UpdateStatusParams params) =>
      _repository.updateOrderStatus(params.id, params.status);
}

// Simple params struct for the action
class UpdateStatusParams {
  final String id;
  final String status;
  const UpdateStatusParams({required this.id, required this.status});
}
```

### Pattern 5 — Legacy (Either) — for existing features

```dart
// Keep this for existing features — don't migrate mid-feature
class GetProductsUseCase extends UseCase<ProductsEntity, PaginationParams> {
  final ProductsRepository _repository;
  GetProductsUseCase(this._repository);

  @override
  Future<Either<Failures, ProductsEntity>> call(PaginationParams params) =>
      _repository.getProducts(params);
}
```

---

## Rules Summary

| Rule | Detail |
|------|--------|
| Base class | `BaseUseCase<ReturnType, ParamsType>` |
| Import | `package:atoz/core/base_response/base_use_case.dart` |
| Constructor | Always `const` |
| No params | Use `NoParams` from `core/uses_cases/params.dart` |
| Pagination | Use `PaginationParams` from same file |
| Primitive | Use `String`, `int`, etc. directly |
| Void return | `BaseUseCase<void, ParamsType>` |
| Multiple params | Create a small params struct in this file or in `data/models/` |
| One file | One use case per file — name: `{verb}_{noun}_use_case.dart` |
| No logic | Just delegates to `_repository.method(params)` |
