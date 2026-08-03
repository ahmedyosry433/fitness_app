# 09 — Base Classes Quick Reference

| Class / Helper | Import path | What it does |
|----------------|-------------|--------------|
| `BaseCubit<S, E>` | `core/base_state/base_cubit.dart` | Cubit + `eventStream` for one-shot UI side effects |
| `BaseState<T>` | `core/base_state/base_state.dart` | `.initial()` / `.loading()` / `.success(data)` / `.error(e)` |
| `BasePaginationDto<T>` | `core/base_response/model/base_pagination_dto.dart` | Generic factory `fromJson(json, mapper)` auto-detects flat/nested pagination; `toJson()` writes message+total/limit/page; `toEntity<E>(mapper)` → entity. Subclasses call `BasePaginationDto<T>.fromJson()` then wrap result. |
| `BasePaginationEntity<T>` | `core/base_response/entity/base_pagination_entity.dart` | Domain entity for paginated data with `meta` and `data` |
| `BaseUseCase<T, P>` | `core/base_response/base_use_case.dart` | UseCase returning `Result<T>` |
| `Result<T>` | `core/base_response/result.dart` | Sealed `Success<T>` / `Error<T>` + `.when(success, error)` + `.makeDummyData()` |
| `executeApi<T>()` | `core/base_response/api_execute.dart` | Wraps any async call into `Result<T>`, catches DioException |
| `ApiConsumer` | `core/api/api_consumer.dart` | Abstract Dio wrapper: `.get/.post/.put/.patch/.delete` |
| `EndPoints` | `core/api/end_points.dart` | All API path string constants |
| `NoParams` | `core/uses_cases/params.dart` | Empty params for use cases that need no input |
| `PaginationParams` | `core/uses_cases/params.dart` | `page`, `limit`, `filterList` getter, `copyWith`, `toJson` |
| `ModeEnum` | `shared/model/mode_enum.dart` | `shopping`, `discount`, `both` — for category/store modes |
| `RoleEnum` | `shared/model/roles.dart` | `user`, `merchant`, `driver` — for user roles |
| `AppRouter` | `core/routing/routes.dart` | All route path string constants |
| `AppStrings` | `core/utils/constants/app_strings.dart` | All user-visible strings + helpers |
| `AppConstants` | `core/utils/constants/app_constants.dart` | `phoneCode`, `accessToken`, `roleName`, etc. |
| `AppColors` | `core/utils/theme/app_colors.dart` | All color constants |
| `AppIcons` | `core/utils/theme/app_icons.dart` | All SVG icon asset paths |
| `AppImages` | `core/utils/theme/app_images.dart` | All PNG/SVG image asset paths |
| `AppFontStyle` | `core/utils/theme/app_font_styles.dart` | `regularXX(context)` — responsive text styles |
| `CustomAppFontStyle` | `core/utils/theme/custom_app_font_stlyles.dart` | `static const regularXX` — no context needed |
| `context.setWidth(n)` | `core/extensions/size_helper.dart` | Scale `n` to screen width ratio |
| `context.setHeight(n)` | `core/extensions/size_helper.dart` | Scale `n` to screen height ratio |
| `context.setMinSize(n)` | `core/extensions/size_helper.dart` | `min(width_scale, height_scale) * n` — for radii, icons |
| `context.setSp(n)` | `core/extensions/size_helper.dart` | Scale font size |
| `CustomTextFormField` | `shared/widgets/custom_text_field.dart` | Full text field: header, hint, validators, prefix/suffix |
| `CustomPushButton` | `shared/widgets/custom_push_container_button.dart` | Primary button with `isLoading` spinner |
| `AppImage` | `shared/widgets/app_image.dart` | SVG + PNG + network (CachedNetworkImage) image |
| `CustomToast` | `shared/widgets/custom_toast.dart` | Top toast — `.showBottomToast()` — success/error/warning |
| `AuthHeader` | `app_versions/shared/auth/presentation/widgets/auth_header.dart` | Yellow header with logo + optional back button |
| `ImagePickerHelper` | `core/helpers/image_picker_helper.dart` | Bottom sheet for camera/gallery image picking |
| `AppSharedPreferences` | `core/storage/cache_helper.dart` | Static SharedPreferences wrapper |
| `saveUserAuth(user)` | `app_versions/shared/auth/data/repositories/login_repo_impl.dart` | Saves token, refreshToken, userId to SharedPrefs |

---


## BaseState<T> — State Transitions

```dart
const BaseState.initial()    // before any action
const BaseState.loading()    // API call in progress
BaseState.success(data)      // API succeeded — data: T?
BaseState.error(exception)   // API failed — exception: Exception?

// Reading state
state.registrationState.isLoading   // bool
state.registrationState.isSuccess   // bool
state.registrationState.isError     // bool
state.registrationState.data        // T?
state.registrationState.exception   // Exception?

// In BlocBuilder — render via .when():
state.registrationState.when(
  initial: () => const SizedBox.shrink(),
  loading: () => const CircularProgressIndicator(),
  success: (data) => SuccessWidget(data: data!),
  error: (e) => Text(e.toString()),
)
```

---

## Result<T> — Repository + UseCase

```dart
// In cubit after calling use case:
result.when(
  success: (data) {
    emit(state.copyWith(xState: BaseState.success(data)));
    emitEvent(const SuccessUiEvent());
  },
  error: (exception) {
    emit(state.copyWith(xState: BaseState.error(exception ?? Exception('error'))));
    emitEvent(FailureUiEvent(exception?.toString() ?? 'error'));
  },
);
```
