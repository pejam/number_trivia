import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/core/error/exeptions.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/platform/network_info.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImpl? repository;
  MockRemoteDataSource? mockRemoteDataSource;
  MockLocalDataSource? mockLocalDataSource;
  MockNetworkInfo? mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
        remoteDataSource: mockRemoteDataSource!,
        localDataSource: mockLocalDataSource!,
        networkInfo: mockNetworkInfo!);
  });

  /*void runTestOnline(Function body){
    setUp(() => when(() => mockNetworkInfo!.isConnected)
        .thenAnswer((_) async => true));

    body();
  }

  void runTestOffline(Function body){
    setUp(() => when(() => mockNetworkInfo!.isConnected)
        .thenAnswer((_) async => false));

    body();
  }*/

  group('getConcreteTrivia', () {
    const int tNumber = 1;
    final NumberTriviaModel tNumberTriviaModel =
        NumberTriviaModel(text: 'test text', number: tNumber);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    /*test("should check when is device online", () async {
      // arrange
      when(() => mockNetworkInfo!.isConnected).thenAnswer((_) async => true);
      // act
      repository!.getConcreteNumberTrivia(tNumber);
      // assert
      verify(() => mockNetworkInfo!.isConnected);
    });*/

    group('when device is online', () {
      setUp(() => when(() => mockNetworkInfo!.isConnected)
          .thenAnswer((_) async => true));

      /*test(
          "should return remote data when the call remote datasource is success",
          () async {
        // arrange
        when(() => mockRemoteDataSource!.getConcreteNumberTrivia(any()))
            .thenAnswer((_) async => tNumberTriviaModel);
        // act  = what should happen
        final result = await repository!.getConcreteNumberTrivia(tNumber);
        // assert
        verify(() => mockRemoteDataSource!.getConcreteNumberTrivia(tNumber));
        expect(result, Right(tNumberTrivia));
      });*/
      /*test(
          "should catch the data locally when the call remote datasource is success",
          () async {
        // arrange
        when(() => mockRemoteDataSource!.getConcreteNumberTrivia(any()))
            .thenAnswer((_) async => tNumberTriviaModel);
        // act  = what should happen
        await repository!.getConcreteNumberTrivia(tNumber);
        // assert
        verify(() => mockRemoteDataSource!.getConcreteNumberTrivia(tNumber));
        verify(
            () => mockLocalDataSource!.cacheNumberTrivia(tNumberTriviaModel));
      });*/
      /*test(
          "should return server failure when the call remote datasource is unSuccessful",
          () async {
        // arrange
        when(() => mockRemoteDataSource!.getConcreteNumberTrivia(any()))
            .thenThrow(ServerException);
        // act  = what should happen
        final result = await repository!.getConcreteNumberTrivia(tNumber);
        // assert
        verify(() => mockRemoteDataSource!.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, const Left(ServerFailure));
      });*/
    });

    group('when device is offline', () {
      setUp(() => when(() => mockNetworkInfo!.isConnected)
          .thenAnswer((_) async => false));
      test(
          "should return last locally cache data when the cache data is present",
          () async {
        // arrange
        when(() => mockLocalDataSource!.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act  = what should happen
        final result = await repository!.getConcreteNumberTrivia(tNumber);
        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource!.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });

      test("should return cache failure when there is no cache failure",
          () async {
        // arrange
        when(() => mockLocalDataSource!.getLastNumberTrivia())
            .thenThrow(CacheException());
        // act  = what should happen
        final result = await repository!.getConcreteNumberTrivia(tNumber);
        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource!.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
