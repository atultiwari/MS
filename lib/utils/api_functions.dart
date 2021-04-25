import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/topic.dart';
import '../models/question.dart';
import 'constants.dart';

Future<List<Topic>> getTopics(int subjectId) async {
  String baseUrl = AppConstsnts.baseUrl;
  String url = "$baseUrl?get_action=topics&subject_id=$subjectId";
  http.Response res = await http.get(Uri.parse(url));
  final body = json.decode(res.body);
  //print(body.map<Topic>(Topic.fromJsonData).toList());
  return body.map<Topic>(Topic.fromJsonData).toList();
}

Future<List<Question>> getQuestions(
    int topicId, int offset, int limitCount) async {
  String baseUrl = AppConstsnts.baseUrl;
  String url =
      "$baseUrl?get_action=questions&topic_id=$topicId&offset=$offset&limit_count=$limitCount";
  http.Response res = await http.get(Uri.parse(url));
  final body = json.decode(res.body);

  //return body.map<Question>(Question.fromJsonData).toList();

  List<Map<String, dynamic>> questions = List<Map<String, dynamic>>.from(body);
  return Question.fromData(questions);
}

// Future<List<Question>> getQuestions(int topicId) async {
//   //https://medicoshive.com/api/mh/v1/api.php?get_action=questions&topic_id=2
//   String baseUrl = AppConstsnts.baseUrl;
//   String url = "$baseUrl?get_action=questions&topic_id=$topicId";

//   http.Response res = await http.get(Uri.parse(url));

//   List<Map<String, dynamic>> questions =
//       List<Map<String, dynamic>>.from(json.decode(res.body));
//   return Question.fromData(questions);
// }
