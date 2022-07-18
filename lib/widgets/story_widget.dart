import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:login/constants/indicator.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:zefyrka/zefyrka.dart';

import '../constants/instances.dart';
import '../constants/shimmers.dart';
import '../models/user_provider.dart';
import '../util/theme_data.dart';

class StoryWidget extends StatefulWidget {
  final String? userName;
  final String? email;
  final String? userId;
  final String? story;
  final bool? isAnonymous;
  final String? heading;
  final Timestamp? timestamp;
  final int? length;
  final String? storyId;

  const StoryWidget({
    Key? key,
    this.userName,
    this.email,
    this.userId,
    this.story,
    this.isAnonymous,
    this.heading,
    this.timestamp,
    this.length,
    this.storyId,
  }) : super(key: key);
  @override
  State<StoryWidget> createState() => _StoryWidgetState();
}

class _StoryWidgetState extends State<StoryWidget> {
  late ZefyrController storyController = ZefyrController();
  bool isStoryLoading = true;
  FocusNode _commentFocusNode = FocusNode();
  FocusNode _replyFocusNode = FocusNode();
  final TextEditingController commentController = TextEditingController();
  final TextEditingController replyController = TextEditingController();

  getUsername() {
    try {
      if (widget.isAnonymous == true) {
        return "Anonymous";
      } else {
        if (widget.userName != null) {
          log('getUsername not null: ${widget.userName}');
          return widget.userName;
        } else {
          String email = widget.email ?? "harshlohia@hotmail.com";
          if (email.isNotEmpty) {
            return email.split("@")[0];
          } else {
            return "";
          }
        }
      }
    } catch (e) {
      showToast("Error: $e");
      log("Error: $e");
      return "Anonymous";
    }
  }

  getTime(timestamp) {
    // calculate time in ago format
    try {
      if (timestamp != null) {
        DateTime now = DateTime.now();
        DateTime then = timestamp!.toDate();
        Duration difference = now.difference(then);
        if (difference.inDays > 0) {
          return difference.inDays.toString() + " d";
        } else if (difference.inHours > 0) {
          return difference.inHours.toString() + " h";
        } else if (difference.inMinutes > 0) {
          return difference.inMinutes.toString() + " m";
        } else if (difference.inSeconds > 0) {
          return difference.inSeconds.toString() + " s";
        } else {
          return "just now";
        }
      } else {
        return "just now";
      }
    } catch (e, stacktrace) {
      showToast("Error: $e");
      log("Error: $e", stackTrace: stacktrace);
      return "just now";
    }
  }

