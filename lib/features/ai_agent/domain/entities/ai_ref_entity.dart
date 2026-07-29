import 'package:equatable/equatable.dart';

enum AiRefType {
  exercise,
  meal;

  static AiRefType? tryParse(String? raw) {
    return switch (raw) {
      'exercise' => AiRefType.exercise,
      'meal' => AiRefType.meal,
      _ => null,
    };
  }
}

/// A grounded reference to a real row in the local knowledge database.
///
/// Only ids that were actually returned by a local query become refs, which is
/// what stops the model from inventing exercise/meal ids.
class AiRefEntity extends Equatable {
  const AiRefEntity({
    required this.type,
    required this.id,
    required this.name,
  });

  final AiRefType type;
  final String id;
  final String name;

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'id': id,
    'name': name,
  };

  static AiRefEntity? tryFromJson(Map<String, dynamic> json) {
    final type = AiRefType.tryParse(json['type'] as String?);
    final id = json['id'] as String?;
    if (type == null || id == null || id.isEmpty) return null;
    return AiRefEntity(
      type: type,
      id: id,
      name: (json['name'] as String?)?.trim().isNotEmpty == true
          ? json['name'] as String
          : id,
    );
  }

  @override
  List<Object?> get props => [type, id, name];
}
