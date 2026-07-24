import 'package:fitness/features/food/data/models/response/meal_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'meal_details_response.g.dart';

@JsonSerializable()
class MealDetailsResponse {
  final List<MealDto>? meals;

  MealDetailsResponse({this.meals});

  factory MealDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$MealDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MealDetailsResponseToJson(this);
}
