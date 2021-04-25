import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../admob/admob_service.dart';
import '../../admob/admob_status.dart';
import '../../models/question.dart';

import 'check_answers_page.dart';

class QuizResultPage extends StatelessWidget {
  final List<Question> questions;
  final int totalQuestions;
  final int attemptedQuestions;
  final int correctAnswered;

  QuizResultPage(
      {Key key,
      @required this.questions,
      @required this.totalQuestions,
      @required this.attemptedQuestions,
      @required this.correctAnswered})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //int correctAnswered = this.correctAnswered;
    //int attemptedQuestions = this.attemptedQuestions;

    final TextStyle titleStyle = TextStyle(
        color: Colors.black87, fontSize: 16.0, fontWeight: FontWeight.w500);
    final TextStyle trailingStyle = TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 20.0,
        fontWeight: FontWeight.bold);

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Result'),
        elevation: 0,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Theme.of(context).primaryColor,
          Theme.of(context).accentColor
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text("Total Questions", style: titleStyle),
                  trailing:
                      Text("${this.totalQuestions}", style: trailingStyle),
                ),
              ),
              SizedBox(height: 10.0),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text("Score", style: titleStyle),
                  trailing: Text(
                      "${this.correctAnswered / this.totalQuestions * 100}%",
                      style: trailingStyle),
                ),
              ),
              SizedBox(height: 10.0),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text("Correct Answers", style: titleStyle),
                  trailing: Text(
                      "${this.correctAnswered}/${this.totalQuestions}",
                      style: trailingStyle),
                ),
              ),
              SizedBox(height: 10.0),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text("Incorrect Answers", style: titleStyle),
                  trailing: Text(
                      "${this.attemptedQuestions - this.correctAnswered}/${this.totalQuestions}",
                      style: trailingStyle),
                ),
              ),
              SizedBox(height: 10.0),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text("Not Attempted", style: titleStyle),
                  trailing: Text(
                      "${this.totalQuestions - this.attemptedQuestions}/${this.totalQuestions}",
                      style: trailingStyle),
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 20.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      primary: Theme.of(context).accentColor.withOpacity(0.8),
                    ),
                    child: Text("Goto Home"),
                    onPressed: () => Navigator.of(context).popUntil(
                        ModalRoute.withName(Navigator.defaultRouteName)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 20.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      primary: Theme.of(context).primaryColor,
                    ),
                    child: Text("Check Answers"),
                    onPressed: () {
                      if (AdMobStatus.isAdSupportedPlatform) {
                        AdMobService.showInterstitialAd();
                      }
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => CheckAnswersPage(
                                questions: questions,
                              )));
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: AdMobStatus.isAdSupportedPlatform
          ? Container(
              height: 50,
              child: AdWidget(
                key: UniqueKey(),
                ad: AdMobService.createBannerAd()..load(),
              ),
            )
          : Container(
              height: 50,
              child: Text('Admob is not supported on this Platform!'),
            ),
    );
  }
}
