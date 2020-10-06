import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'questions.dart';
import 'package:quizzler/open_trivia_db.dart';

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
//
//  void checkAnswer(bool userPickedAnswer) {
//
//
//	bool correctAnswer = questionBank[questionNumber].questionAnswer;
//
//	if (userPickedAnswer == correctAnswer) {
//	  scoreKeeper.add(Icon(
//		Icons.check,
//		color: Colors.green,
//
//	  ));
//	} else {
//	  scoreKeeper.add(Icon(
//		Icons.close,
//		color: Colors.red,
//	  ));
//	}
//
//	setState(() {
//
//	  questionNumber++;
//	},
//	)
//	;
//  }
//
//  List<String> questions = [
//
//    'You can lead a cow down stairs but not up stairs.',
//
//    'Approximately one quarter of human bones are in the feet.',
//
//    'A slug\'s blood is green.',
//  ];
//
//  List<bool> answers = [false, true, true];
//
//  Question q1 = new Question(
//      q: 'You can lead a cow down stairs but not up stairs.', a: false);

  List<Icon> scoreKeeper = [];
  int score = 0;

  bool isFinished() {
    if (questionNumber >= questionBank.length - 1)
      return true;
    else
      return false;
  }

  void nextQuestion() {
    if (questionNumber < questionBank.length - 1) {
      questionNumber++;
    }
  }

  void reset() {
    questionNumber = 0;
  }

  void checkAnswer(bool userPickedAnswer) {
    bool correctAnswer = questionBank[questionNumber].questionAnswer;

    var alertStyle = AlertStyle(
      animationType: AnimationType.grow,
      isCloseButton: false,
      isOverlayTapDismiss: true,
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      animationDuration: Duration(milliseconds: 500),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.red,
        fontSize: 25,
      ),
    );

    setState(() {
      if (isFinished()) {
        Alert(
          context: context,
          style: alertStyle,
          type: AlertType.success,
          title: "CONGRATULATIONS",
          desc: "Score: $score ",
          buttons: [
            DialogButton(
              child: Text(
                "NEW QUIZ",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Quizzler(),
                  ),
                );
                setState(() {
                  reset();
                  scoreKeeper.clear();
                  score = 0;
                });
              },
              width: 150,
              color: Color.fromRGBO(0, 179, 134, 1.0),
              radius: BorderRadius.circular(8),
            ),
          ],
        ).show();
      } else {
        if (userPickedAnswer == correctAnswer) {
          scoreKeeper.add(Icon(
            Icons.check,
            color: Colors.green,
          ));
          score++;
        } else {
          scoreKeeper.add(Icon(
            Icons.close,
            color: Colors.red,
          ));
        }
        nextQuestion();
      }
    });
  }

  List<Question> questionBank = [];
  int questionNumber = 0;
  int qCount = 12;

  @override
  void initState() {
    super.initState();
    OpenTriviaDb.fetchQuestions(qCount).then((questions) {
      setState(() {
        questionBank = questions;
      });
    }).catchError((e) => print(e));
  }

  @override
  Widget build(BuildContext context) {
    if (questionBank.isEmpty) {
      return Center(
          child: SpinKitSquareCircle(
        size: 50,
        color: Colors.yellow,
      ));
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
          SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: scoreKeeper,
            ),
          ),
        ],
      );
    }
  }
}
