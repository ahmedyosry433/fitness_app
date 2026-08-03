# 02 — API Layer

**No Retrofit**. We use `ApiConsumer` (DioConsumer wrapper) directly with `EndPoints` constants.

Remote data source implementations live in `api/data_sources/` and wrap `ApiConsumer` calls in `executeApi`.

---

## Step 1: Add Endpoint Constant

```dart
// lib/core/api/end_points.dart
class EndPoints {
  // ... existing
  static String merchantRegister = 'auth/register/merchant';
  static String categories = 'categories';
}
```

---

## Step 2: RemoteDataSourceImpl (`api/data_sources/{feature}_remote_data_source_impl.dart`)

**Responsibility**: Use `ApiConsumer` directly, wrap in `executeApi<T>()`, return `Result<T>`.

```dart
import 'package:atoz/core/api/api_consumer.dart';
import 'package:atoz/core/api/end_points.dart';
import 'package:atoz/core/base_response/api_execute.dart';
import 'package:atoz/core/base_response/result.dart';

class MerchantSignUpRemoteDataSourceImpl
    implements MerchantSignUpRemoteDataSource {
  final ApiConsumer _apiConsumer;

  const MerchantSignUpRemoteDataSourceImpl(this._apiConsumer);

  // Normal JSON POST
  @override
  Future<Result<UserModel>> doSomething(SomeParams params) {
    return executeApi<UserModel>(
      () async {
        final response = await _apiConsumer.post(
          path: EndPoints.someEndpoint,
          body: params.toJson(),
        );
        return UserModel.fromJson(response);
      },
    );
  }

  // Multipart upload (images)
  @override
  Future<Result<UserModel>> registerMerchant(MerchantSignUpParams params) {
    return executeApi<UserModel>(
      () async {
        final formData = await params.toFormData();   // async — builds MultipartFile
        final response = await _apiConsumer.post(
          path: EndPoints.merchantRegister,
          body: formData,                              // FormData passed directly
        );
        final user = UserModel.fromJson(response);
        await saveUserAuth(user);                      // side effect: persist token
        return user;
      },
    );
  }

  // GET with query params
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

  // GET with path parameter
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
- `const` constructor.
- Use `_apiConsumer.get/post/put/patch/delete` directly — no intermediate api_client class.
- Wrap every call in `executeApi<T>()` — **never** add try/catch.
- `saveUserAuth(user)` lives in auth features (imports from `login_repo_impl.dart`).
- Lives in `api/data_sources/` layer (not `data/data_sources/`).

**ApiConsumer Methods:**
- `get(path, queryParameters)` — GET request
- `post(path, body)` — POST request (JSON or FormData)
- `put(path, body)` — PUT request
- `patch(path, body)` — PATCH request
- `delete(path)` — DELETE request

**Imports:**
```dart
import 'package:atoz/core/api/api_consumer.dart';
import 'package:atoz/core/api/end_points.dart';
import 'package:atoz/core/base_response/api_execute.dart';
import 'package:atoz/core/base_response/result.dart';
```

---

## What executeApi does

```dart
Future<Result<T>> executeApi<T>(Future<T> Function() apiCall) async {
  try {
    final result = await apiCall();
    return Success<T>(data: result);
  } on DioException catch (ex) {
    return Error<T>(exception: ServerFailure.fromDioException(dioException: ex));
  } on Exception catch (ex) {
    return Error<T>(exception: ex);
  }
}
```

So: success → `Success(data: model)`, network/server error → `Error(exception: ServerFailure(...))`.
