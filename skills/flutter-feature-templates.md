---
inclusion: manual
---
# Flutter Feature Templates (ATOZ new stack)

Copy-paste recipe for building any NEW feature in the ATOZ app (subscriptions,
representative, employee, merchant additions). The legacy shopping sections keep
using dartz Either + the old UseCase; do NOT touch them. Everything NEW uses the
Result + BaseState + BaseCubit stack described here.

## Golden rules
- One widget = one public reusable class. NEVER private `Widget _buildX()` methods.
- Pass whole entities/models into widgets (e.g. `PlanEntity plan`), never loose fields.
- No duplication of any class / widget / entity / model / use case / logic.
- Dummy data only for now. The backend is wired later, inside the data source only.
- Simple, readable names. No clever abstractions.
- Sizing via `context.setMinSize/ setWidth/ setHeight`. Colors from `AppColors`.
 Text styles from `AppFontStyle.regularXX(context)`. Never hardcode.
- DI is manual `getIt` (no @injectable).

## Core stack (already in lib/core)
- `base_response/result.dart`: `Result<T>` = `Success<T>{data}` | `Error<T>{exception}`.
 `.when(success, error)` and `.makeDummyData(...)` (debug returns dummy on error).
- `base_response/api_execute.dart`: `executeApi<T>(call)` wraps a data-source call
 into a Result and maps `DioException` to `ServerFailure`.
- `base_response/base_use_case.dart`: `BaseUseCase<T, Params>` returns `Result<T>`; `NoParams`.
- `base_state/base_state.dart`: `BaseState<T>` with `.initial/.loading/.success(data)/.error(ex)`,
 getters `isLoading/isSuccess/isError`, and `.when(initial, loading, success, error)`.
- `base_state/base_cubit.dart`: `BaseCubit<State, UiEvent>` adds `eventStream` + `emitEvent`
 for one-shot side effects (navigation, toast) kept out of state.
- `base_state/base_state_builder.dart`: `BaseStateBuilder<T>` renders loading/error/success.

## Layers per feature
feature/
 data/ data_sources/ (abstract + dummy impl), models/ (extend entity, fromJson/toEntity), repositories/ (impl)
 domain/ entities/, repositories/ (abstract), use_cases/ (extend BaseUseCase)
 presentation/ cubit/ (cubit + events + states), screens/, widgets/

## 1. Entity (domain/entities)
Plain class + `empty()` factory. No json here.

## 2. Model (data/models)
`class XModel extends XEntity` with `fromJson`, `toEntity()`, optional `toJson()`.

## 3. Data source (data/data_sources)
`abstract class BaseXRemoteDataSource { Future<XModel> getX(); }`
Dummy impl returns hardcoded models after `Future.delayed`. Swap to DioConsumer later.

## 4. Repository
Abstract in domain returns `Future<Result<XEntity>>`. Impl in data uses
`executeApi(() async => (await remote.getX()).toEntity())`.

## 5. Use case (domain/use_cases)
`class GetXUseCase extends BaseUseCase<XEntity, NoParams> { ... call => repo.getX(); }`

## 6. Cubit (presentation/cubit)
Extends `BaseCubit<XStates, XUiEvent>`. Events are a sealed class; `doIntent(event)`
switches over them. Each async piece is a `BaseState<T>` field inside `XStates`
(Equatable + copyWith). Use `emit(state.copyWith(...))` and `emitEvent(...)` for nav/toast.

## 7. States + Events (part files)
`XStates extends Equatable` holds `BaseState<...>` fields + copyWith.
`sealed class XUiEvent` for side effects. `sealed class XIntent` for inputs.

## 8. Screen
StatefulWidget only to grab cubit in initState + fire first intent. Body is
`BlocConsumer` listening to cubit + a `StreamBuilder`/listener on `eventStream`.
Delegate UI to reusable StatelessWidget children.

## 9. Widgets
Each a public StatelessWidget taking an entity. Reused across screens.

## 10. DI registration (lib/core/dependency_injection/dependency_injection.dart)
registerLazySingleton data source -> repo -> use cases; registerFactory the cubit.
Add route const in routes.dart + GoRoute in app_router.dart using `adaptivePage`.
