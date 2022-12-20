import 'package:dartz/dartz.dart';
import 'package:number_trivia/core/error/exeptions.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/platform/network_info.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';

import '../datasources/number_trivia_local_data_source.dart';

class NumberTriviaRepositoryImpl extends NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return await getNumberTrivia(() => remoteDataSource.getConcreteNumberTrivia(number));
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await getNumberTrivia(() => remoteDataSource.getRandomNumberTrivia());
  }

  Future<Either<Failure, NumberTrivia>> getNumberTrivia(
      Future<NumberTriviaModel> Function() getConcreteOrRandom) async {
    if (await networkInfo.isConnected) {
      try {
        final trivia = await getConcreteOrRandom();
        localDataSource.cacheNumberTrivia(trivia);
        return Right(trivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final trivia = await localDataSource.getLastNumberTrivia();
        return (Right(trivia));
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
