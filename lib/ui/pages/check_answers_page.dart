import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:html_unescape/html_unescape.dart';
import '../../admob/admob_service.dart';
import '../../admob/admob_status.dart';
import '../../models/question.dart';

class CheckAnswersPage extends StatelessWidget {
  final List<Question> questions;

  const CheckAnswersPage({Key key, @required this.questions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check Answers'),
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: WaveClipperTwo(),
            child: Container(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              height: 200,
            ),
          ),
          ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: this.questions.length + 1,
            itemBuilder: _buildItem,
          )
        ],
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

  Widget _buildItem(BuildContext context, int index) {
    if (index == this.questions.length) {
      return ElevatedButton(
        child: Text("Done"),
        onPressed: () {
          Navigator.of(context)
              .popUntil(ModalRoute.withName(Navigator.defaultRouteName));
        },
      );
    }
    Question question = this.questions[index];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blueGrey[200],
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    HtmlUnescape().convert(question.questionText),
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            buildOptions(question, 0),
            buildOptions(question, 1),
            buildOptions(question, 2),
            buildOptions(question, 3),
          ],
        ),
      ),
    );
  }

  Widget buildOptions(Question question, int optionIndex) {
    final color = getOptionColor(question, optionIndex);
    return Container(
      height: 50,
      color: color,
      child: Row(children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          child: Text(
            '${question.options[optionIndex].optionCode}',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            question.options[optionIndex].optionText,
            style: TextStyle(fontSize: 20),
            softWrap: true,
          ),
        )
      ]),
    );
  }

  Color getOptionColor(Question question, int optionIndex) {
    bool isSelected = false;

    if (question.selectedOption != null) {
      if (question.options[optionIndex] == question.selectedOption) {
        isSelected = true;
      }
    }

    if (!isSelected) {
      return question.options[optionIndex].optionIsCorrect
          ? Colors.green
          : Colors.grey.shade200;
    } else {
      return question.options[optionIndex].optionIsCorrect
          ? Colors.green
          : Colors.red;
    }
  }
}
