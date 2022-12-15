import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia/features/number_trivia/domain/usecase/get_concrete_number_trivia.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetConcreteNumberTrivia? usecase;
  MockNumberTriviaRepository? mockRepository;

  setUp(() {
    mockRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockRepository!);
  });

  int tNumber = 1;
  final tNumberTrivia = NumberTrivia(text: 'test text', number: tNumber);

  test('should get trivia for the number from the repository', () async {
    // arrange
    when(() => mockRepository!.getConcreteNumberTrivia(any()))
        .thenAnswer((_) async {
      return Right(tNumberTrivia);
    });
    // act
    final result = await usecase!(Params(number: tNumber));

    // assert
    expect(result, Right(tNumberTrivia));

    verify(() => mockRepository!.getConcreteNumberTrivia(tNumber));
    verifyNoMoreInteractions(mockRepository!);
  });
}
