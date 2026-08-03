---
name: category-dropdown-field
description: >
  Reusable `CategoryDropdownField` widget for picking a category via an animated bottom sheet.
  Backed by `CategoriesCubit` (PaginationState). Supports mode filtering (`ModeEnum`),
  infinite scroll load-more, selected highlight, and a `TextFormField` validator.
  Used in merchant sign-up Step 2. Located at
  `lib/core/shared/global/categories/presentation/widgets/category_dropdown_field.dart`.
  Trigger on: "category dropdown", "category picker", "category bottom sheet", "اختيار القسم",
  "CategoryDropdownField", "sign up category", "merchant category".
---

# CategoryDropdownField

## Location

`lib/core/shared/global/categories/presentation/widgets/category_dropdown_field.dart`

## Widget Signature

```dart
CategoryDropdownField({
  required TextEditingController controller,   // shows selected category name
  required CategoriesCubit categoriesCubit,    // injected from parent (getIt)
  ModeEnum? filterByMode,                      // null = all modes
  Color? fillColor,
  String? Function(String?)? validator,
  void Function(CategoryEntity)? onSelected,  // called with full entity on tap
})
```

## Behaviour

- **Auto-loads** categories on `initState` if `categoriesState.isInitial`
- **Infinite scroll** — triggers `LoadMoreCategoriesEvent` when near bottom
- **Bottom sheet** — `showModalBottomSheet` with `AppBottomSheet` wrapper
- **Loading** → spinner suffix on field; sheet shows `LoadingIndicator`
- **Error** → error icon + message in sheet
- **Empty** → Arabic empty-state text
- **Selected** → blue check icon, primary text colour, field text = `category.name`
- **Refresh** → pull-to-refresh reloads with same `filterByMode`

## Usage in Merchant Sign-Up Step 2

### 1. Parent widget creates `CategoriesCubit` from DI

```dart
// merchant_sign_up_step2.dart — StatefulWidget
late final CategoriesCubit _categoriesCubit;
String? _categoryId;   // ← primitive, not CategoryEntity

@override
void initState() {
  super.initState();
  _categoriesCubit = getIt<CategoriesCubit>(); // ← injected, not created
}

@override
void dispose() {
  _activityCtrl.dispose();
  _categoryCtrl.dispose();
  // CategoriesCubit is a lazySingleton — do NOT close it here
  super.dispose();
}
```

### 2. Pass cubit + extract primitive in `onSelected`

```dart
CategoryDropdownField(
  controller: _categoryCtrl,
  categoriesCubit: _categoriesCubit,
  filterByMode: ModeEnum.shopping,
  onSelected: (category) {
    _categoryId = category.id;  // ← extract primitive here, store locally
  },
  validator: (v) => v == null || v.trim().isEmpty
      ? AppStrings.validate(AppStrings.category)
      : null,
),
```

### 3. Pass primitive to cubit event on "Next"

```dart
void _onNext() {
  if (!(_formKey.currentState?.validate() ?? false)) return;
  widget.cubit.doIntent(
    SaveStep2Event(
      activityType: _activityCtrl.text.trim(),
      categoryId: _categoryId,   // ← String? primitive, never CategoryEntity
      storeName: _storeNameCtrl.text.trim(),
      storeAddress: _address,
    ),
  );
}
```

### 4. Event → cubit → params (all primitives)

```dart
// merchant_sign_up_events.dart
class SaveStep2Event extends MerchantSignUpEvent {
  final String? categoryId;  // ← String?, not CategoryEntity
  // ...
}

// merchant_sign_up_cubit.dart
void _saveStep2(SaveStep2Event e) {
  params = params.copyWith(categoryId: e.categoryId); // ← stays String?
  emitEvent(const NavigateNextPageUiEvent());
}

// merchant_sign_up_params.dart
class MerchantSignUpParams {
  final String? categoryId;  // ← primitive in params
}

Future<FormData> toFormData() async {
  return FormData.fromMap({
    if (categoryId != null) 'categoryId': categoryId, // ← direct to API
  });
}
```

## Data Flow Diagram

```
CategoryDropdownField (widget)
  ↓ onSelected(CategoryEntity)        ← full entity only inside widget layer
MerchantSignUpStep2 (page)
  ↓ _categoryId = category.id         ← extract primitive at page boundary
SaveStep2Event(categoryId: String?)   ← primitive crosses layer boundary
  ↓
MerchantSignUpCubit
  ↓ params.copyWith(categoryId: ...)
MerchantSignUpParams.toFormData()
  ↓ 'categoryId': categoryId          ← primitive hits the API
```

## Key Rules

- `CategoryDropdownField.onSelected` gives you the full `CategoryEntity` — extract only `.id` at the page level.
- Never put `CategoryEntity` in `MerchantSignUpParams` or any event — see `14-clean-arch-di-guidelines.md`.
- `CategoriesCubit` should be registered as `registerLazySingleton` — do NOT close it in the step widget's `dispose()`.
- `filterByMode: ModeEnum.shopping` for merchant sign-up (shows only shopping-mode categories + `both`).

## Related

- `categories-feature.md` — full categories architecture
- `atoz-guide/14-clean-arch-di-guidelines.md` — why primitives, not entities, cross layer boundaries
- `lib/app_versions/merchant/sign_up/presentation/widgets/merchant_sign_up_step2.dart`
- `lib/app_versions/merchant/sign_up/presentation/widgets/step2_fields_widget.dart`

