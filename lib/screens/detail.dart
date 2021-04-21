import 'package:intl/intl.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:wasteagram/models/gram.dart';

class Detail extends StatefulWidget {
  final String title = 'Wasteagram';
  static const routeName = 'grams_detail';
  final Gram gram;

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  Detail({
    Key key,
    this.gram,
    this.analytics,
    this.observer,
  }) : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  Future<void> _sendCurrentScreen() async {
    await widget.analytics.setCurrentScreen(
      screenName: 'grams_detail',
      screenClassOverride: widget.title,
    );
  }

  Widget niceDate(DateTime input) {
    final String output =
        DateFormat.yMMMMEEEEd('en_US').format(input).toString();
    return Text(
      output,
      style: Theme.of(context).textTheme.headline5,
    );
  }

  @override
  Widget build(BuildContext context) {
    _sendCurrentScreen();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            niceDate(widget.gram.date),
            SizedBox(height: 20),
            Image.network(
              widget.gram.imageURL,
              width: 600,
              height: 300,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text(
              '${widget.gram.quantity} items',
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(height: 20),
            Text('Location: ${widget.gram.latitude}, ${widget.gram.longitude}'),
          ],
        ),
      ),
    );
  }
}
