//Dart imports
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gtribe/common/ui/screens/entry_screen.dart';
import 'package:gtribe/common/util/app_color.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';
import 'package:uni_links/uni_links.dart';

//Project imports
import 'common/ui/screens/home_screen.dart';
import 'common/util/utility_function.dart';
import 'constants.dart';

bool _initialURILinkHandled = false;
StreamSubscription? _streamSubscription;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Wakelock.enable();
  Provider.debugCheckInvalidValueType = null;

  SharedPreferences pref = await SharedPreferences.getInstance();
  String? str = pref.getString(USERNAME);
  if (str != null) {
    Utilities.userName = str;
  }

  runApp(const HMSExampleApp());
}

class HMSExampleApp extends StatefulWidget {
  final Uri? initialLink;
  const HMSExampleApp({Key? key, this.initialLink}) : super(key: key);

  @override
  _HMSExampleAppState createState() => _HMSExampleAppState();
  static _HMSExampleAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_HMSExampleAppState>()!;
}

class _HMSExampleAppState extends State<HMSExampleApp> {
  ThemeMode _themeMode = ThemeMode.dark;
  Uri? _currentURI;
  bool isDarkMode =
      WidgetsBinding.instance.window.platformBrightness == Brightness.dark;

  final ThemeData _darkTheme = ThemeData(
      bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: themeBottomSheetColor, elevation: 5),
      brightness: Brightness.dark,
      primaryColor: const Color.fromARGB(255, 13, 107, 184),
      backgroundColor: Colors.black,
      scaffoldBackgroundColor: Colors.black);

  final ThemeData _lightTheme = ThemeData(
    bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: themeDefaultColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5),
    primaryTextTheme: TextTheme(bodyText1: TextStyle(color: themeSurfaceColor)),
    primaryColor: hmsdefaultColor,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    backgroundColor: Colors.white,
    dividerColor: Colors.white54,
  );

  @override
  void initState() {
    super.initState();
    _initURIHandler();
    _incomingLinkHandler();
    initDynamicLinks();
    setThemeMode();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  Future<void> _initURIHandler() async {
    if (!_initialURILinkHandled) {
      _initialURILinkHandled = true;
      try {
        if (widget.initialLink != null) {
          return;
        }
        _currentURI = await getInitialUri();
        if (_currentURI != null) {
          if (!mounted) {
            return;
          }
          setState(() {});
        }
      } on PlatformException {
        debugPrint("Failed to receive initial uri");
      } on FormatException {
        if (!mounted) {
          return;
        }
      }
    }
  }

  void _incomingLinkHandler() {
    if (!kIsWeb) {
      _streamSubscription = uriLinkStream.listen((Uri? uri) {
        if (!mounted) {
          return;
        }
        if (uri == null || !uri.toString().contains("100ms.live")) {
          return;
        }
        setState(() {
          _currentURI = uri;
        });
        String tempUri = uri.toString();
        if (tempUri.contains("deep_link_id")) {
          setState(() {
            _currentURI =
                Uri.parse(Utilities.fetchMeetingLinkFromFirebase(tempUri));
          });
        }
      }, onError: (Object err) {
        if (!mounted) {
          return;
        }
      });
    }
  }

  Future<void> initDynamicLinks() async {
    // FirebaseDynamicLinks.instance.onLink
    //     .listen((PendingDynamicLinkData dynamicLinkData) {
    //   if (!mounted) {
    //     return;
    //   }
    //   if (dynamicLinkData.link.toString().length == 0) {
    //     return;
    //   }
    //   setState(() {
    //     _currentURI = dynamicLinkData.link;
    //   });
    // }).onError((error) {
    //   print('onLink error');
    //   print(error.message);
    // });

    if (widget.initialLink != null) {
      _currentURI = widget.initialLink;
      setState(() {});
    }
  }

  void setThemeMode() async {
    _themeMode = await Utilities.getBoolData(key: "dark-mode") ?? true
        ? ThemeMode.dark
        : ThemeMode.light;
    if (_themeMode == ThemeMode.light) {
      changeTheme(_themeMode);
    }
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Utilities.userName == null
          ? const EntryScreen()
          : HomePage(
              deepLinkURL: _currentURI == null ? null : _currentURI.toString(),
            ),
      theme: _lightTheme,
      darkTheme: _darkTheme,
      themeMode: _themeMode,
    );
  }

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
      isDarkMode = themeMode == ThemeMode.dark;
      updateColor(_themeMode);
    });
  }
}
