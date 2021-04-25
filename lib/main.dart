import 'package:flutter/material.dart';
import 'ui/pages/home_page.dart';

import 'admob/admob_service.dart';
import 'admob/admob_status.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (AdMobStatus.isAdSupportedPlatform) {
    AdMobService.initialize();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Medical MCQs',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
