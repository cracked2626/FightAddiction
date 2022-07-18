import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';

import '../constants/indicator.dart';
import '../constants/instances.dart';
import '../models/feed.dart';
import '../util/theme_data.dart';
import '../widgets/story_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final queryPost = storiesCollection.withConverter(
    fromFirestore: (snapshot, _) {
      return Feed.fromJson(snapshot.data()!);
    },
    toFirestore: (data, _) => Feed().toJson(),
  );
  // flag for last document from where next 10 records to be fetched
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightWhite,
      body: Row(
        children: [
          showFeed(),
          Expanded(
            flex: 4,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: shadow,
              ),
              padding: EdgeInsets.only(top: 50),
            ),
          ),
        ],
      ),
    );
  }

  Expanded showFeed() {
    return Expanded(
      flex: 5,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 2.0,
        ),
        child: FirestoreListView<Feed>(
          pageSize: 2,
          loadingBuilder: (BuildContext context) {
            return Center(child: showDotIndicator(color: Colors.blue));
          },
          query: queryPost,
          controller: _scrollController,
          errorBuilder:
              (BuildContext context, Object object, StackTrace stackTrace) {
            return Center(
              child: Text(object.toString()),
            );
          },
          itemBuilder: (BuildContext context, QueryDocumentSnapshot<Feed> doc) {
            Feed data = doc.data();
            return StoryWidget(
              userName: data.userName,
              email: data.email,
              userId: data.userId,
              story: data.story,
              isAnonymous: data.isAnonymous,
              heading: data.heading,
              timestamp: data.timestamp,
              length: data.length,
              storyId: data.storyId,
            );
          },
        ),
      ),
    );
  }
}
