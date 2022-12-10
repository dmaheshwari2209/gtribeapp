// ignore_for_file: public_member_api_docs, sort_constructors_first
//Package imports

import 'package:flutter/material.dart';
import 'package:gtribe/data_store/meeting_store_broadcast.dart';
import 'package:pip_flutter/pipflutter_player.dart';
import 'package:pip_flutter/pipflutter_player_controller.dart';
import 'package:provider/provider.dart';

import '../data_store/meeting_store.dart';

//Project imports

class HLSPlayer extends StatefulWidget {
  final String streamUrl;
  final bool isBroadcast;

  const HLSPlayer({
    Key? key,
    required this.streamUrl,
    required this.isBroadcast,
  }) : super(key: key);

  @override
  _HLSPlayerState createState() => _HLSPlayerState();
}

class _HLSPlayerState extends State<HLSPlayer> with TickerProviderStateMixin {
  late AnimationController animation;
  late Animation<double> fadeInFadeOut;

  @override
  void initState() {
    super.initState();
    animation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    fadeInFadeOut = Tween<double>(begin: 0.0, end: 1).animate(animation);

    if (widget.isBroadcast) {
      context
          .read<MeetingStoreBroadcast>()
          .setPIPVideoController(widget.streamUrl, false);
    } else {
      context
          .read<MeetingStore>()
          .setPIPVideoController(widget.streamUrl, false);
    }
    animation.forward();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isBroadcast) {
      return Selector<MeetingStoreBroadcast, PipFlutterPlayerController?>(
          selector: (_, meetingStore) => meetingStore.hlsVideoController,
          builder: (_, controller, __) {
            if (controller == null) {
              return const Scaffold();
            }
            return Scaffold(
                key: GlobalKey(),
                body: Stack(
                  children: [
                    Center(
                        child: FadeTransition(
                      opacity: fadeInFadeOut,
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: PipFlutterPlayer(
                          controller: controller,
                          key: context
                              .read<MeetingStoreBroadcast>()
                              .pipFlutterPlayerKey,
                        ),
                      ),
                    )),
                    if (!context.read<MeetingStoreBroadcast>().isPipActive)
                      Positioned(
                        bottom: 10,
                        right: 20,
                        child: GestureDetector(
                          onTap: () {
                            animation.reverse();
                            context
                                .read<MeetingStoreBroadcast>()
                                .setPIPVideoController(widget.streamUrl, true);
                            animation.forward();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.circle,
                                    color: Colors.red,
                                    size: 15,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Go Live",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )
                                ]),
                          ),
                        ),
                      )
                  ],
                ));
          });
    } else {
      return Selector<MeetingStore, PipFlutterPlayerController?>(
          selector: (_, meetingStore) => meetingStore.hlsVideoController,
          builder: (_, controller, __) {
            if (controller == null) {
              return const Scaffold();
            }
            return Scaffold(
                key: GlobalKey(),
                body: Stack(
                  children: [
                    Center(
                        child: FadeTransition(
                      opacity: fadeInFadeOut,
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: PipFlutterPlayer(
                          controller: controller,
                          key: context.read<MeetingStore>().pipFlutterPlayerKey,
                        ),
                      ),
                    )),
                    if (!context.read<MeetingStore>().isPipActive)
                      Positioned(
                        bottom: 10,
                        right: 20,
                        child: GestureDetector(
                          onTap: () {
                            animation.reverse();
                            context
                                .read<MeetingStore>()
                                .setPIPVideoController(widget.streamUrl, true);
                            animation.forward();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.circle,
                                    color: Colors.red,
                                    size: 15,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Go Live",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )
                                ]),
                          ),
                        ),
                      )
                  ],
                ));
          });
    }
  }
}
