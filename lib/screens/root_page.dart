import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:login/screens/share_story_screen.dart';
import 'package:login/util/theme_data.dart';
import 'package:login/widgets/responsive.dart';

import 'home_screen.dart';

class RootPage extends StatefulWidget {
  const RootPage({
    Key? key,
  }) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final List<Widget> _screens = [
    HomeScreen(),
    ShareStory(),
  ];
  final List<IconData> _icons = const [
    Icons.home,
    Icons.ondemand_video,
  ];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Container(),
      tablet: Container(),
      desktop: DesktopRootPage(),
    );
  }
}

class DesktopRootPage extends StatefulWidget {
  const DesktopRootPage({Key? key}) : super(key: key);

  @override
  State<DesktopRootPage> createState() => _DesktopRootPageState();
}

class _DesktopRootPageState extends State<DesktopRootPage> {
  final controller = PageController();
  int getPageIndex = 0;
  onTapChangePage(int pageindex) {
    controller.animateToPage(pageindex,
        duration: Duration(milliseconds: 2),
        curve: Curves.fastLinearToSlowEaseIn);
  }

  whenPageChanges(int pageIndex) {
    setState(() {
      this.getPageIndex = pageIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: lightWhite,
        appBar: AppBar(
          title: Text('Fight Addiction'),
        ),
        body: Row(
          children: [
            sideNavigationPanel(),
            Expanded(
              flex: 3,
              child: PageView(
                controller: controller,
                onPageChanged: whenPageChanges,
                children: [
                  HomeScreen(),
                  ShareStory(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded sideNavigationPanel() {
    return Expanded(
      flex: 1,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: shadow,
        ),
        padding: EdgeInsets.only(top: 50),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextTile(
                  index: 0, text: 'Home', iconAsset: 'assets/icons/home.svg'),
              SizedBox(
                height: 30.0,
              ),
              buildTextTile(
                  index: 1,
                  text: 'Share Your Story',
                  iconAsset: 'assets/icons/profile.svg'),
            ],
          ),
        ),
      ),
    );
  }

  ListTile buildTextTile(
      {required String text, required int index, required String iconAsset}) {
    return ListTile(
      leading: SvgPicture.asset(
        iconAsset,
        color: getPageIndex == index ? Colors.blue : Colors.black,
        height: 20,
      ),
      title: Text(
        text,
        style: TextStyle(
          fontSize: 20.0,
          color: getPageIndex == index ? facebookBlue : Colors.grey,
        ),
      ),
      onTap: () {
        setState(
          () {
            getPageIndex = index;
            onTapChangePage(index);
          },
        );
      },
    );
  }
}
