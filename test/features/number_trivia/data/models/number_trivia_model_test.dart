import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  NumberTriviaModel tNumberTriviaModel =
      NumberTriviaModel(text: 'test text', number: 1);

  test(
      'should be a subclass from NumberTrivia',
      () => {
            // assert
            expect(tNumberTriviaModel, isA<NumberTrivia>())
          });

  group('from json', () {
    test('should return a valid model when the json number is an integer ', () {
      // arrange
      final Map<String, dynamic> mapJason = json.decode(fixture('trivia.json'));
      //act
      final result = NumberTriviaModel.fromJason(mapJason);
      // assert
      expect(result, tNumberTriviaModel);
    });
    test('should return a valid model when the json number is a double', () {
      // arrange
      final Map<String, dynamic> mapJson =
          json.decode(fixture('trivia_double.json'));
      // act
      final result = NumberTriviaModel.fromJason(mapJson);
      // assert
      expect(result, tNumberTriviaModel);
    });
  });
}
