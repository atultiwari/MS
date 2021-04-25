import 'option.dart';

class Question {
  int qid;
  String questionText;
  int subjectId;
  String subjectName;
  int topicId;
  String topicName;
  int examId;
  String examName;
  String explanation;
  List<Option> options;
  bool isLocked;
  Option selectedOption;

  Question({
    this.qid,
    this.questionText,
    this.subjectId,
    this.subjectName,
    this.topicId,
    this.topicName,
    this.examId,
    this.examName,
    this.explanation,
    this.options,
    this.isLocked = false,
    this.selectedOption,
  });

  Question.fromJson(Map<String, dynamic> json) {
    qid = json['qid'];
    questionText = json['question_text'];
    subjectId = json['subject_id'];
    subjectName = json['subject_name'];
    topicId = json['topic_id'];
    topicName = json['topic_name'];
    examId = json['exam_id'];
    examName = json['exam_name'];
    explanation = json['explanation'];
    if (json['options'] != null) {
      options = <Option>[];
      json['options'].forEach((v) {
        options.add(new Option.fromJson(v));
      });
    }
    isLocked = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['qid'] = this.qid;
    data['question_text'] = this.questionText;
    data['subject_id'] = this.subjectId;
    data['subject_name'] = this.subjectName;
    data['topic_id'] = this.topicId;
    data['topic_name'] = this.topicName;
    data['exam_id'] = this.examId;
    data['exam_name'] = this.examName;
    data['explanation'] = this.explanation;
    if (this.options != null) {
      data['options'] = this.options.map((v) => v.toJson()).toList();
    }
    return data;
  }

  // static Question fromJsonData(json) => Question(
  //       qid: json['qid'],
  //       questionText: json['question_text'],
  //       subjectId: json['subject_id'],
  //       subjectName: json['subject_name'],
  //       topicId: json['topic_id'],
  //       topicName: json['topic_name'],
  //       examId: json['exam_id'],
  //       examName: json['exam_name'],
  //       explanation: json['explanation'],
  //     );

  static List<Question> fromData(List<Map<String, dynamic>> data) {
    return data.map((question) => Question.fromJson(question)).toList();
  }
}
