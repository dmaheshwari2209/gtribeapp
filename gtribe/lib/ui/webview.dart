import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Webview extends StatelessWidget {
  const Webview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
          WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: 'https://www.chess.com/play',
            onPageFinished: (String url) {},
          ),
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: GestureDetector(
              onTap: () {
                log('[message]');
              },
              child: const CircleAvatar(
                radius: 30,
                child: Icon(Icons.abc),
              ),
            ),
          )
        ],
      ),
    );
  }
}