  getStory() async {
    try {
      if (widget.story == null) {
        return "";
      } else {
        // convert story to json
        var storyJson = await jsonDecode(widget.story!);
        final storyDoc = await NotusDocument.fromJson(storyJson);
        if (mounted) {
          setState(() {
            storyController = ZefyrController(storyDoc);
            isStoryLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        isStoryLoading = false;
      });
      log(e.toString());
      showToast("Error loading story");
    }
  }

  @override
  void initState() {
    getStory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white,
          boxShadow: shadow,
        ),
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            buildProfileTile(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Divider(
                color: Color(0xffe3e6e8),
                thickness: 0.5,
              ),
            ),
            isStoryLoading
                ? buildStoryShimmer()
                : Container(
                    // decoration: kFieldDecoration,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    child: ZefyrEditor(
                      readOnly: true,
                      showCursor: false,
                      scrollable: false,
                      scrollController: ScrollController(
                        initialScrollOffset: 0,
                      ),
                      controller: storyController,
                      onLaunchUrl: (String url) async {
                        log(url);
                      },
                    ),
                  ),
            //  make like and comment buttons in a row with svg picture icons
            buildFooter(),
            // show comments
            buildComments(),
          ],
        ),
      ),
    );
  }

  Row buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: buildCommentField(
            controller: commentController,
            focusNode: _commentFocusNode,
            onPressed: () async {
              saveComment();
            },
            hint: 'Write a comment...',
          ),
        ),
        Row(
          children: [
            const SizedBox(width: 10),
            IconButton(
              icon: SvgPicture.asset(
                'assets/icons/upvote1.svg',
                color: lightBluish,
                // height: 50,
              ),
              onPressed: () {
                log("like");
              },
            ),
            IconButton(
              icon: SvgPicture.asset(
                'assets/icons/chat.svg',
                color: lightBluish,
              ),
              onPressed: () {
                log("comment");
              },
            ),
          ],
        )
      ],
    );
  }

  TextField buildCommentField({
    required TextEditingController controller,
    required VoidCallback onPressed,
    required String hint,
    FocusNode? focusNode,
  }) {
    return TextField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        border: InputBorder.none,
        hintText: hint,
        fillColor: Color(0xfffafafa),
        suffixIcon: IconButton(
          icon: SvgPicture.asset(
            "assets/icons/share.svg",
            height: 20,
            width: 20,
            color: lightBluish,
          ),
          onPressed: onPressed,
        ),
      ),
      focusNode: focusNode,
      maxLines: null,
      controller: controller,
      onSubmitted: (String text) {
        log(text);
      },
    );
  }

  ListTile buildProfileTile() {
    String time = getTime(widget.timestamp);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage('assets/images/avatar.png'),
        backgroundColor: Colors.white,
      ),
      title: Text(
        getUsername(),
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        widget.heading ?? "",
        style: TextStyle(
          fontSize: 15.0,
        ),
      ),
      trailing: Text(
        widget.storyId ?? "",
        style: TextStyle(
          fontSize: 15.0,
        ),
      ),
    );
  }

  buildComments() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Divider(
            color: Color(0xffe3e6e8),
            thickness: 0.5,
          ),
        ),
        //show stream builder fetching comments from comments collection
        showComments(),
      ],
    );
  }

  void saveComment() async {
    try {
      if (commentController.text.isEmpty) {
        showToast("Please enter a comment");
        return;
      }
      // add comment to firebase collection
      await storiesCollection.doc(widget.storyId).collection("comments").add({
        "comment": commentController.text.trim(),
        'userId': getUserID(),
        "username": Provider.of<UserProvider>(context, listen: false).name,
        "timestamp": DateTime.now(),
      });
      // add comment to list
      commentController.clear();
      _commentFocusNode.unfocus();
    } catch (e) {
      log(e.toString());
      showToast("Error saving comment");
    }
  }

  showComments() {
    String? storyId = widget.storyId?.trim();
    log('storyID:$storyId');
    return StreamBuilder<QuerySnapshot>(
      stream: storiesCollection
          .doc(storyId)
          .collection("comments")
          .orderBy("timestamp", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.docs.length == 0) {
            return Center(
              child: Text("No comments"),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              String commentID = snapshot.data!.docs[index].id;
              return commentTile(snapshot.data!.docs[index], commentID);
            },
          );
        } else {
          return Center(
            child: showDotIndicator(color: black),
          );
        }
      },
    );
  }

  bool showReplyField = false;
  commentTile(document, String commentID) {
    String time = getTime(document.data()["timestamp"]);
    log('commentID:$commentID');

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setMyState) {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage('assets/images/avatar.png'),
            backgroundColor: Colors.white,
          ),
          title: Text(
            document.data()["username"],
            style: TextStyle(
              // fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                document.data()["comment"],
                textAlign: TextAlign.start,
                style: TextStyle(
                    // fontSize: 15.0,
                    ),
              ),
              const SizedBox(height: 5),
              showReplyField == false
                  ? Row(
                      children: [
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          child: Text(
                            'Reply',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            setMyState(() {
                              showReplyField = true;
                              log('show reply field bool is: $showReplyField');
                            });
                          },
                        ),
                      ],
                    )
                  : buildCommentField(
                      controller: replyController,
                      focusNode: _replyFocusNode,
                      onPressed: () async {
                        saveReply(commentID, setMyState);
                      },
                      hint: "Reply to ${document.data()["username"]}",
                    ),
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  showReplyComments(
                    commentID,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  commentReplyTile(
    document,
  ) {
    String time = getTime(document.data()["timestamp"]);

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setMyState) {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage('assets/images/avatar.png'),
            backgroundColor: Colors.white,
          ),
          title: Text(
            document.data()["username"] ?? "Anonymous",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                document.data()["comment"],
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void saveReply(String commentID, StateSetter setter) async {
    try {
      if (replyController.text.isEmpty) {
        showToast("Please enter a comment");
        return;
      }
      final String replyComment = replyController.text.trim();
      setter(() {
        replyController.clear();
        showReplyField = false;
      });
      await storiesCollection
          .doc(widget.storyId)
          .collection("comments")
          .doc(commentID)
          .collection("replies")
          .add({
        "comment": replyComment,
        'userID': getUserID(),
        "username": Provider.of<UserProvider>(context, listen: false).name,
        "timestamp": DateTime.now(),
      });
    } catch (e) {
      showToast("Error: $e");
      log("Error: $e");
    }
  }

  showReplyComments(
    commentId,
  ) {
    //  return stream builder showing reply comments from comments collection
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: storiesCollection
            .doc(widget.storyId)
            .collection("comments")
            .doc(commentId)
            .collection("replies")
            .orderBy("timestamp", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return commentReplyTile(
                  snapshot.data!.docs[index],
                );
              },
            );
          } else {
            return Center(
              child: showDotIndicator(color: black),
            );
          }
        },
      ),
    );
  }

  getUserID() {
    // get userID from user provider
    return Provider.of<UserProvider>(context, listen: false).id;
  }
}
