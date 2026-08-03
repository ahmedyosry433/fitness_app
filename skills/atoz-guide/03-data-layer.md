# 03 — Data Layer

Files: **DataSource contract**, **Params model**, **Response Model (DTO)**, **RepoImpl**.

---

## ⛔️ Golden Rule: Model (DTO) and Entity are SEPARATE classes

**NEVER** make the model extend the entity. **NEVER** link them with `part` / `part of`.

- The **model (DTO)** belongs to the **data layer**. It depends on the API/JSON shape
  (`fromJson`, `toJson`, `_id`, nullable fields, raw strings).
- The **entity** belongs to the **domain layer** and is consumed by the **UI**. It holds
  clean, type-safe fields (enums, non-null values, `empty()` / `fake()`).
- They are bridged by an explicit **mapper**: `Model.toEntity()` (read path) and, when the
  UI must send a full object back, `Model.fromEntity(entity)` (write path).

Why: coupling the DTO to the entity by inheritance forces the domain/UI to change whenever
the backend JSON changes, and forces the DTO to carry UI concerns. Keeping them separate
means the API shape and the UI shape evolve independently — the mapper is the only thing
that changes.

```
data/models/{feature}_model.dart      ← standalone DTO. imports Dio/json helpers.
                                         has fromJson / toJson / toEntity(). NO extends.
domain/entities/{feature}_entity.dart  ← standalone entity. its own imports.
                                         has empty() / fake(). NEVER part of the model.
```

---

## ⚠️ Critical Rule: Enum Injection

**ALWAYS** use enums instead of raw strings for enum-like fields — but the **enum lives on
the entity (domain)** side. The DTO keeps the **raw string** from the API and converts it in
`toEntity()`.

### Where to Find Enums

Search these locations **before** creating string fields:
- `lib/shared/model/` — `mode_enum.dart`, `roles.dart`
- `lib/core/enums/` — `order_status.dart`, payment status, etc.

### Entity holds the enum

```dart
// category_entity.dart  — standalone domain class
import 'package:atoz/shared/model/mode_enum.dart';

class CategoryEntity {
  final String id;
  final String name;
  final ModeEnum mode;           // type-safe enum, UI-facing

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.mode,
  });

  factory CategoryEntity.empty() =>
      const CategoryEntity(id: '', name: '', mode: ModeEnum.shopping);
}
```

### DTO keeps the raw string and converts in the mapper

```dart
// category_model.dart  — standalone DTO, does NOT extend CategoryEntity
import 'package:atoz/shared/model/mode_enum.dart';
import 'package:atoz/app_versions/.../domain/entities/category_entity.dart';

class CategoryModel {
  final String id;
  final String name;
  final String mode;             // raw API string

  const CategoryModel({
    required this.id,
    required this.name,
    required this.mode,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json['_id'] ?? json['id'] ?? '',
    name: json['name'] ?? '',
    mode: json['mode'] ?? '',
  );

  Map<String, dynamic> toJson() => {'name': name.trim(), 'mode': mode};

  // string → enum happens HERE, in the mapper
  CategoryEntity toEntity() => CategoryEntity(
    id: id,
    name: name,
    mode: ModeEnum.values.firstWhere(
      (e) => e.name.toLowerCase() == mode.toLowerCase(),
      orElse: () => ModeEnum.shopping,
    ),
  );
}
```

**Common Enums:**
- `ModeEnum` (shopping, discount, both) — `lib/shared/model/mode_enum.dart`
- `RoleEnum` (user, merchant, driver) — `lib/shared/model/roles.dart`
- `OrderStatus` — `lib/core/enums/order_status.dart`

---

## Entity (`domain/entities/{feature}_entity.dart`)

Standalone Dart class. Has its **own imports** (it is NOT `part of` anything). No Dio, no
JSON. Provides `empty()` and `fake()` factories.

```dart
// import only what the domain/UI needs (enums, AppStrings for labels, nested entities)
import 'package:atoz/shared/model/roles.dart';

class OrderDetailsEntity {
  final String id;
  final String orderId;
  final OrderStatus status;      // enum, not String
  final double total;
  final UserEntity user;
  final DateTime createdAt;

  const OrderDetailsEntity({
    required this.id,
    required this.orderId,
    required this.status,
    required this.total,
    required this.user,
    required this.createdAt,
  });

  // Always provide empty() — used for initial state
  factory OrderDetailsEntity.empty() => OrderDetailsEntity(
    id: '',
    orderId: '',
    status: OrderStatus.pending,
    total: 0.0,
    user: UserEntity.empty(),
    createdAt: DateTime.now(),
  );

  // Always provide fake() — used for Skeletonizer shimmer loading
  factory OrderDetailsEntity.fake() => OrderDetailsEntity(
    id: 'fake-id-123',
    orderId: '9999999',
    status: OrderStatus.pending,
    total: 270.0,
    user: UserEntity.fake(),
    createdAt: DateTime.now(),
  );
}

// Nested entities also live in this file
class UserEntity {
  final String id;
  final String displayName;

  const UserEntity({required this.id, required this.displayName});

  factory UserEntity.empty() => const UserEntity(id: '', displayName: '');
  factory UserEntity.fake() =>
      const UserEntity(id: 'fake', displayName: 'Fake User');
}
```

