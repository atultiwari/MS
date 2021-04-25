import 'dart:io';
import 'package:flutter/material.dart';
import '../../admob/admob_service.dart';
import '../../admob/admob_status.dart';
import '../../models/question.dart';
import '../pages/quiz_page.dart';
import '../../utils/api_functions.dart';
import '../../models/topic.dart';
import '../pages/error_page.dart';

class QuizOptionsDialog extends StatefulWidget {
  final Topic topic;

  const QuizOptionsDialog({Key key, this.topic}) : super(key: key);

  @override
  _QuizOptionsDialogState createState() => _QuizOptionsDialogState();
}

class _QuizOptionsDialogState extends State<QuizOptionsDialog> {
  bool processing;

  RangeValues values = RangeValues(1, 5);
  //RangeValues values;

  @override
  void initState() {
    super.initState();
    processing = false;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey.shade200,
            child: Text(
              widget.topic.topicName,
              style: Theme.of(context).textTheme.headline6.copyWith(),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            "Select Question Range",
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10.0),
          SliderTheme(
            data: SliderThemeData(
              activeTickMarkColor: Colors.transparent,
              inactiveTickMarkColor: Colors.transparent,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildSliderSideLabel(),
                const SizedBox(height: 16),
                Text(
                  "Starting Question No. : ${values.start.round().toString()}",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  "Ending Question No. : ${values.end.round().toString()}",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          processing
              ? CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _startQuiz, child: Text("Start Quiz")),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }

  Widget buildSliderSideLabel() {
    final double min = 1;
    final int maxInt = widget.topic.topicQuestionsCount;
    final double max = maxInt.toDouble();
    //final double max = 5;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildSideLabel(min),
          Expanded(
            child: RangeSlider(
              values: values,
              min: min,
              max: max,
              divisions: max.round(),
              labels: RangeLabels(
                values.start.round().toString(),
                values.end.round().toString(),
              ),
              onChanged: (values) => setState(() => this.values = values),
            ),
          ),
          buildSideLabel(max),
        ],
      ),
    );
  }

  Widget buildSideLabel(double value) => Container(
        width: 40,
        child: Text(
          value.round().toString(),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      );

  void _startQuiz() async {
    setState(() {
      processing = true;
    });
    try {
      int offset = values.start.round() - 1;
      int limitCount = values.end.round() - values.start.round() + 1;

      List<Question> questions =
          await getQuestions(widget.topic.topicId, offset, limitCount);
      print(questions.length);

      Navigator.pop(context);
      if (questions.length < 1) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ErrorPage(
                  message:
                      "There are not enough questions in the category, with the options you selected.",
                )));
        return;
      }
      if (AdMobStatus.isAdSupportedPlatform) {
        AdMobService.showInterstitialAd();
      }
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => QuizPage(
                    questions: questions,
                    topicDetails: widget.topic,
                  )));
    } on SocketException catch (_) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => ErrorPage(
                    message:
                        "Can't reach the servers, \n Please check your internet connection.",
                  )));
    } catch (e) {
      print(e.message);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => ErrorPage(
                    message: "Unexpected error trying to connect to the API",
                  )));
    }
    setState(() {
      processing = false;
    });
  }
}
