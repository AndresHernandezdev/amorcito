import 'dart:convert';
import 'dart:math';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pregúntale a tu amorcito',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pregúntale a tu amorcito'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Iniciar'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QuestionScreen()),
            );
          },
        ),
      ),
    );
  }
}

class QuestionScreen extends StatefulWidget {
  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int score = 0;
  int currentQuestion = 0;
  List<int> shownQuestions = [];
  List questions = [];

  Future<void> loadQuestions() async {
    String data = await Flame.assets.readFile('preguntas.json');
    questions = json.decode(data);
  }

  void showQuestion() async {

    await loadQuestions();
    Random random = Random();
    int index = random.nextInt(questions.length);

    while (shownQuestions.contains(index)) {
      index = random.nextInt(questions.length);
    }
    setState(() {
      currentQuestion = index;
      shownQuestions.add(index);
      print(questions.length);
    });
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pregunta ${shownQuestions.length}'),
          content: Text(questions[currentQuestion]),
          actions: [
            TextButton(
              child: Text('Responder'),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  score++;
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Puntuación: $score'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Preguntar'),
          onPressed: showQuestion,
        ),
      ),
    );
  }
}
