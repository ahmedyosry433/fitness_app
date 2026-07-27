import 'package:bloc_test/bloc_test.dart';
import 'package:fitness/features/food/presentation/details_food/view_model/cubit/details_food_cubit.dart';
import 'package:fitness/features/food/presentation/details_food/view_model/states/details_food_state.dart';
import 'package:fitness/features/food/presentation/details_food/views/details_food_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDetailsFoodCubit extends MockCubit<DetailsFoodState>
    implements DetailsFoodCubit {}

void main() {
  late MockDetailsFoodCubit mockCubit;

  setUp(() {
    mockCubit = MockDetailsFoodCubit();
  });

  Widget buildTestableWidget() {
    return MaterialApp(
      home: BlocProvider<DetailsFoodCubit>.value(
        value: mockCubit,
        child: const DetailsFoodView(mealId: '12345'),
      ),
    );
  }

  testWidgets('renders CircularProgressIndicator when status is loading',
      (tester) async {
    when(() => mockCubit.state).thenReturn(
      const DetailsFoodState(status: DetailsFoodStatus.loading),
    );

    await tester.pumpWidget(buildTestableWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('renders error message when status is error', (tester) async {
    const errorMsg = 'Error fetching meal details';
    when(() => mockCubit.state).thenReturn(
      const DetailsFoodState(
        status: DetailsFoodStatus.error,
        errorMessage: errorMsg,
      ),
    );

    await tester.pumpWidget(buildTestableWidget());

    expect(find.text(errorMsg), findsOneWidget);
  });
}