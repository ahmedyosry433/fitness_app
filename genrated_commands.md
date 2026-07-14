# Helpful Commands

// Generate a new feature folder structure with Clean Architecture layers
// usage: dart lib/generate_feature.dart <feature_name>
// Example: dart lib/generate_feature.dart login

// Generate locale_keys.g.dart from JSON localization files
// flutter pub run easy_localization:generate -S assets/localization -O lib/core/languages -f keys -o locale_keys.g.dart

// Run build_runner to generate files for (injectable, retrofit, json_serializable, etc.)
// flutter pub run build_runner build --delete-conflicting-outputs