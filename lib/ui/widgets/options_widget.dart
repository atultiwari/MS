import 'package:flutter/material.dart';
import '../../models/option.dart';
import '../../models/question.dart';
import '../../utils/utils.dart';

class OptionsWidget extends StatelessWidget {
  final Question question;
  final ValueChanged<Option> onClickedOption;

  const OptionsWidget({
    Key key,
    @required this.question,
    @required this.onClickedOption,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: ClampingScrollPhysics(),
      //physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      children: Utils.heightBetweenOptions(
        question.options.map((option) => buildOption(context, option)).toList(),
        height: 8,
      ),
    );
  }

  Widget buildOption(BuildContext context, Option option) {
    final color = getColorForOption(option, question);

    return GestureDetector(
      onTap: () => onClickedOption(option),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            buildAnswer(option),
            buildSolution(question.selectedOption, option),
          ],
        ),
      ),
    );
  }

  Widget buildAnswer(Option option) => Container(
        height: 50,
        child: Row(children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Text(
              '${option.optionCode}',
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
              option.optionText,
              style: TextStyle(fontSize: 20),
              softWrap: true,
            ),
          )
        ]),
      );

  Widget buildSolution(Option solution, Option answer) {
    if (solution == answer) {
      return Container();

      // return Text(
      //   question.explanation,
      //   style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
      // );
    } else {
      return Container();
    }
  }

  Color getColorForOption(Option option, Question question) {
    final isSelected = option == question.selectedOption;

    if (!isSelected) {
      return Colors.grey.shade200;
    } else {
      return option.optionIsCorrect ? Colors.green : Colors.red;
    }
  }
}
