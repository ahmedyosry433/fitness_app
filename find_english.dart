import 'dart:convert';
import 'dart:io';

void main() {
  final file = File('assets/localization/ar-EG.json');
  final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  final englishRegExp = RegExp(r'[a-zA-Z]');
  
  for (final entry in json.entries) {
    final key = entry.key;
    final value = entry.value;
    if (key.startsWith('home_') || key.startsWith('exercise_') || key.startsWith('workout_')) {
      if (value is String && englishRegExp.hasMatch(value)) {
        if (!value.contains('{') && !value.contains('}')) { // ignore placeholders like {name}
          print('$key: $value');
        }
      }
    }
  }
}
