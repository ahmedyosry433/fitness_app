---
name: mode-enum
description: >
  Shared `ModeEnum` used across the app to represent the current shopping mode:
  `shopping` or `discount`. Use this skill when you need to switch between app modes,
  parse a mode value from a string (e.g., from API or local storage), or pass mode
  as a parameter. Located at `lib/shared/model/mode_enum.dart`.
  Trigger on phrases like "mode enum", "shopping mode", "discount mode",
  "ModeEnum", "وضع التسوق", "وضع الخصم", "app mode".
---

# ModeEnum

## Location

`lib/shared/model/mode_enum.dart`

## Core Concept

A simple Dart enum that represents the two app modes — `shopping` and `discount`.
Each case carries a `String value` for serialization/deserialization, and a
`fromString()` factory safely parses a raw string with a fallback to `shopping`.

## Full Implementation

```dart
enum ModeEnum {
  shopping('shopping'),
  discount('discount');

  final String value;
  const ModeEnum(this.value);

  static ModeEnum fromString(String value) {
    return ModeEnum.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ModeEnum.shopping,
    );
  }
}
```

## Values

| Case | `value` string | Description |
|------|---------------|-------------|
| `ModeEnum.shopping` | `"shopping"` | Default shopping mode |
| `ModeEnum.discount` | `"discount"` | Discount/offers mode |

## Usage Patterns

### Parsing from API / SharedPreferences
```dart
final mode = ModeEnum.fromString(json['mode'] as String);
```

### Serializing to string
```dart
final raw = mode.value; // "shopping" or "discount"
```

### Checking current mode
```dart
if (mode == ModeEnum.discount) {
  // show discount UI
}
```

### Switch expression
```dart
final label = switch (mode) {
  ModeEnum.shopping => context.shoppingLabel,
  ModeEnum.discount => context.discountLabel,
};
```

## Key Points

- Default fallback in `fromString()` is always `ModeEnum.shopping` — never throws.
- Use `.value` for any string serialization (API body, local storage key, analytics).
- Do **not** use `.name` (Dart built-in) for serialization — use `.value` to keep it explicit and refactor-safe.
- This enum lives in `lib/shared/model/` because it is used across multiple features/versions.

