# 12 — Feature Plan Template

Copy this plan for every new feature. Fill in the blanks, work top-to-bottom,
validate each layer before starting the next.

---

## Feature Info

```
Feature name   : _______________________________________________
Role           : customer / merchant / driver / shared
Path           : lib/app_versions/{role}/{feature}/
API endpoint   : _______________________________________________
Method         : GET / POST / PUT / PATCH / DELETE
Has image upload: Yes / No
Is wizard (multi-step): Yes / No  (steps: ___)
Returns entity : _______________________________________________
```

---

## Step 0 — Prep (30 min)

**Goal**: All constants and folder ready before writing logic.

```
Action items:
[ ] Create folder structure (api/, data/, domain/, presentation/)
[ ] Add endpoint to lib/core/api/end_points.dart
      static String {feature}Endpoint = '{path}';
[ ] Add route constant to lib/core/routing/routes.dart
      static const String {feature} = '/{feature}';
[ ] Search AppStrings for existing keys to reuse
[ ] Add new feature-specific strings to AppStrings under
      // ── {Feature name} ────────────────────
[ ] Identify what the API returns → define UserModel / EntityModel
[ ] Check for existing enums (lib/shared/model/, lib/core/enums/)
      - NEVER create string fields for enum-like data
      - Use ModeEnum, RoleEnum, OrderStatus, etc.
```

Read: `07-strings-and-tokens.md`, `08-di-and-routing.md`, `13-global-shared-feature.md`

---

## Step 1 — Params Model (20 min)

**File**: `data/models/{feature}_params.dart`
**Goal**: Single immutable class that holds all input data.

```
[ ] List all fields needed for the API call:
      Field name        Type          Default value
      ___________       _______       _____________
      ___________       _______       _____________

[ ] Write const constructor with all defaults
[ ] Write copyWith covering every field
[ ] Write toJson() OR toFormData() (if images):
      - Add AppConstants.phoneCode to phone fields
      - Use MultipartFile.fromFile for File? fields
[ ] Run: flutter analyze data/models/  → No issues
```

Read: `03-data-layer.md` → Params Model section

---

## Step 1b — Entity & Response Model (30 min, if GET/response exists)

**Files**:
- `domain/entities/{feature}_entity.dart` — standalone class, its own imports, NO `part of`
- `data/models/{feature}_model.dart` — standalone DTO, NO `part`, NO `extends`

```
[ ] Entity file: standalone — NO `part of`, declares its own imports
[ ] Entity file: has NO knowledge of the model
[ ] Model file: standalone DTO — NO `part`, does NOT extend the entity
[ ] Model file: imports the entity so toEntity() can build it

[ ] Entity class:
      □ All fields final
      □ Use enums for enum-like fields (ModeEnum, RoleEnum, OrderStatus)
      □ empty() factory — all defaults (empty string, 0, false, [], DateTime.now(), enum default)
      □ fake() factory — realistic sample data for Skeletonizer

[ ] Model (DTO) class — plain class, NO inheritance:
      □ class XModel { ... }   // never `extends XEntity`
      □ Fields mirror the API/JSON (raw strings for enum-like fields)
      □ fromJson(): 
          - handle _id/id
          - null defaults (?? '')
          - safe num cast
          - safe DateTime
      □ toJson(): fields for API request
      □ toEntity(): maps DTO → entity; string → enum conversion happens HERE
      □ fromEntity(XEntity entity): ONLY if a write path needs a full entity → DTO

[ ] Nested entities/models follow same pattern in same files

[ ] Run: flutter analyze domain/entities/ data/models/  → No issues
```

Read: `03-data-layer.md` → Entity and Response Model sections

---

## Step 2 — Domain Layer (20 min)

**Files**: `domain/repositories/{feature}_repo.dart`,
           `domain/use_cases/{action}_use_case.dart`

```
[ ] Repository contract:
      abstract class {Feature}Repo {
        Future<Result<ReturnType>> {action}({required Params params});
      }
[ ] Use case (one per action):
      class {Action}UseCase extends BaseUseCase<ReturnType, Params>
[ ] const constructor on use case
[ ] No Dio / ApiConsumer imports in domain
[ ] Run: flutter analyze domain/  → No issues
```

Read: `04-domain-layer.md`

---

## Step 3 — Data & API Layers (40 min)

**Files**:
- `data/data_sources/{feature}_remote_data_source.dart` (abstract contract)
- `api/data_sources/{feature}_remote_data_source_impl.dart` (executeApi + ApiConsumer)
- `data/repositories/{feature}_repo_impl.dart` (delegation)

