import 'package:flutter/material.dart';
import 'questions.dart';
import 'package:quizzler/open_trivia_db.dart';

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        appBar: null,
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Icon> scoreKeeper = [];

  void checkAnswer(bool userPickedAnswer) {
    bool correctAnswer = questionBank[questionNumber].questionAnswer;

    if (userPickedAnswer == correctAnswer) {
      scoreKeeper.add(Icon(
        Icons.check,
        color: Colors.green,
      ));
    } else {
      scoreKeeper.add(Icon(
        Icons.close,
        color: Colors.red,
      ));
    }
    setState(() {
      questionNumber++;
    });
  }

//  List<String> questions = [
//    'You can lead a cow down stairs but not up stairs.',
//    'Approximately one quarter of human bones are in the feet.',
//    'A slug\'s blood is green.',
//  ];
//
//  List<bool> answers = [false, true, true];
//
//  Question q1 = new Question(
//      q: 'You can lead a cow down stairs but not up stairs.', a: false);

  List<Question> questionBank = [];
  int questionNumber = 0;

  @override
  void initState() {
    super.initState();
    OpenTriviaDb.fetchQuestions(10).then((questions) {
      setState(() {
        questionBank = questions;
      });
    }).catchError((e) => print(e));
  }

  @override
  Widget build(BuildContext context) {
    if (questionBank.isEmpty) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Center(
                child: Text(
                  questionBank[questionNumber].questionText,
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: FlatButton(
                  textColor: Colors.white,
                  color: Colors.green,
                  child: Text("True"),
                  onPressed: () {
                    checkAnswer(true);
                  }),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: FlatButton(
                textColor: Colors.white,
                color: Colors.red,
                child: Text("False"),
                onPressed: () {
                  checkAnswer(false);
                },
              ),
            ),
          ),
          Row(
            children: scoreKeeper,
          ),
        ],
      );
    }
  }
}
