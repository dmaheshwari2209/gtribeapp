import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gtribe/common/ui/screens/viewer_page.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../logs/custom_singleton_logger.dart';
import '../../util/utility_function.dart';

class HomePage extends StatefulWidget {
  final String? deepLinkURL;

  const HomePage({Key? key, this.deepLinkURL}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
  static _HomePageState of(BuildContext context) =>
      context.findAncestorStateOfType<_HomePageState>()!;
}

class _HomePageState extends State<HomePage> {
  TextEditingController meetingLinkController = TextEditingController();
  CustomLogger logger = CustomLogger();

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    logger.getCustomLogger();
    _initPackageInfo();
    getData();
  }

  void getData() async {
    String savedMeetingUrl = await Utilities.getStringData(key: 'meetingLink');
    if (widget.deepLinkURL == null && savedMeetingUrl.isNotEmpty) {
      meetingLinkController.text = savedMeetingUrl;
    } else {
      meetingLinkController.text = widget.deepLinkURL ?? "";
    }
  }

  Future<bool> _closeApp() {
    CustomLogger.file?.delete();
    return Future.value(true);
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    if (widget.deepLinkURL != null) {
      meetingLinkController.text = widget.deepLinkURL!;
    }
    super.didUpdateWidget(oldWidget);
  }

  // Future<dynamic> data;

  // void initData() {
  //   data = GameApi().viewGame(viewername, playername);
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String meetingURL =
        'https://gtribe.app.100ms.live/streaming/meeting/bta-hqq-jto';
    return WillPopScope(
      onWillPop: _closeApp,
      child: SafeArea(
        child: Scaffold(
          body: SizedBox(
              width: size.width,
              height: size.height,
              child: Builder(
                  // future: ,
                  builder: (context) {
                return PageView.builder(
                  pageSnapping: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return ViewerPage(
                      key: UniqueKey(),
                      meetingLink: meetingURL,
                      meetingFlow: Utilities.deriveFlow(meetingURL),
                    );
                  },
                  itemCount: 5,
                );
              })),
        ),
      ),
    );
  }
}
