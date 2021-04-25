import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../admob/admob_service.dart';
import '../../admob/admob_status.dart';
import '../../models/subject.dart';
import '../../models/topic.dart';
import '../widgets/quiz_options.dart';
import '../../utils/api_functions.dart';

class TopicsPage extends StatefulWidget {
  final Subject subject;

  const TopicsPage({Key key, @required this.subject}) : super(key: key);
  @override
  _TopicsPageState createState() => _TopicsPageState();
}

class _TopicsPageState extends State<TopicsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xff0F2339),
        title: Text(widget.subject.subjectName),
      ),
      body: FutureBuilder<List<Topic>>(
        future: getTopics(widget.subject.subjectId),
        builder: (context, snapshot) {
          final users = snapshot.data;

          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return Center(child: Text('Some error occurred!'));
              } else {
                return buildTopics(users);
              }
          }
        },
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

  Widget buildTopics(List<Topic> topics) => ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: topics.length,
        itemBuilder: (context, index) {
          final topic = topics[index];

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: ListTile(
                onTap: () => _loadQuizOptionsWidget(context, topic),
                title: Text(
                  topic.topicName,
                  style: TextStyle(fontSize: 22.0),
                ),
              ),
            ),
          );

          // return ListTile(
          //   onTap: () => _loadQuizOptionsWidget(context, topic),
          //   title: Text(topic.topicName),
          //   subtitle: Text(topic.topicQuestionsCount.toString()),
          // );
        },
      );

  _loadQuizOptionsWidget(BuildContext context, Topic topic) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => BottomSheet(
        builder: (_) => QuizOptionsDialog(
          topic: topic,
        ),
        onClosing: () {},
      ),
    );
  }
}
