import 'package:bloc_test/bloc_test.dart';
import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/food/data/models/response/meal_dto.dart';
import 'package:fitness/features/food/domain/use_case/get_meal_details_use_case.dart';
import 'package:fitness/features/food/presentation/details_food/view_model/cubit/details_food_cubit.dart';
import 'package:fitness/features/food/presentation/details_food/view_model/intent/details_food_intent.dart';
import 'package:fitness/features/food/presentation/details_food/view_model/states/details_food_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetMealDetailsUseCase extends Mock implements GetMealDetailsUseCase {}

void main() {
  late DetailsFoodCubit cubit;
  late MockGetMealDetailsUseCase mockGetMealDetailsUseCase;

  setUp(() {
    mockGetMealDetailsUseCase = MockGetMealDetailsUseCase();
    cubit = DetailsFoodCubit(mockGetMealDetailsUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  test('Initial state should be DetailsFoodState()', () {
    expect(cubit.state, equals(const DetailsFoodState()));
  });

  group('FetchMealDetailsIntent', () {
    const tMealId = '12345';
    final tMealDto = MealDto(
      idMeal: tMealId,
      strMeal: 'Test Meal',
      strInstructions: 'Test Instructions',
    );

    blocTest<DetailsFoodCubit, DetailsFoodState>(
      'emits [loading, success] when data is fetched successfully',
      build: () {
        when(
          () => mockGetMealDetailsUseCase(tMealId),
        ).thenAnswer((_) async => Success(data: tMealDto));
        return cubit;
      },
      act: (cubit) => cubit.doIntent(const FetchMealDetailsIntent(tMealId)),
      expect: () => [
        const DetailsFoodState(status: DetailsFoodStatus.loading),
        DetailsFoodState(status: DetailsFoodStatus.success, meal: tMealDto),
      ],
      verify: (_) {
        verify(() => mockGetMealDetailsUseCase(tMealId)).called(1);
      },
    );

    blocTest<DetailsFoodCubit, DetailsFoodState>(
      'emits [loading, error] when fetching data fails',
      build: () {
        when(() => mockGetMealDetailsUseCase(tMealId)).thenAnswer(
          (_) async => Error(exception: Exception('Server Error')),
        );
        return cubit;
      },
      act: (cubit) => cubit.doIntent(const FetchMealDetailsIntent(tMealId)),
      expect: () => [
        const DetailsFoodState(status: DetailsFoodStatus.loading),
        const DetailsFoodState(
          status: DetailsFoodStatus.error,
          errorMessage: 'Exception: Server Error',
        ),
      ],
      verify: (_) {
        verify(() => mockGetMealDetailsUseCase(tMealId)).called(1);
      },
    );
  });
}