```
[ ] DataSource abstract contract (returns Result<T>)
[ ] RemoteDataSourceImpl (in api/data_sources/):
      - const constructor
      - uses _apiConsumer.post/get/put/delete directly (NO api_client class)
      - wraps call in executeApi<T>()
      - NO try/catch
[ ] RepoImpl:
      - non-const constructor
      - delegates to data source
      - NO try/catch
      - If global shared feature: add .makeDummyData(() => fixtures)
[ ] Run: flutter analyze data/ api/  → No issues
```

Read: `02-api-layer.md`, `03-data-layer.md`, `13-global-shared-feature.md`

---

## Step 4 — Cubit Layer (45 min)

**Files**: cubit + state + events + ui_events (all linked via `part of`)

```
[ ] State:
      - extends Equatable
      - BaseState<T> for every async field
      - plain bool/int for UI flags
      - const constructor with defaults
      - copyWith covers every field
      - all fields in props

[ ] Events (sealed):
      List of intents:
        □ {Action1}Event     params: ___________________
        □ {Action2}Event     params: ___________________
        □ GoBackEvent
        □ ToggleVisibilityEvent (if password)

[ ] UiEvents (sealed):
      List of side effects:
        □ {Action}SuccessUiEvent
        □ {Action}FailureUiEvent(String message)
        □ NavigateNextPageUiEvent (if wizard)
        □ NavigatePrevPageUiEvent (if wizard)

[ ] Cubit:
      - extends BaseCubit<State, UiEvent>
      - doIntent switch covers ALL events
      - loading guard on every async handler
      - emitEvent for side effects
      - emit(state.copyWith) for state changes
      - mutable params accumulator (if wizard)

[ ] Run: flutter analyze presentation/cubit/  → No issues
```

Read: `05-cubit-layer.md`

---

## Step 5 — Presentation Layer (60 min)

### Widgets (one file per widget class)

```
[ ] Plan widget breakdown:
      Widget name                File name                    StatefulWidget?
      ___________________        ____________________         Yes / No
      ___________________        ____________________         Yes / No
      ___________________        ____________________         Yes / No

[ ] For each widget:
      □ One public class per file
      □ No Widget _buildX() methods
      □ No _PrivateClass with 3+ params
      □ All strings → AppStrings.*
      □ All colors → AppColors.*
      □ All sizes → context.setWidth/setHeight/setMinSize
      □ BlocBuilder has buildWhen
      □ dispose() called on all controllers

[ ] Grep check (0 results expected):
      □ 'Widget _build'
      □ 'EdgeInsets.only(right'
      □ '[أ-ي] (Arabic in quotes)
```

### Page

```
[ ] StatefulWidget (wizard) or StatelessWidget (simple screen)?
[ ] initState: create cubit, subscribe eventStream
[ ] _handleUiEvent: handles ALL UiEvent cases
[ ] dispose: cancel sub → close cubit → dispose controllers
[ ] BlocProvider.value wraps scaffold
[ ] Pass cubit explicitly to children

[ ] Run: flutter analyze presentation/  → No issues
```

Read: `06-presentation-layer.md`

---

## Step 6 — DI & Routing (20 min)

```
[ ] dependency_injection.dart:
      □ Add imports for remote_data_source_impl, data_source contract, repo
      □ Register order: data_source_impl → data_source_contract → repo → use_cases
      □ For role features: registerLazySingleton
      □ For global shared features: cubit as registerSingleton

[ ] app_router.dart:
      □ Add import for page
      □ Add GoRoute with adaptivePage
      □ Validate extra argument if required

[ ] Run: flutter analyze lib/core/routing/ lib/core/dependency_injection/
         → No issues
```

Read: `08-di-and-routing.md`, `13-global-shared-feature.md`

---

## Step 7 — Final Validation (15 min)

```bash
flutter analyze lib/app_versions/{role}/{feature}
```

All 6 post-feature checks from `11-validation-guide.md`:
```
[ ] No issues found
[ ] No hardcoded Arabic (grep)
[ ] No hardcoded colors (grep)
[ ] No Widget _buildX methods
[ ] All controllers disposed
[ ] Loading guard present
```

---

## Time Estimate

| Step | Time |
|------|------|
| 0 — Prep | 30 min |
| 1 — Params | 20 min |
| 1b — Entity + Model | 30 min |
| 2 — Domain | 20 min |
| 3 — Data + API | 40 min |
| 4 — Cubit | 45 min |
| 5 — Presentation | 60 min |
| 6 — DI + Routing | 20 min |
| 7 — Validation | 15 min |
| **Total** | **~4.5 hours** |

Complex wizard features (3+ steps, image upload) add ~1 hour to Step 5.
Simple GET screens (list only) reduce Step 3 and Step 5 by ~30 min each.
POST-only features (sign-up, create) skip Step 1b entirely (no response model needed).
