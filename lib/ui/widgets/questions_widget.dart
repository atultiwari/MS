import 'package:flutter/material.dart';
import '../../models/option.dart';
import '../../models/question.dart';
import 'options_widget.dart';

class QuestionsWidget extends StatelessWidget {
  final List<Question> questions;
  final PageController controller;
  final ValueChanged<int> onChangedPage;
  final ValueChanged<Option> onClickedOption;

  const QuestionsWidget({
    Key key,
    @required this.questions,
    @required this.controller,
    @required this.onChangedPage,
    @required this.onClickedOption,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => PageView.builder(
        onPageChanged: onChangedPage,
        controller: controller,
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final question = questions[index];

          return buildQuestion(question: question);
        },
      );

  Widget buildQuestion({
    @required Question question,
  }) =>
      SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            Text(
              question.questionText,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            SizedBox(height: 32),
            // Column(
            //   mainAxisSize: MainAxisSize.min,
            //   children: <Widget>[
            //     ...question.options.map((option) {
            //       return Text(option.optionText);
            //     }).toList(),
            //   ],
            // ),

            OptionsWidget(
              question: question,
              onClickedOption: onClickedOption,
            ),
          ],
        ),
      );
}
