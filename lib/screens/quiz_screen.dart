import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:quiz/model/model.dart';
import 'package:quiz/screens/result_screen.dart';

class QuizScreen extends StatefulWidget {
  final QuizSet quizSet;

  const QuizScreen({super.key, required this.quizSet});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuiestionIndex = 0;
  List<int?> selectedAnswers = [];

  @override
  void initState() {
    super.initState();
    selectedAnswers = List<int?>.filled(widget.quizSet.questions.length, null);
  }

  void goToNextQuestion() {
    if (currentQuiestionIndex < widget.quizSet.questions.length - 1) {
      setState(() {
        currentQuiestionIndex++;
      });
    }
  }

  void goToPreviousQuestion() {
    if (currentQuiestionIndex > widget.quizSet.questions.length - 1) {
      setState(() {
        currentQuiestionIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Question currentQuiestion =
        widget.quizSet.questions[currentQuiestionIndex];

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple,
              Colors.indigo,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 60,
              ),

             Padding(
              padding: const EdgeInsets.all(8.0), // You can adjust the padding value as needed
              child: Row(
                children: [
                  InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 30,
                  ),),
                  Text(
                    widget.quizSet.name,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  ],
              ),
            ),

              // SizedBox(height: 15),

          Container(
            height: MediaQuery.of(context).size.height / 1.8,
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,                  
              borderRadius: BorderRadius.circular(15),
           ),
            child: Column(
              children: [
                Text(
                  currentQuiestion.question,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),),
                  SizedBox(height: 20),
                  ...currentQuiestion.options.asMap().entries.map((entry) {
                  final index = entry.key;
                  final option = entry.value;
                  return GestureDetector(
                    onTap: () {
                    setState(() {
                      selectedAnswers[currentQuiestionIndex] = index;                        
                      });
                      },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                      margin: EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10), // Added values for margin
                      decoration: BoxDecoration(color: selectedAnswers[currentQuiestionIndex]== 
                        index? Colors.indigo : Colors.white,
                        border: Border.all(
                        width: 2,
                        color: selectedAnswers[currentQuiestionIndex] ==
                         index? Colors.indigo: Colors.grey,
                       ),
                       borderRadius: BorderRadius.circular(25),
                      ), 
                      child: Center(
                        child: Text(
                        option,textAlign: TextAlign.center,
                        style: TextStyle(
                          color: selectedAnswers[currentQuiestionIndex] ==
                            index? Colors.white: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                        ),
                        ),
                      ),
                      ),
                      );
                    })
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  currentQuiestionIndex > 0? 
                  ElevatedButton(
                    onPressed: goToPreviousQuestion,
                  child: Text("Back",style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  
                  ),
                  ):
                  SizedBox(),

                  ElevatedButton(
                        onPressed: () {
                          if (currentQuiestionIndex <
                              widget.quizSet.questions.length - 1) {
                            goToNextQuestion();
                          } else {
                            int totalCorrect = 0;
                            for (int i = 0;
                                i < widget.quizSet.questions.length;
                                i++) {
                              if (selectedAnswers[i] ==
                                  widget.quizSet.questions[i].selectedIndex) {
                                totalCorrect++;
                              }
                            }
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResultScreen(
                                  totalQuestions:
                                      widget.quizSet.questions.length,
                                  totalAttempts:
                                      widget.quizSet.questions.length,
                                  totalCorrect: totalCorrect * 10,
                                  quizSet: widget.quizSet,
                                  totalScore: totalCorrect,
                                ),
                              ),
                            );
                          }
                        },
                        child: Text(
                          currentQuiestionIndex ==
                                  widget.quizSet.questions.length - 1
                              ? "Submit"
                              : "Next",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      )

            ],)
              ),

            ],
          ),
        ),
      ),
    );
  }
}