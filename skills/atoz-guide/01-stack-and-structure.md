# 01 — Stack & Structure

## Tech Stack Table

| Concern | Use | Never use |
|---------|-----|-----------|
| DI | `get_it` manual `registerLazySingleton` | injectable code-gen |
| Networking | `ApiConsumer` (abstract Dio wrapper) | plain Dio, Retrofit |
| Error wrapping | `executeApi<T>()` → `Result<T>` | try/catch in repo |
| Result type | `Result<T>` sealed + `.when()` | dartz Either (legacy only) |
| State | `BaseState<T>` + `copyWith` + `Equatable` | multiple sealed state classes |
| Cubit | `BaseCubit<State, UiEvent>` | one cubit per action |
| UI side effects | `emitEvent(UiEvent)` → `eventStream` | BlocListener, context in cubit |
| Strings | `AppStrings.*` only | any inline Arabic/English literal |
| Widget structure | one class = one file | `Widget _buildX()` methods |
| Colors | `AppColors.*` | `Color(0xFF...)` inline |
| Sizes | `context.setWidth/setHeight/setMinSize` | hardcoded numbers |
| Font styles | `AppFontStyle.regularXX(context)` / `CustomAppFontStyle.regularXX` | inline `TextStyle` |
| Images/Icons | `AppImages.*` / `AppIcons.*` | inline asset string paths |
| Routing | `go_router` + `AppRouter` constants | `Navigator.push` |

---

## Folder Structure

```
lib/app_versions/{role}/{feature}/
├── api/
│   ├── api_client/
│   │   └── {feature}_api_client.dart         # ApiConsumer calls only
│   └── data_sources/
│       └── {feature}_remote_data_source_impl.dart  # executeApi wrapper
├── data/
│   ├── data_sources/
│   │   └── {feature}_remote_data_source.dart # abstract contract
│   ├── models/
│   │   └── {feature}_params.dart             # input data + copyWith + toJson
│   └── repositories/
│       └── {feature}_repo_impl.dart          # delegates, no try/catch
├── domain/
│   ├── repositories/
│   │   └── {feature}_repo.dart               # abstract, returns Result<T>
│   └── use_cases/
│       └── {action}_use_case.dart            # one per action
└── presentation/
    ├── cubit/
    │   ├── {feature}_cubit.dart
    │   ├── {feature}_state.dart
    │   ├── {feature}_events.dart
    │   └── {feature}_ui_events.dart
    ├── pages/
    │   └── {feature}_page.dart
    └── widgets/
        ├── {feature}_header.dart
        └── {widget_name}_widget.dart         # one public class per file
```

---

## Naming Conventions

| Item | Pattern | Example |
|------|---------|---------|
| Feature folder | `snake_case` | `merchant_sign_up` |
| Dart files | `snake_case.dart` | `step1_fields_widget.dart` |
| Classes | `PascalCase` | `MerchantSignUpCubit` |
| Params class | `{Feature}Params` | `MerchantSignUpParams` |
| Cubit | `{Feature}Cubit` | `MerchantSignUpCubit` |
| State | `{Feature}State` | `MerchantSignUpState` |
| Event | `{Action}Event` | `SaveStep1Event` |
| UiEvent | `{Action}UiEvent` | `RegistrationSuccessUiEvent` |
| Use case | `{Verb}{Noun}UseCase` | `RegisterMerchantUseCase` |
| Repository | `{Feature}Repo` | `MerchantSignUpRepo` |
| Repo impl | `{Feature}RepoImpl` | `MerchantSignUpRepoImpl` |
| API client | `{Feature}ApiClient` | `MerchantSignUpApiClient` |
| Widget file | `{description}_widget.dart` | `step1_fields_widget.dart` |
| Widget class | `{Description}Widget` | `Step1FieldsWidget` |
