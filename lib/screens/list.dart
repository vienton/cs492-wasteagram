import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wasteagram/models/gram.dart';
import 'package:wasteagram/widgets/post_fab.dart';
import 'detail.dart';

class List extends StatefulWidget {
  final String title = 'Wasteagram';
  static const routeName = '/';
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  List({
    Key key,
    this.analytics,
    this.observer,
  }) : super(key: key);

  @override
  _ListState createState() => _ListState();
}

class _ListState extends State<List> {
  Future<void> _sendCurrentScreen() async {
    await widget.analytics.setCurrentScreen(
      screenName: 'grams_list',
      screenClassOverride: widget.title,
    );
  }

  int itemCount;
  Widget niceDate(Timestamp input) {
    DateTime date = input.toDate();
    final String output =
        DateFormat.yMMMMEEEEd('en_US').format(date).toString();
    return Text(
      output,
      style: Theme.of(context).textTheme.headline6,
    );
  }

  void showGramDetail(var gram) {
    Gram temp = Gram();
    temp.date = gram['date'].toDate();
    temp.imageURL = gram['imageURL'];
    temp.quantity = gram['items'];
    temp.latitude = gram['latitude'];
    temp.longitude = gram['longitude'];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Detail(
          gram: temp,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _sendCurrentScreen();
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('grams')
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (content, snapshot) {
        if (snapshot.hasData &&
            snapshot.data.docs != null &&
            snapshot.data.docs.length > 0) {
          itemCount = 0;
          for (var item in snapshot.data.docs) {
            itemCount += item['items'];
            print(itemCount);
          }
          return Scaffold(
            appBar: AppBar(
              title: Text('${widget.title} [$itemCount items]'),
              centerTitle: true,
            ),
            body: ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                var gram = snapshot.data.docs[index];
                return Semantics(
                  enabled: true,
                  container: true,
                  onTapHint: 'Show gram detail',
                  child: ListTile(
                    title: niceDate(gram['date']),
                    trailing: Text(
                      gram['items'].toString(),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    onTap: () {
                      showGramDetail(gram);
                    },
                  ),
                );
              },
            ),
            floatingActionButton: PostFAB(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
              centerTitle: true,
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
            floatingActionButton: PostFAB(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
        }
      },
    );
  }
}
