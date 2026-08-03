# 05 — Cubit Layer (4 files)

All 4 files are linked via `part of`. The cubit file owns the `part` declarations.

---

## File 1: State (`{feature}_state.dart`)

```dart
part of '{feature}_cubit.dart';

class MerchantSignUpState extends Equatable {
  // Async data → BaseState<T>
  final BaseState<UserModel> registrationState;

  // Pure UI flags → plain typed fields
  final bool isPasswordHidden;
  final int currentPage;
  final bool imagePicked;   // toggled (true/false flip) to force BlocBuilder rebuild

  const MerchantSignUpState({
    this.registrationState = const BaseState.initial(),
    this.isPasswordHidden = true,
    this.currentPage = 0,
    this.imagePicked = false,
  });

  MerchantSignUpState copyWith({
    BaseState<UserModel>? registrationState,
    bool? isPasswordHidden,
    int? currentPage,
    bool? imagePicked,
  }) => MerchantSignUpState(
    registrationState: registrationState ?? this.registrationState,
    isPasswordHidden: isPasswordHidden ?? this.isPasswordHidden,
    currentPage: currentPage ?? this.currentPage,
    imagePicked: imagePicked ?? this.imagePicked,
  );

  @override
  List<Object?> get props =>
      [registrationState, isPasswordHidden, currentPage, imagePicked];
}
```

**Rules:**
- One state class — never multiple sealed subclasses.
- Every async piece of data gets its own `BaseState<T>` field.
- Every field in `props`.
- `const` default constructor with sensible defaults.
- Import: `package:atoz/core/base_state/base_state.dart`.
- Import: `package:equatable/equatable.dart`.

---

## File 2: Events (`{feature}_events.dart`)

```dart
part of '{feature}_cubit.dart';

sealed class MerchantSignUpEvent {
  const MerchantSignUpEvent();
}

// Named params for multi-field events
class SaveStep1Event extends MerchantSignUpEvent {
  final String fullName;
  final String username;
  final String phone;
  final String password;
  const SaveStep1Event({
    required this.fullName,
    required this.username,
    required this.phone,
    required this.password,
  });
}

// Positional for single-value events
class SubmitRegistrationEvent extends MerchantSignUpEvent {
  final int discountPercentage;
  const SubmitRegistrationEvent(this.discountPercentage);
}

// No-data events
class GoBackPageEvent extends MerchantSignUpEvent {
  const GoBackPageEvent();
}

class TogglePasswordVisibilityEvent extends MerchantSignUpEvent {
  const TogglePasswordVisibilityEvent();
}
```

**Rules:**
- All events in one file.
- `sealed` class — enables exhaustive switch in `doIntent`.
- `const` constructors.
- File lives at `part` level — no imports needed (inherits from cubit).

---

## File 3: UI Events (`{feature}_ui_events.dart`)

```dart
part of '{feature}_cubit.dart';

// One-shot side effects: navigation, toasts, dialogs.
// These are NOT stored in state — they fire once and are gone.
sealed class MerchantSignUpUiEvent {
  const MerchantSignUpUiEvent();
}

class NavigateNextPageUiEvent extends MerchantSignUpUiEvent {
  const NavigateNextPageUiEvent();
}

class NavigatePrevPageUiEvent extends MerchantSignUpUiEvent {
  const NavigatePrevPageUiEvent();
}

class RegistrationSuccessUiEvent extends MerchantSignUpUiEvent {
  const RegistrationSuccessUiEvent();
}

// Carries data when needed
class RegistrationFailureUiEvent extends MerchantSignUpUiEvent {
  final String message;
  const RegistrationFailureUiEvent(this.message);
}
```

**Rules:**
- Navigation events, toast triggers, dialog requests go here.
- Never route/toast from cubit directly — always via `emitEvent`.

---

## File 4: Cubit (`{feature}_cubit.dart`)

