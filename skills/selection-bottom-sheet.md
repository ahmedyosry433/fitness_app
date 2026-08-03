---
name: selection-bottom-sheet
description: >
  Flutter reusable selection bottom sheet pattern using `showSelectionBottomSheet<T>()`
  and `SelectionItem`. Use this skill when you need a bottom sheet list picker for
  dropdowns like governorates, cities, areas, or any selection list. Works with
  `GovernorateDropdownField` and `AreaDropdownField` widgets in `lib/core/widgets/global/`.
  Trigger on phrases like "bottom sheet اختيار", "selection bottom sheet", 
  "dropdown bottom sheet", "choose from list sheet".
---

# Selection Bottom Sheet Pattern

## Core Concept

A generic, reusable bottom sheet for picking from a list of items, used by `GovernorateDropdownField` and `AreaDropdownField` in `lib/core/widgets/global/`.

## Files

| File | Purpose |
|------|---------|
| `lib/core/widgets/global/selection_bottom_sheet.dart` | Generic `SelectionItem` class & `showSelectionBottomSheet<T>()` function |
| `lib/core/widgets/global/governorate_dropdown_field.dart` | Governorate picker using the bottom sheet |
| `lib/core/widgets/global/area_dropdown_field.dart` | Area picker using the bottom sheet |

## 1. SelectionItem

```dart
class SelectionItem {
  final String id;
  final String label;
  const SelectionItem({required this.id, required this.label});
}
```

## 2. showSelectionBottomSheet<T>()

```dart
Future<T?> showSelectionBottomSheet<T extends SelectionItem>({
  required BuildContext context,
  required String title,
  required List<T> items,
  String? selectedId,
  String? emptyMessage,
});
```

- Opens `showModalBottomSheet` + `DraggableScrollableSheet`
- Theme uses `BottomSheetThemeData` with `showDragHandle: true` (set in `app_theme.dart`)
- Header rendered via `_buildHeader()` using `Theme.of(context).textTheme.titleMedium`
- Selected item highlighted with `AppColors.green0C` checkmark
- Empty state uses `Theme.of(context).disabledColor`
- All `build()` methods kept under 30 lines by extracting into private methods
- Colors use `Theme.of(context)` or `AppColors` constants only

## 3. Field Widget Pattern

Both `GovernorateDropdownField` and `AreaDropdownField` follow the same pattern:

```dart
TextFormField(
  controller: _controller,
  readOnly: true,
  decoration: InputDecoration(
    labelText: widget.labelText,    // from localization
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    suffixIcon: Icon(Icons.keyboard_arrow_down),
  ),
  onTap: _showBottomSheet,
  validator: (v) => (v == null || v.isEmpty) ? validatorText : null,
)
```

On tap → converts entity list to `SelectionItem` list → calls `showSelectionBottomSheet()` → on result, maps back to entity and calls `onChanged`.

## 4. Rules Applied

- `build()` never exceeds 30 lines (extract into `_buildXxx()` methods)
- All colors use `Theme.of(context)` (e.g., `disabledColor`, `textTheme`) or `AppColors` (e.g., `AppColors.green0C`)
- No hardcoded display strings — use `widget.labelText` / `widget.hintText` with empty fallbacks
- Hardcoded fallback strings like `'No items'` are only used in generic utility widgets, never in screens

## 5. Usage in Screens

```dart
GovernorateDropdownField(
  selectedGovernorate: _selectedCity,
  onChanged: (city) { /* handle */ },
  labelText: context.cityLabel,
  validatorText: context.selectCity,
),

AreaDropdownField(
  selectedGovernorateId: _selectedCity?.id,
  selectedArea: _selectedArea,
  onChanged: onAreaChanged,
  labelText: context.areaLabel,
  validatorText: context.selectArea,
)
```

## Key Points

- `EgyptLocationLoader` caches loaded data, so parallel calls are safe
- `AreaDropdownField` auto-disables when no governorate is selected
- Both fields respect `mounted` checks to avoid calling `setState` after disposal
- Screens extract `build()` form sections into separate private widget classes (e.g., `_MapPreview`, `_AddressTextField`, `_CityAreaRow`, `_SubmitButton`)
