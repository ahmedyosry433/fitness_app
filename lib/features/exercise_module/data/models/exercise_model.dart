import 'package:fitness/features/exercise_module/domain/entities/exercise_entity.dart';


class ExerciseModel extends ExerciseEntity {
  const ExerciseModel({
    required super.id,
    required super.title,
    required super.description,
    required super.videoUrl,
    required super.thumbnailUrl,
    required super.time,
    required super.calories,
    required super.level,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    // Extract video URL
    final videoUrl = json['short_youtube_demonstration_link'] as String? ?? '';
    // Optional: generate a youtube thumbnail if possible
    String thumbnailUrl = '';
    if (videoUrl.contains('youtu.be/')) {
      final videoId = videoUrl.split('youtu.be/').last.split('?').first;
      thumbnailUrl = 'https://img.youtube.com/vi/$videoId/0.jpg';
    } else if (videoUrl.contains('v=')) {
      final videoId = videoUrl.split('v=').last.split('&').first;
      thumbnailUrl = 'https://img.youtube.com/vi/$videoId/0.jpg';
    }

    return ExerciseModel(
      id: json['_id'] as String? ?? '',
      title: json['exercise'] as String? ?? 'Unknown Exercise',
      description: 'Target: ${json['target_muscle_group'] ?? ''} - Equipment: ${json['primary_equipment'] ?? ''}',
      videoUrl: videoUrl,
      thumbnailUrl: thumbnailUrl,
      time: '15', 
      calories: '100',
      level: json['difficulty_level'] as String? ?? 'Beginner',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'exercise': title,
      'target_muscle_group': description,
      'short_youtube_demonstration_link': videoUrl,
      'difficulty_level': level,
    };
  }
}