**Rules:**
- **NO** `part of`. The entity is a normal class with its own `import`s.
- **NO** dependency on the model — the domain must not know the DTO exists.
- Every entity class needs `empty()` + `fake()`.
- Enum-like fields are **enums**, not strings.
- Nested entities (UserEntity, LocationEntity, etc.) go in the **same file**.
- Query/filter params classes also go here (e.g. `OrderQueryEntity`).

---

## Response Model / DTO (`data/models/{feature}_model.dart`)

Standalone class — **does NOT extend the entity**. Holds the raw API shape, adds `fromJson`,
`toJson`, and a `toEntity()` mapper (plus `fromEntity()` only if the write path needs a full
object). Imports the entity so the mapper can build it.

```dart
import 'package:atoz/core/utils/constants/app_constants.dart';
import 'package:atoz/app_versions/.../domain/entities/order_details_entity.dart';

// NO `part`, NO `extends` — a plain DTO class.
class OrderDetailsModel {
  final String id;
  final String orderId;
  final String status;           // raw string from API
  final double total;
  final UserModel user;
  final DateTime createdAt;

  const OrderDetailsModel({
    required this.id,
    required this.orderId,
    required this.status,
    required this.total,
    required this.user,
    required this.createdAt,
  });

  // 1. Parse from API response
  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailsModel(
      id: json['_id'] ?? json['id'] ?? '',     // ← handle both _id and id
      orderId: json['orderId'] ?? '',
      status: json['status'] ?? '',
      total: (json['total'] ?? 0).toDouble(),  // ← safe num → double cast
      user: UserModel.fromJson(json['user'] ?? {}),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '')?.toLocal()
          ?? DateTime.now(),                   // ← safe DateTime parse
    );
  }

  // 2. Serialize for API PUT/POST requests
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'orderId': orderId,
      'status': status,
      'total': total,
      'user': user.toJson(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // 3. Map DTO → domain entity (the ONLY bridge between the layers)
  OrderDetailsEntity toEntity() {
    return OrderDetailsEntity(
      id: id,
      orderId: orderId,
      status: OrderStatus.values.firstWhere(
        (e) => e.name.toLowerCase() == status.toLowerCase(),
        orElse: () => OrderStatus.pending,
      ),
      total: total,
      user: user.toEntity(),
      createdAt: createdAt,
    );
  }
}

// Nested DTOs follow the same shape — separate class, fromJson/toJson/toEntity
class UserModel {
  final String id;
  final String displayName;

  const UserModel({required this.id, required this.displayName});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['_id'] ?? '',
    displayName: json['displayName'] ?? '',
  );
  Map<String, dynamic> toJson() => {'_id': id, 'displayName': displayName};
  UserEntity toEntity() => UserEntity(id: id, displayName: displayName);
}
```

**Rules:**
- Model is a **plain class** — `class XModel { ... }`. **NEVER** `extends XEntity`.
- **NEVER** `part` / `part of`. The model `import`s the entity to build it in `toEntity()`.
- Factories: `fromJson`, `toJson`, `toEntity` (add `fromEntity` only if a write path needs it).
- `_id` and `id` both handled: `json['_id'] ?? json['id'] ?? ''`.
- Null-safe defaults: `?? ''`, `?? 0`, `?? false`, `?? []`, `?? {}`.
- Safe num cast: `(json['price'] ?? 0).toDouble()`.
- Safe DateTime: `DateTime.tryParse(json['createdAt'] ?? '')?.toLocal() ?? DateTime.now()`.
- Nested objects: `NestedModel.fromJson(json['nested'] ?? {})`.
- Lists: `(json['items'] ?? []).map<ItemModel>((x) => ItemModel.fromJson(x)).toList()`.
- string → enum conversion happens inside `toEntity()`, never in the DTO fields.

---

## Params Model (`data/models/{feature}_params.dart`)

Input-only class — carries data from the UI to the API. Plain class, no inheritance.

