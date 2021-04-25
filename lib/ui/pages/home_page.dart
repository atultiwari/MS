import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'topics_page.dart';
import '../../data/subjects.dart';
import '../../models/subject.dart';
import '../../admob/admob_service.dart';
import '../../admob/admob_status.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Medical MCQs Quiz'),
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
          CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: <Widget>[
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: MediaQuery.of(context).size.width > 1000
                            ? 7
                            : MediaQuery.of(context).size.width > 600
                                ? 5
                                : 3,
                        childAspectRatio: 1.2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0),
                    delegate: SliverChildBuilderDelegate(
                      _buildCategoryItem,
                      childCount: subjects.length,
                    )),
              ),
            ],
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
      //backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildCategoryItem(BuildContext context, int index) {
    Subject subject = subjects[index];
    return MaterialButton(
      elevation: 1.0,
      highlightElevation: 1.0,
      onPressed: () => _loadTopicsPage(context, subject),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.grey.shade800,
      textColor: Colors.white70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AutoSizeText(
            subject.subjectName,
            minFontSize: 10.0,
            textAlign: TextAlign.center,
            maxLines: 3,
            wrapWords: false,
          ),
        ],
      ),
    );
  }

  _loadTopicsPage(BuildContext context, Subject subject) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => TopicsPage(
                  subject: subject,
                )));
  }
}
