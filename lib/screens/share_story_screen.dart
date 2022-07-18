import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:login/constants/instances.dart';
import 'package:login/util/theme_data.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zefyrka/zefyrka.dart';

import '../constants/indicator.dart';
import '../models/user_provider.dart';
import '../util/custom_switch.dart';

class ShareStory extends StatefulWidget {
  const ShareStory({Key? key}) : super(key: key);

  @override
  State<ShareStory> createState() => _ShareStoryState();
}

class _ShareStoryState extends State<ShareStory> {
  ZefyrController _controller = ZefyrController();
  bool isAnonymous = false;
  final TextEditingController headingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool uploading = false;

  Future<void> _getFromFirebase() async {
    try {
      final document =
          await storiesCollection.doc('21jJKchZh9DbJbfF2mg2').get();
      final data = document.data();
      final heading = data!['heading'];
      final story = data['story'];
      headingController.text = heading;
      // convert story to json
      final storyJson = await json.decode(story);
      // set _controller to the story
      final document2 = await NotusDocument.fromJson(storyJson);
      // final doc = NotusDocument()..insert(0, 'Here goes your story..');
      setState(() {
        _controller = ZefyrController(document2);
      });
      // _controller.document = NotusDocument.fromJson(jsonDecode(content));
      // final doc = NotusDocument.fromJson(jsonDecode(result));
      // setState(() {
      //   _controller = ZefyrController(doc);
      // });
    } catch (error) {
      log('error: $error');
      showToast('Error: $error');
    }
  }

  uploadDataToFirebase() async {
    // lenght of story
    try {
      setState(() {
        uploading = true;
      });
      final length = await _controller.document.toString().trim().length;
      final heading = await headingController.text.trim();
      final contents = await jsonEncode(_controller.document);
      final doc = await contents.toString();
      UserProvider userProvider =
          await Provider.of<UserProvider>(context, listen: false);

      final userId = userProvider.id;
      final userName = userProvider.name;
      final email = userProvider.email;
      await storiesCollection.add({
        'length': length,
        'heading': heading,
        'story': doc,
        'isAnonymous': isAnonymous,
        'userId': userId,
        'userName': userName,
        'email': email,
        'timestamp': DateTime.now(),
      });
      setState(() {
        uploading = false;
      });
      showToast('Story uploaded successfully!');
    } catch (error) {
      setState(() {
        uploading = false;
      });
      log('error: $error');
      showToast('Error uploading story');
    }
  }

  @override
  void initState() {
    _getFromFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _controller == null
        ? CircularProgressIndicator()
        : SafeArea(
            child: Scaffold(
              body: Row(
                children: [
                  EditorColumn(context),
                  HelpColumn(),
                ],
              ),
            ),
          );
  }

  Expanded HelpColumn() {
    return Expanded(
      flex: 2,
      child: Container(
        decoration: BoxDecoration(
          color: white,
          border: Border(
            left: BorderSide(color: Colors.grey.shade400, width: 1),
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            const SizedBox(
              height: 30,
            ),
            buildFieldTitle(text: '*Note*', color: blue),
            const SizedBox(height: 10.0),
            pleaseNoteText(),
            buildFieldTitle(text: 'Some Helpful Tips', color: blue),
            const SizedBox(height: 16.0),
            buildHelpText(
              text: '1. Write your story in the editor.',
            ),
            buildHelpText(
              text:
                  "2. If you don't want to share your identity, you can share you story by going anonymous.Hence you can share your story without any identity.",
            ),
            buildHelpText(
              text: '3. Click on the share button to share your story.',
            ),
            buildHelpText(
              text: '4. Only post your story if you are sure it is accurate.',
            ),
            const SizedBox(
              height: 8,
            ),
            contactUsText(),
          ],
        ),
      ),
    );
  }

  RichText pleaseNoteText() {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontFamily: 'Satoshi',
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
        ),
        children: [
          TextSpan(
            text:
                'Please note that story that is not related to any kind of addiction is not allowed.\nIt will be deleted immediately.\n\n',
          ),
        ],
      ),
    );
  }

  RichText contactUsText() {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontFamily: 'Satoshi',
          color: Colors.grey.shade600,
        ),
        children: [
          TextSpan(
            text:
                '5. If you have any questions or facing any issues, please contact us at ',
          ),
          TextSpan(
            text: '@harshlohia26@gmail.com ',
            style: TextStyle(
              color: blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Padding buildHelpText({required String text}) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.0,
          letterSpacing: 0.5,
          wordSpacing: 1.0,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }

  void _setAnonymousValue(bool value) {
    setState(() => isAnonymous = value);
    log('isAnonymous: $value');
    showToast(
      'Your identity is now ${isAnonymous ? 'anonymous' : 'not anonymous'}',
    );
  }

  Expanded EditorColumn(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              buildFieldTitle(text: 'Add Title Of Your Story'),
              const SizedBox(
                height: 16.0,
              ),
              TextField(
                decoration: InputDecoration(
                  fillColor: appGreyblue,
                  border: OutlineInputBorder(),
                  hintText: 'Here Goes Your Title..',
                ),
                maxLines: null,
                controller: headingController,
              ),
              const SizedBox(
                height: 24.0,
              ),
              buildFieldTitle(text: 'Write Your Story'),
              const SizedBox(
                height: 16.0,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xffcfd9f1),
                  borderRadius: BorderRadius.circular(
                    10.0,
                  ),
                  boxShadow: shadow,
                ),
                child: ZefyrToolbar.basic(
                  controller: _controller,
                  hideCodeBlock: true,
                  hideStrikeThrough: true,
                  hideHeadingStyle: true,
                  hideUnderLineButton: true,
                  hideHorizontalRule: true,
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Container(
                  decoration: kFieldDecoration,
                  padding: EdgeInsets.all(10),
                  child: ZefyrEditor(
                    focusNode: _focusNode,
                    controller: _controller,
                    onLaunchUrl: (String url) async {
                      const url = "https://flutter.io";
                      if (await canLaunch(url))
                        await launch(url);
                      else
                        // can't launch url, there is some error
                        throw "Could not launch $url";
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              Row(
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            'Anonymous',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              color: blue,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        CustomSwitch(
                          value: isAnonymous,
                          onChanged: _setAnonymousValue,
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          uploadDataToFirebase();
                        },
                        child: uploading
                            ? dotIndicator
                            : Text(
                                'Share',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.deepPurple,
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              24.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Text buildFieldTitle({required String text, Color? color}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: color ?? blue,
        shadows: <Shadow>[
          Shadow(
            offset: Offset(5.0, 5.0),
            blurRadius: 3.0,
            color: Colors.grey.shade400,
          ),
          Shadow(
            offset: Offset(5.0, 5.0),
            blurRadius: 8.0,
            color: Colors.grey.shade400,
          ),
        ],
      ),
    );
  }
}
