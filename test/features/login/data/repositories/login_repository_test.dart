import 'package:fitness/config/base_response/base_response.dart';
import 'package:fitness/features/auth/data/models/auth_user_model.dart';
import 'package:fitness/features/auth/data/models/login_params.dart';
import 'package:fitness/features/auth/domain/entities/auth_user_entity.dart';
import 'package:fitness/features/login/data/datasources/login_local_data_source_contract.dart';
import 'package:fitness/features/login/data/datasources/login_remote_data_source_contract.dart';
import 'package:fitness/features/login/data/repositories/login_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginRemoteDataSource extends Mock implements LoginRemoteDataSourceContract {}
class MockLoginLocalDataSource extends Mock implements LoginLocalDataSourceContract {}
class FakeAuthUserEntity extends Fake implements AuthUserEntity {}

void main() {
  late LoginRepositoryImpl repository;
  late MockLoginRemoteDataSource mockRemoteDataSource;
  late MockLoginLocalDataSource mockLocalDataSource;

  setUpAll(() {
    registerFallbackValue(FakeAuthUserEntity());
  });

  setUp(() {
    mockRemoteDataSource = MockLoginRemoteDataSource();
    mockLocalDataSource = MockLoginLocalDataSource();
    repository = LoginRepositoryImpl(
      mockRemoteDataSource,
      mockLocalDataSource,
    );
  });

  group('login', () {
    const tLoginParams = LoginParams(email: 'test@test.com', password: 'password');
    const tAuthUserEntity = AuthUserEntity(
      id: '1',
      token: 'token',
      name: 'Test',
      email: 'test@test.com',
      phone: '1234567890',
    );
    const tAuthUserModel = AuthUserModel(
      id: '1',
      token: 'token',
      name: 'Test',
      email: 'test@test.com',
      phone: '1234567890',
    );
    const tAuthResponseModel = AuthResponseModel(
      message: 'success',
      token: 'token',
      user: tAuthUserModel,
    );

    test('should return Success and save user locally when remote call is successful', () async {
      // arrange
      when(() => mockRemoteDataSource.login(params: tLoginParams))
          .thenAnswer((_) async => const Success(data: tAuthResponseModel));
      when(() => mockLocalDataSource.saveUser(any()))
          .thenAnswer((_) async => const Success(data: null));

      // act
      final result = await repository.login(params: tLoginParams);

      // assert
      expect(result, isA<Success<AuthUserEntity>>());
      final data = (result as Success<AuthUserEntity>).data;
      expect(data?.id, tAuthUserEntity.id);
      expect(data?.email, tAuthUserEntity.email);
      verify(() => mockRemoteDataSource.login(params: tLoginParams)).called(1);
      verify(() => mockLocalDataSource.saveUser(any())).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return Error when remote call is unsuccessful', () async {
      // arrange
      final exception = Exception('API Error');
      when(() => mockRemoteDataSource.login(params: tLoginParams))
          .thenAnswer((_) async => Error(exception: exception));

      // act
      final result = await repository.login(params: tLoginParams);

      // assert
      expect(result, isA<Error<AuthUserEntity>>());
      final resultException = (result as Error<AuthUserEntity>).exception;
      expect(resultException, exception);
      verify(() => mockRemoteDataSource.login(params: tLoginParams)).called(1);
      verifyZeroInteractions(mockLocalDataSource);
    });

    test('should return Error when remote call is successful but data is null', () async {
      // arrange
      when(() => mockRemoteDataSource.login(params: tLoginParams))
          .thenAnswer((_) async => const Success(data: null));

      // act
      final result = await repository.login(params: tLoginParams);

      // assert
      expect(result, isA<Error<AuthUserEntity>>());
      final resultException = (result as Error<AuthUserEntity>).exception;
      expect(resultException, isA<Exception>());
      expect((resultException as Exception).toString(), contains('User data is null or empty'));
      verify(() => mockRemoteDataSource.login(params: tLoginParams)).called(1);
      verifyZeroInteractions(mockLocalDataSource);
    });
  });
}
