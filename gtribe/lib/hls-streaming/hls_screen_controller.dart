import 'package:flutter/material.dart';
import 'package:gtribe/data_store/meeting_store_broadcast.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:gtribe/hls-streaming/hls_broadcaster_page.dart';
import 'package:gtribe/hls-streaming/hls_viewer_page.dart';
import 'package:provider/provider.dart';

import '../data_store/meeting_store.dart';

class HLSScreenController extends StatefulWidget {
  final String meetingLink;
  final String user;
  final bool isAudioOn;
  final int? localPeerNetworkQuality;
  final bool isStreamingLink;
  final bool isRoomMute;
  final bool showStats;
  final bool mirrorCamera;
  final String? streamUrl;
  final HMSRole? role;
  final bool isBroadcast;
  const HLSScreenController({
    Key? key,
    required this.meetingLink,
    required this.user,
    required this.isAudioOn,
    required this.localPeerNetworkQuality,
    this.isStreamingLink = false,
    this.isRoomMute = false,
    this.showStats = false,
    this.mirrorCamera = true,
    this.streamUrl,
    this.role,
    required this.isBroadcast,
  }) : super(key: key);

  @override
  State<HLSScreenController> createState() => _HLSScreenControllerState();
}

class _HLSScreenControllerState extends State<HLSScreenController> {
  @override
  void initState() {
    super.initState();
    if (widget.isBroadcast) {
      initMeetingBroadcast();
    } else {
      initMeeting();
    }

    if (widget.isBroadcast) {
      setInitValuesBroadcast();
    } else {
      setInitValues();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (widget.isBroadcast) {
      context.read<MeetingStoreBroadcast>().leave();
    } else {
      context.read<MeetingStore>().leave();
    }
    super.dispose();
  }

  void initMeeting() async {
    bool ans = await context
        .read<MeetingStore>()
        .join(widget.user, widget.meetingLink);
    if (!ans) {
      // Utilities.showToast("Unable to Join");
      Navigator.of(context).pop();
    }
  }

  void initMeetingBroadcast() async {
    bool ans = await context
        .read<MeetingStoreBroadcast>()
        .join(widget.user, widget.meetingLink);
    if (!ans) {
      // Utilities.showToast("Unable to Join");
      Navigator.of(context).pop();
    }
  }

  void setInitValues() async {
    context.read<MeetingStore>().localPeerNetworkQuality =
        widget.localPeerNetworkQuality;
    context.read<MeetingStore>().setSettings();
  }

  void setInitValuesBroadcast() async {
    context.read<MeetingStoreBroadcast>().localPeerNetworkQuality =
        widget.localPeerNetworkQuality;
    context.read<MeetingStoreBroadcast>().setSettings();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isBroadcast) {
      return HLSViewerPage(
        streamUrl: widget.streamUrl,
      );
    } else {
      return HLSBroadcasterPage(
        isStreamingLink: widget.isStreamingLink,
        meetingLink: widget.meetingLink,
        isAudioOn: widget.isAudioOn,
        isRoomMute: widget.isRoomMute,
      );
    }
  }
}
