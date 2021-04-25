class Topic {
  int topicId;
  String topicName;
  int topicSubjectId;
  String topicSubjectName;
  int topicQuestionsCount;

  Topic(
      {this.topicId,
      this.topicName,
      this.topicSubjectId,
      this.topicSubjectName,
      this.topicQuestionsCount});

  Topic.fromJson(Map<String, dynamic> json) {
    topicId = json['topic_id'];
    topicName = json['topic_name'];
    topicSubjectId = json['topic_subject_id'];
    topicSubjectName = json['topic_subject_name'];
    topicQuestionsCount = json['topic_questions_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['topic_id'] = this.topicId;
    data['topic_name'] = this.topicName;
    data['topic_subject_id'] = this.topicSubjectId;
    data['topic_subject_name'] = this.topicSubjectName;
    data['topic_questions_count'] = this.topicQuestionsCount;
    return data;
  }

  static Topic fromJsonData(json) => Topic(
        topicId: json['topic_id'],
        topicName: json['topic_name'],
        topicSubjectId: json['topic_subject_id'],
        topicSubjectName: json['topic_subject_name'],
        topicQuestionsCount: json['topic_questions_count'],
      );

  static List<Topic> fromData(List<Map<String, dynamic>> data) {
    return data.map((topic) => Topic.fromJson(topic)).toList();
  }
}
