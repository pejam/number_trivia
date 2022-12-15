import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia/features/number_trivia/domain/usecase/get_random_number_trivia.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  final mockRepository = MockNumberTriviaRepository();
  final useCase = GetRandomNumberTrivia(mockRepository);

  NumberTrivia tNumberTrivia = const NumberTrivia(number: 1, text: 'test');

  test('test get random  number trivia', () async {
    // arrange
    when(() => mockRepository.getRandomNumberTrivia()).thenAnswer((_) async {
      return Right(tNumberTrivia);
    });
    // act
    final result = await  useCase(NoParam());
    // assert
    expect(result, Right(tNumberTrivia));

    verify(() => mockRepository.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockRepository);
  });
}
