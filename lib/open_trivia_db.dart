import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html_unescape/html_unescape.dart';
import 'package:quizzler/questions.dart';

final _htmlUnescape = HtmlUnescape();

class OpenTriviaDb {
  static String _baseUrl = "https://opentdb.com/api.php";

  static Future<List<Question>> fetchQuestions(int amount) async {
    final response = await http.get('$_baseUrl?amount=$amount&type=boolean');
    if (response.statusCode == 200) {
      final res = _OpenTriviaDbResponse.fromJson(json.decode(response.body));
      return res.results
          .map((r) => Question(q: r.question, a: r.getAnswerAsBool()))
          .toList();
    } else {
      throw Exception('Failed to load questions');
    }
  }
}

class _OpenTriviaDbResponse {
  final int responseCode;
  final List<_OpenTriviaDbQuestion> results;

  _OpenTriviaDbResponse(this.responseCode, this.results);

  factory _OpenTriviaDbResponse.fromJson(json) {
    return _OpenTriviaDbResponse(
        json['response_code'] as int,
        (json['results'] as List)
            .map((q) => _OpenTriviaDbQuestion.fromJson(q))
            .toList());
  }
}

class _OpenTriviaDbQuestion {
  final String category;
  final String difficulty;
  final String question;
  final String correctAnswer;

  _OpenTriviaDbQuestion(
      this.category, this.difficulty, this.question, this.correctAnswer);

  factory _OpenTriviaDbQuestion.fromJson(json) {
    return _OpenTriviaDbQuestion(json['category'], json['difficulty'],
        _htmlUnescape.convert(json['question']), json['correct_answer']);
  }

  bool getAnswerAsBool() {
    return correctAnswer == "True";
  }
}
