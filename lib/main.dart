import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'quiz_brain.dart';

QuizBrain quizBrain = QuizBrain();

void main() => runApp(const Quizzler());

class Quizzler extends StatelessWidget {
  const Quizzler({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: const SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: _QuizPage(),
          ),
        ),
      ),
    );
  }
}

class _QuizPage extends StatefulWidget {
  const _QuizPage();

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<_QuizPage> {
  List<Icon> scoreKeeper = [];

  void resetGame() {
    setState(() {
      scoreKeeper = [];
      quizBrain.reset();
    });
  }

  void handleChangeQuestion(bool userAnswer, BuildContext context) {
    if (quizBrain.isFinished()) {
      Alert(
          context: context,
          // type: AlertType.success,
          title: "Finished!",
          desc: "You've reached the end of the quiz.",
          buttons: [
            DialogButton(
              width: 120,
              onPressed: () {
                resetGame();
                Navigator.pop(context);
              },
              child: const Text(
                "CANCEL",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          ]).show();
    } else {
      bool correctAnswer = quizBrain.getCorrectAnswer();

      setState(() {
        if (correctAnswer == userAnswer) {
          scoreKeeper.add(const Icon(
            Icons.check,
            color: Colors.green,
          ));
        } else {
          scoreKeeper.add(const Icon(
            Icons.close,
            color: Colors.red,
          ));
        }

        quizBrain.nextQuestion();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBrain.getQuestionText(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.green),
              child: const Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                //The user picked true.
                handleChangeQuestion(true, context);
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.red),
              child: const Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                //The user picked false.
                handleChangeQuestion(false, context);
              },
            ),
          ),
        ),
        Row(
          children: scoreKeeper,
        )
      ],
    );
  }
}

/*
question1: 'You can lead a cow down stairs but not up stairs.', false,
question2: 'Approximately one quarter of human bones are in the feet.', true,
question3: 'A slug\'s blood is green.', true,
*/
