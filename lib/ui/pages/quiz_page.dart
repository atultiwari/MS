import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../admob/admob_service.dart';
import '../../admob/admob_status.dart';
import 'quiz_result_page.dart';
import '../../models/option.dart';
import '../../models/question.dart';
import '../../models/topic.dart';
import '../widgets/question_numbers_widget.dart';
import '../widgets/questions_widget.dart';

class QuizPage extends StatefulWidget {
  final List<Question> questions;
  final Topic topicDetails;

  const QuizPage({Key key, this.questions, this.topicDetails})
      : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  PageController controller;
  Question question;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();

    controller = PageController();
    question = widget.questions.first;
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: buildAppBar(context),
          body: QuestionsWidget(
            questions: widget.questions,
            controller: controller,
            onChangedPage: (index) => nextQuestion(index: index),
            onClickedOption: selectOption,
          ),
          bottomNavigationBar:
              (widget.questions != null && widget.questions.isNotEmpty)
                  ? buildBottomAppBar(context)
                  : null,
        ),
      );

  Widget buildAppBar(context) => AppBar(
        title: Text(widget.topicDetails.topicName),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close_rounded),
              tooltip: 'End Quiz',
              onPressed: _onWillPop),
          SizedBox(width: 16),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepOrange, Colors.purple],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: QuestionNumbersWidget(
              questions: widget.questions,
              question: question,
              onClickedNumber: (index) =>
                  nextQuestion(index: index, jump: true),
            ),
          ),
        ),
      );

  Widget buildBottomAppBar(context) => BottomAppBar(
        child: Container(
          //height: 50.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: currentPage <= 0
                        ? null
                        : () {
                            controller.previousPage(
                              duration: Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          },
                    child: Text("Previous"),
                  ),
                  //Spacer(),

                  (currentPage == widget.questions.length - 1)
                      ? ElevatedButton(
                          onPressed: () {
                            //Navigator.pop(context);
                            int attemptedQuestions = widget.questions
                                .where((question) => question.isLocked == true)
                                .length;

                            int correctAnswered = 0;
                            for (int i = 0; i < widget.questions.length; i++) {
                              if (widget.questions[i].selectedOption != null) {
                                if (widget.questions[i].selectedOption
                                    .optionIsCorrect) {
                                  correctAnswered++;
                                }
                              }
                            }
                            print('Total Questions => ' +
                                widget.questions.length.toString());
                            print('Attempted Questions => ' +
                                attemptedQuestions.toString());
                            print('Correct Answered => ' +
                                correctAnswered.toString());

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => QuizResultPage(
                                          questions: widget.questions,
                                          totalQuestions:
                                              widget.questions.length,
                                          attemptedQuestions:
                                              attemptedQuestions,
                                          correctAnswered: correctAnswered,
                                        )));
                          },
                          child: Text("End Quiz"),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red, // background
                            onPrimary: Colors.white, // foreground
                          ),
                        )
                      : ElevatedButton(
                          onPressed: currentPage >= widget.questions.length - 1
                              ? null
                              : () {
                                  controller.nextPage(
                                    duration: Duration(milliseconds: 400),
                                    curve: Curves.easeInOut,
                                  );
                                },
                          child: Text("Next"),
                        ),
                ],
              ),
              // AdMobStatus.isAdSupportedPlatform
              //     ? Container(
              //         height: 50,
              //         child: AdWidget(
              //           key: UniqueKey(),
              //           ad: AdMobService.createBannerAd()..load(),
              //         ),
              //       )
              //     : Container(
              //         height: 50,
              //         child: Text('Admob is not supported on this Platform!'),
              //       ),
            ],
          ),
        ),
      );

  void selectOption(Option option) {
    if (question.isLocked) {
      return;
    } else {
      setState(() {
        question.isLocked = true;
        question.selectedOption = option;
      });
    }
  }

  void nextQuestion({int index, bool jump = false}) {
    final nextPage = controller.page + 1;
    final indexPage = index ?? nextPage.toInt();

    setState(() {
      question = widget.questions[indexPage];
      currentPage = indexPage;
    });

    if (jump) {
      controller.jumpToPage(indexPage);
    }
  }

  Future<bool> _onWillPop() async {
    return showDialog<bool>(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Text(
                "Are you sure you want to quit the quiz? All your progress will be lost."),
            title: Text("Warning!"),
            actions: <Widget>[
              TextButton(
                child: Text("Yes"),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
              TextButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
            ],
          );
        });
  }
}