```dart
class MerchantSignUpParams {
  final String fullName;
  final String phone;
  final File? storeLogo;
  final int discountPercentage;

  const MerchantSignUpParams({
    this.fullName = '',
    this.phone = '',
    this.storeLogo,
    this.discountPercentage = 20,
  });

  MerchantSignUpParams copyWith({
    String? fullName,
    String? phone,
    File? storeLogo,
    int? discountPercentage,
  }) => MerchantSignUpParams(
    fullName: fullName ?? this.fullName,
    phone: phone ?? this.phone,
    storeLogo: storeLogo ?? this.storeLogo,
    discountPercentage: discountPercentage ?? this.discountPercentage,
  );

  // Normal JSON POST
  Map<String, dynamic> toJson() => {
    'displayName': fullName,
    'phone': '${AppConstants.phoneCode}$phone',  // phone code here, not in cubit
  };

  // Multipart/form-data (when images involved)
  Future<FormData> toFormData() async {
    final map = <String, dynamic>{
      'displayName': fullName,
      'phone': '${AppConstants.phoneCode}$phone',
    };
    if (storeLogo != null) {
      map['logo'] = await MultipartFile.fromFile(
        storeLogo!.path,
        filename: storeLogo!.path.split('/').last,
      );
    }
    return FormData.fromMap(map);
  }
}
```

---

## DataSource Contract (`data/data_sources/{feature}_remote_data_source.dart`)

```dart
abstract class OrdersRemoteDataSource {
  Future<Result<OrdersModel>> getOrders(OrderQueryEntity query);
  Future<Result<void>> updateOrderStatus(String id, String status);
}
```

**Rules:**
- Abstract only. Returns `Result<T>` where T is a **model/DTO** (or `void`).
  The repo maps model → entity via `toEntity()`.
- Repo imports **this contract**, never the impl.

---

## RepoImpl (`data/repositories/{feature}_repo_impl.dart`)

The repo is where `Model → Entity` mapping happens (via the DTO's `toEntity()`), because the
data source returns DTOs and the domain contract returns entities.

```dart
class OrdersRepoImpl extends OrdersRepo {
  final OrdersRemoteDataSource _remoteDataSource;

  OrdersRepoImpl(this._remoteDataSource);  // NOT const

  @override
  Future<Result<OrdersEntity>> getOrders(OrderQueryEntity query) async {
    final result = await _remoteDataSource.getOrders(query);
    return result.when(
      success: (model) => Success(data: model?.toEntity()),
      error: (e) => Error(exception: e),
    );
  }
}
```

**Rules:**
- Constructor is **not** `const`.
- Always map DTO → entity here with `.toEntity()` — never expose the DTO to the domain/UI.
- **No try/catch** — handled by `executeApi`.

---

## Repository caching (avoid refetching on every navigation)

The repo is registered as a **lazy singleton**, so it outlives cubits/pages. Cache
read-mostly data (profile, config, contact info, lookups) in the repo and return the
cached value unless the caller asks for a refresh. This prevents a new server request
every time the user re-opens a screen.

```dart
class ProfileRepoImpl extends ProfileRepo {
  final ProfileRemoteDataSource _remoteDataSource;
  ProfileRepoImpl(this._remoteDataSource);

  ProfileEntity? _cachedProfile;   // survives across screens (singleton repo)

  @override
  Future<Result<ProfileEntity>> getProfile({bool forceRefresh = false}) async {
    final cached = _cachedProfile;
    if (!forceRefresh && cached != null) {
      return Success(data: cached);          // ← cache hit: NO server request
    }

    final result = await _remoteDataSource.getProfile();
    final mapped = result.makeDummyData<ProfileEntity>(
      dummyData: ProfileEntity.fake(),
      success: (model) => Success(data: model?.toEntity() ?? ProfileEntity.empty()),
      error: (e) => Error(exception: e),
    );

    // Cache the resolved entity (works for both real success and debug dummy).
    return mapped.when(
      success: (entity) {
        if (entity != null) _cachedProfile = entity;
        return Success(data: entity);
      },
      error: (e) => Error(exception: e),
    );
  }

  @override
  Future<Result<ProfileEntity>> updateProfile({required UpdateParams params}) async {
    final result = await _remoteDataSource.updateProfile(params);
    final mapped = result.makeDummyData<ProfileEntity>(/* ... */);
    return mapped.when(
      success: (entity) {
        if (entity != null) _cachedProfile = entity;   // ← keep cache in sync on write
        return Success(data: entity);
      },
      error: (e) => Error(exception: e),
    );
  }

  @override
  Future<Result<void>> logout() async {
    final result = await _remoteDataSource.logout();
    _cachedProfile = null;                              // ← clear on logout
    return result;
  }
}
```

**Rules:**
- Cache only read-mostly data that is safe to reuse within a session (profile, config,
  contact info, static lookups). Do NOT cache lists that must always be live (orders,
  live search results) unless the feature explicitly wants it.
- The GET method takes `{bool forceRefresh = false}`; the matching GET use case takes a
  `bool` param and forwards it (see `04-domain-layer.md`).
- **Update the cache on every successful write** (`update…`, `create…`) so screens show
  fresh data without an extra request.
- **Clear the cache on `logout`** (and on any account switch) so a new user never sees
  the previous user's data.
- The cache lives in the repo, NOT the cubit — cubits are recreated per screen and
  cannot dedup across navigations.

