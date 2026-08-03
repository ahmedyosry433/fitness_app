# 08 — Dependency Injection & Routing

---

## DI Registration (`lib/core/dependency_injection/dependency_injection.dart`)

### Registration Order (always bottom-up)

**For role-specific features (customer/merchant/driver):**
```dart
// 1. Remote data source implementation (depends on ApiConsumer)
getIt.registerLazySingleton<MerchantSignUpRemoteDataSourceImpl>(
  () => MerchantSignUpRemoteDataSourceImpl(getIt.get<ApiConsumer>()),
);

// 2. Data Source — bind impl to abstract contract
getIt.registerLazySingleton<MerchantSignUpRemoteDataSource>(
  () => getIt.get<MerchantSignUpRemoteDataSourceImpl>(),
);

// 3. Repository — bind impl to abstract contract
getIt.registerLazySingleton<MerchantSignUpRepo>(
  () => MerchantSignUpRepoImpl(
        getIt.get<MerchantSignUpRemoteDataSource>()),
);

// 4. Use Cases (if multiple, register each separately)
getIt.registerLazySingleton<RegisterMerchantUseCase>(
  () => RegisterMerchantUseCase(getIt.get<MerchantSignUpRepo>()),
);

// 5. Cubit — only if used across screens (rare)
//    Most cubits are created inline in the page's initState.
//    Use registerFactory for short-lived per-screen cubits:
// getIt.registerFactory<MerchantSignUpCubit>(
//   () => MerchantSignUpCubit(
//         registerMerchantUseCase: getIt.get<RegisterMerchantUseCase>()),
// );
```

**For global shared features (categories, cities):**
```dart
// 1. Remote data source implementation
getIt.registerLazySingleton<CategoriesRemoteDataSourceImpl>(
  () => CategoriesRemoteDataSourceImpl(getIt.get<ApiConsumer>()),
);

// 2. Bind to abstract contract
getIt.registerLazySingleton<BaseCategoriesRemoteDataSource>(
  () => getIt.get<CategoriesRemoteDataSourceImpl>(),
);

// 3. Repository
getIt.registerLazySingleton<CategoriesRepository>(
  () => CategoriesRepositoryImpl(
        getIt.get<BaseCategoriesRemoteDataSource>()),
);

// 4. Use cases
getIt.registerLazySingleton<GetCategoriesUseCase>(
  () => GetCategoriesUseCase(getIt.get<CategoriesRepository>()),
);

// 5. Cubit — SINGLETON (shared state across app)
getIt.registerSingleton<CategoriesCubit>(
  CategoriesCubit(
    getCategoriesUseCase: getIt.get<GetCategoriesUseCase>(),
  ),
);
```

### When to use which registration

| Type | Use | Example |
|------|-----|---------|
| `registerLazySingleton` | Stateless services (repos, data sources) | `MerchantSignUpRepo` |
| `registerFactory` | Short-lived cubits (fresh per screen) | `ProductsCubit` |
| `registerSingleton` | Global singletons initialized at startup, global shared feature cubits | `BasicCubit`, `CategoriesCubit` |

### Imports to add
Add at the top of `dependency_injection.dart` alongside existing imports:

**For role-specific features:**
```dart
import 'package:atoz/app_versions/merchant/sign_up/api/data_sources/merchant_sign_up_remote_data_source_impl.dart';
import 'package:atoz/app_versions/merchant/sign_up/data/data_sources/merchant_sign_up_remote_data_source.dart';
import 'package:atoz/app_versions/merchant/sign_up/data/repositories/merchant_sign_up_repo_impl.dart';
import 'package:atoz/app_versions/merchant/sign_up/domain/repositories/merchant_sign_up_repo.dart';
import 'package:atoz/app_versions/merchant/sign_up/domain/use_cases/register_merchant_use_case.dart';
```

**For global shared features:**
```dart
import 'package:atoz/core/shared/global/categories/api/data_sources/categories_remote_data_source_impl.dart';
import 'package:atoz/core/shared/global/categories/data/data_sources/categories_remote_data_source.dart';
import 'package:atoz/core/shared/global/categories/data/repositories/categories_repository_impl.dart';
import 'package:atoz/core/shared/global/categories/domain/repositories/categories_repository.dart';
import 'package:atoz/core/shared/global/categories/domain/use_cases/get_categories_use_case.dart';
import 'package:atoz/core/shared/global/categories/presentation/cubit/categories_cubit.dart';
```

---

## Routing

### Step 1 — Add constant (`lib/core/routing/routes.dart`)
```dart
class AppRouter {
  // ... existing
  static const String merchantSignUp = '/merchantSignUp';
}
```

### Step 2 — Add GoRoute (`lib/core/routing/app_router.dart`)

Simple route (no args):
```dart
GoRoute(
  path: AppRouter.merchantSignUp,
  name: AppRouter.merchantSignUp,
  pageBuilder: (context, state) =>
      adaptivePage(key: state.pageKey, child: const MerchantSignUpPage()),
),
```

Route with required argument:
```dart
GoRoute(
  path: AppRouter.storeDetails,
  name: AppRouter.storeDetails,
  pageBuilder: (context, state) {
    final model = state.extra as CustomerStoreModel?;
    if (model == null) throw ArgumentError('CustomerStoreModel is required');
    return adaptivePage(
      key: state.pageKey,
      child: CustomerStorePageDetails(storeModel: model),
    );
  },
),
```

Route with optional int (default fallback):
```dart
GoRoute(
  path: AppRouter.shoppingOptions,
  pageBuilder: (context, state) => adaptivePage(
    key: state.pageKey,
    child: ShoppingOptionsScreen(
      roleEnum: state.extra as RoleEnum? ?? RoleEnum.user,
    ),
  ),
),
```

### Step 3 — Navigate
```dart
// Simple
context.go(AppRouter.merchantSignUp);

// With argument
context.go(AppRouter.storeDetails, extra: storeModel);
context.go(AppRouter.shoppingOptions, extra: RoleEnum.merchant);

// Push (keeps back stack)
context.push(AppRouter.forgetPassword);
```

### Import to add in app_router.dart
```dart
import 'package:atoz/app_versions/merchant/sign_up/presentation/pages/merchant_sign_up_page.dart';
```
