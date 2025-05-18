import 'dart:async';
import './flashcard.dart';
import 'package:flutter/material.dart';
import '../../controllers/reflex_controller.dart';
import '../../models/Reflex.dart';
import '../../controllers/LevelManager.dart';

class ReflexScreen extends StatefulWidget {
  @override
  _ReflexScreenState createState() => _ReflexScreenState();
}

class _ReflexScreenState extends State<ReflexScreen> {
  late ReflexModel model;
  late ReflexController controller;

  String message = '';
  bool showResult = false;
  bool showCountdown = true;
  int countdown = 3;
  bool gameFinished = false;


  @override
  void initState() {
    super.initState();
    model = ReflexModel();
    controller = ReflexController(model)
      ..onTimeUp = handleTimeUp
      ..onAnswer = handleAnswer;

    startCountdown();
  }

  void startCountdown() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (countdown > 1) {
          countdown--;
        } else {
          timer.cancel();
          showCountdown = false;
          controller.startRound(() => setState(() {}));
        }
      });
    });
  }

  void handleTimeUp() {
    setState(() {
      message = "⏰ Time's up! Answer: ${model.currentLetter}";
      showResult = true;
    });
    Future.delayed(Duration(seconds: 2), nextRound);
  }

  void handleAnswer(bool correct) {
    setState(() {
      message = correct ? '✅ Correct!' : '❌ Wrong!';
      showResult = true;
    });
    Future.delayed(Duration(seconds: 2), nextRound);
  }

  void nextRound() {
    if (model.isFinished) {
      setState(() {
        gameFinished = true;
        LevelManager.unlockLevel(1);
      });
      return;
    }
    setState(() {
      showResult = false;
      message = '';
    });
    controller.startRound(() => setState(() {}));
  }


  Widget buildLetterButton(String letter) {
    return GestureDetector(
      onTap: showResult ? null : () => controller.checkAnswer(letter),
      child: Image.asset(
        'assets/images/$letter.png',
        width: 150,
        height: 150,
      ),
    );
  }

  @override
  void dispose() {
    controller.stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF8EE),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Reflex Game', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFFFBEAB9),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (showCountdown)
                Text(
                  countdown > 0 ? '$countdown' : 'START!',
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                )
              else if (gameFinished)
                Column(
                  children: [
                    Text(
                      model.score > 1
                          ? '🎉 Congratulations on passing the challenge!'
                          : '😢 Failed! Try again!',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text('🎯 Your score: ${model.score}',
                        style: TextStyle(fontSize: 22)),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        model.score > 1 ?
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => FlashCardScreen()),
                        )
                            :
                        setState(() {
                          // Reset game
                          model = ReflexModel();
                          controller = ReflexController(model)
                            ..onTimeUp = handleTimeUp
                            ..onAnswer = handleAnswer;
                          countdown = 3;
                          gameFinished = false;
                          showCountdown = true;
                          startCountdown();
                        });
                      },
                      child: Text(
                        model.score > 1 ? 'Continue' : 'Play agian',
                        style: TextStyle(fontSize: 20),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFF721A),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                )

              else
                Column(
                  children: [
                    Text('Select letter symbol:',
                        style: TextStyle(fontSize: 20)),
                    SizedBox(height: 10),
                    Text(
                      model.currentLetter,
                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    Text('⏳ Time: ${controller.timeLeft}s',
                        style: TextStyle(fontSize: 18)),
                    SizedBox(height: 20),
                    if (showResult)
                      Text(message, style: TextStyle(fontSize: 24)),
                    SizedBox(height: 20),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 20,
                      runSpacing: 20,
                      children: model.letters
                          .map((letter) => buildLetterButton(letter))
                          .toList(),
                    ),
                    SizedBox(height: 40),
                    Text('Score: ${model.score}',
                        style: TextStyle(fontSize: 22)),
                  ],
                ),
            ],
          ),
        ),
      ),


    );
  }
}
