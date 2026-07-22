import 'package:equatable/equatable.dart';

class ExerciseEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final String thumbnailUrl;
  final String time;
  final String calories;
  final String level;

  const ExerciseEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.time,
    required this.calories,
    required this.level,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        videoUrl,
        thumbnailUrl,
        time,
        calories,
        level,
      ];
}