```dart
import 'dart:io';
import 'package:atoz/core/base_state/base_cubit.dart';
import 'package:atoz/core/base_state/base_state.dart';
import 'package:equatable/equatable.dart';
// + use case + params imports

part '{feature}_state.dart';
part '{feature}_events.dart';
part '{feature}_ui_events.dart';

class MerchantSignUpCubit
    extends BaseCubit<MerchantSignUpState, MerchantSignUpUiEvent> {

  final RegisterMerchantUseCase _registerMerchantUseCase;

  // Mutable accumulator for wizard data — not in state because UI
  // doesn't render params fields directly.
  MerchantSignUpParams params = const MerchantSignUpParams();

  MerchantSignUpCubit({required RegisterMerchantUseCase registerMerchantUseCase})
      : _registerMerchantUseCase = registerMerchantUseCase,
        super(const MerchantSignUpState());

  // ── SINGLE entry point ────────────────────────────────────────────────────
  Future<void> doIntent(MerchantSignUpEvent event) async => switch (event) {
    SaveStep1Event()                => _saveStep1(event),
    SaveStep2Event()                => _saveStep2(event),
    PickStoreLogoEvent()            => _pickStoreLogo(event),
    PickStoreCoverEvent()           => _pickStoreCover(event),
    UpdateDiscountEvent()           => _updateDiscount(event),
    GoBackPageEvent()               => _goBack(),
    TogglePasswordVisibilityEvent() => _toggleVisibility(),
    SubmitRegistrationEvent()       => _submit(event),
  };

  // ── Step handlers ─────────────────────────────────────────────────────────
  void _saveStep1(SaveStep1Event e) {
    params = params.copyWith(
      fullName: e.fullName,
      username: e.username,
      phone: e.phone,
      password: e.password,
    );
    emit(state.copyWith(currentPage: 1));
    emitEvent(const NavigateNextPageUiEvent());
  }

  void _pickStoreLogo(PickStoreLogoEvent e) {
    params = params.copyWith(storeLogo: e.file);
    emit(state.copyWith(imagePicked: !state.imagePicked)); // toggle forces rebuild
  }

  void _goBack() {
    final prev = (state.currentPage - 1).clamp(0, 2);
    emit(state.copyWith(currentPage: prev));
    emitEvent(const NavigatePrevPageUiEvent());
  }

  void _toggleVisibility() {
    emit(state.copyWith(isPasswordHidden: !state.isPasswordHidden));
  }

  // ── Async submit ──────────────────────────────────────────────────────────
  Future<void> _submit(SubmitRegistrationEvent e) async {
    if (state.registrationState.isLoading) return; // ← loading guard

    params = params.copyWith(discountPercentage: e.discountPercentage);
    emit(state.copyWith(registrationState: const BaseState.loading()));

    final result = await _registerMerchantUseCase(params);

    result.when(
      success: (user) {
        emit(state.copyWith(registrationState: BaseState.success(user)));
        emitEvent(const RegistrationSuccessUiEvent());
      },
      error: (exception) {
        emit(state.copyWith(
          registrationState: BaseState.error(exception ?? Exception('خطأ')),
        ));
        emitEvent(RegistrationFailureUiEvent(exception?.toString() ?? 'خطأ'));
      },
    );
  }
}
```

**Key rules:**
- `doIntent` is the **only** public method the UI calls (besides reading `cubit.params`).
- `emitEvent(...)` for side effects — `emit(state.copyWith(...))` for state.
- Loading guard: `if (state.xState.isLoading) return;`.
- `BaseCubit` imports: `package:atoz/core/base_state/base_cubit.dart`.

---

## Loading data once — don't refetch on every navigation

Screens create a fresh cubit in `initState` and dispatch a load intent. Without care,
every navigation (open → back → open) fires another **server request** for data that
hasn't changed. Avoid it with two cooperating pieces:

1. **Repo-level cache** (see `03-data-layer.md` → "Repository caching") — the real
   dedup happens here because the repo is a lazy singleton that outlives the cubit.
2. **Cubit skeleton guard** — only show the loading skeleton on the *first* load; on
   later loads refresh silently so there's no flicker, and expose a `forceRefresh`
   path for pull-to-refresh.

```dart
// GET use case carries forceRefresh (bool param). See 04-domain-layer.md.
Future<void> _loadProfile(bool forceRefresh) async {
  if (state.profileState.isLoading) return;              // re-entrancy guard

  // Only show the skeleton the first time. Later loads hit the repo cache
  // (no server request) and update the state silently — no skeleton flash.
  if (!state.profileState.isSuccess) {
    emit(state.copyWith(profileState: const BaseState.loading()));
  }

  final result = await _getProfileUseCase(forceRefresh);
  result.when(
    success: (data) => emit(state.copyWith(
      profileState: BaseState.success(data ?? Entity.empty()),
    )),
    error: (e) => emit(state.copyWith(
      profileState: BaseState.error(e ?? Exception(AppStrings.errorMassage)),
    )),
  );
}
```

```dart
// Event carries the flag; default is a cheap cache read.
class LoadProfileEvent extends ProfileEvent {
  final bool forceRefresh;
  const LoadProfileEvent({this.forceRefresh = false});
}
```

**In the page:**
- `initState` → `doIntent(const LoadProfileEvent())` (cache read; server only on first ever load).
- Returning from a child screen → `doIntent(const LoadProfileEvent())` again (cache read, silent).
- `RefreshIndicator.onRefresh` → `doIntent(const LoadProfileEvent(forceRefresh: true))` (real server hit).

**Rules:**
- NEVER unconditionally `emit(BaseState.loading())` on a reload — gate it behind
  `if (!state.xState.isSuccess)` so cached data doesn't flash a skeleton.
- Do NOT add a `if (isSuccess) return;` short-circuit — that keeps stale data after an
  edit elsewhere. Always call the use case; let the repo decide cache vs network.
- Only `forceRefresh: true` (pull-to-refresh / explicit retry) may bypass the cache.

