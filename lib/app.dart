import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:wasteagram/screens/detail.dart';
import 'package:wasteagram/screens/list.dart';
import 'package:wasteagram/screens/post.dart';

class App extends StatefulWidget {
  // This widget is the root of your application.
  static final routes = {
    List.routeName: (context) => List(),
    Detail.routeName: (context) => Detail(),
    Post.routeName: (context) => Post(),
  };

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    analytics.logAppOpen();
    // Force app to crash for Crashlytics testing
    // FirebaseCrashlytics.instance.crash();
    return MaterialApp(
      title: 'Wasteagram',
      navigatorObservers: [observer],
      theme: ThemeData.dark(),
      routes: App.routes,
    );
  }
}
