# 06 — Presentation Layer (Page + Widgets)

---

## Page (`presentation/pages/{feature}_page.dart`)

```dart
class MerchantSignUpPage extends StatefulWidget {
  const MerchantSignUpPage({super.key});

  @override
  State<MerchantSignUpPage> createState() => _MerchantSignUpPageState();
}

class _MerchantSignUpPageState extends State<MerchantSignUpPage> {
  final _pageController = PageController();
  late final MerchantSignUpCubit _cubit;
  StreamSubscription<MerchantSignUpUiEvent>? _eventSub;

  @override
  void initState() {
    super.initState();
    // Create cubit here — use getIt for the use case dependency
    _cubit = MerchantSignUpCubit(
      registerMerchantUseCase: RegisterMerchantUseCase(
        getIt.get<MerchantSignUpRepo>(),
      ),
    );
    // Subscribe to one-shot events
    _eventSub = _cubit.eventStream.listen(_handleUiEvent);
  }

  void _handleUiEvent(MerchantSignUpUiEvent event) {
    switch (event) {
      case NavigateNextPageUiEvent():
        _pageController.nextPage(
            duration: Durations.medium4, curve: Curves.easeInOut);
      case NavigatePrevPageUiEvent():
        _pageController.previousPage(
            duration: Durations.medium4, curve: Curves.easeInOut);
      case RegistrationSuccessUiEvent():
        CustomToast(context: context,
            header: AppStrings.merchantRegistrationSuccess).showBottomToast();
        context.go(AppRouter.shoppingOptions);
      case RegistrationFailureUiEvent():
        CustomToast(context: context, header: event.message,
            type: ToastificationType.error).showBottomToast();
    }
  }

  @override
  void dispose() {
    _eventSub?.cancel();     // ← cancel subscription first
    _cubit.close();           // ← close cubit
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: AppColors.primary,
          statusBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: AppColors.white,
          body: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              MerchantSignUpStep1(cubit: _cubit),
              MerchantSignUpStep2(cubit: _cubit),
              MerchantSignUpStep3(cubit: _cubit),
            ],
          ),
        ),
      ),
    );
  }
}
```

**Rules:**
- Create cubit in `initState`.
- Subscribe to `eventStream` in `initState`.
- Handle ALL `UiEvent` cases in `_handleUiEvent` — navigation, toasts, dialogs.
- `_eventSub?.cancel()` + `_cubit.close()` in `dispose` (in that order).
- `BlocProvider.value(value: _cubit)` wraps scaffold.
- Pass cubit explicitly to child widgets: `Step1Widget(cubit: _cubit)`.
- For simple single-screen features (no wizard) use `StatelessWidget`:
  ```dart
  BlocProvider(create: (_) => getIt<XCubit>()..doIntent(LoadEvent()), child: ...)
  ```

---

## Widget Rules

### Non-negotiable

| Rule | Right ✅ | Wrong ❌ |
|------|----------|----------|
| One file = one class | `step1_fields_widget.dart` → `Step1FieldsWidget` | Multiple classes in one file |
| No method widgets | `Step1FieldsWidget(...)` | `Widget _buildFields() {}` |
| No private classes with params | Only `_MaxValueFormatter` (pure formatter ~10 lines) ok | `_Step1Fields` with 5+ params |
| Public naming | `Step1FieldsWidget` | `_Step1Fields` |
| RTL always | `EdgeInsetsDirectional`, `CrossAxisAlignment.end` | `EdgeInsets.only(right:...)` |
| Explicit cubit | `BlocBuilder(bloc: cubit, ...)` | relying on `context.read` in StatelessWidget |
| buildWhen always | `buildWhen: (prev, curr) => prev.x != curr.x` | `BlocBuilder` without `buildWhen` |

---

## StatefulWidget (form steps)

Use when you need `TextEditingController`, `FocusNode`, or `initState` to read cubit data.

```dart
class MerchantSignUpStep3 extends StatefulWidget {
  const MerchantSignUpStep3({super.key, required this.cubit});
  final MerchantSignUpCubit cubit;

  @override
  State<MerchantSignUpStep3> createState() => _MerchantSignUpStep3State();
}

class _MerchantSignUpStep3State extends State<MerchantSignUpStep3> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _discountCtrl;

  @override
  void initState() {
    super.initState();
    // Read initial value from cubit
    _discountCtrl = TextEditingController(
      text: widget.cubit.params.discountPercentage.toString(),
    );
  }

  @override
  void dispose() {
    _discountCtrl.dispose();   // dispose EVERY controller
    super.dispose();
  }

  void _onSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    widget.cubit.doIntent(
      SubmitRegistrationEvent(int.tryParse(_discountCtrl.text.trim()) ?? 0),
    );
  }
  // ...
}
```

---

## StatelessWidget (field groups, cards, action bars)

```dart
class Step1FieldsWidget extends StatelessWidget {
  const Step1FieldsWidget({
    super.key,
    required this.nameCtrl,
    required this.cubit,
  });

  final TextEditingController nameCtrl;
  final MerchantSignUpCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CustomTextFormField(
        controller: nameCtrl,
        headerText: AppStrings.fullName,
        hintText: AppStrings.inputFormField(AppStrings.fullName),
        validator: (v) => v == null || v.trim().isEmpty
            ? AppStrings.validate(AppStrings.fullName) : null,
      ),
      // For reactive fields (visibility toggle etc.):
      BlocBuilder<MerchantSignUpCubit, MerchantSignUpState>(
        bloc: cubit,                                          // explicit bloc
        buildWhen: (p, c) => p.isPasswordHidden != c.isPasswordHidden,
        builder: (context, state) => CustomTextFormField(
          isObeseureText: state.isPasswordHidden,
          suffixWidget: TextButton(
            onPressed: () =>
                cubit.doIntent(const TogglePasswordVisibilityEvent()),
            child: Text(
              state.isPasswordHidden ? AppStrings.show : AppStrings.hide,
            ),
          ),
        ),
      ),
    ]);
  }
}
```
