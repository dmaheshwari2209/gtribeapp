// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:gtribe/common/ui/modal_sheets/stats_modal.dart';
import 'package:provider/provider.dart';

import '../../../data_store/meeting_store.dart';
import '../../../enum/meeting_flow.dart';
import '../../../hls-streaming/hls_screen_controller.dart';
import '../../../hms_sdk_interactor.dart';
import '../../../preview/preview_details.dart';
import '../../util/utility_function.dart';

class ViewerPage extends StatelessWidget {
  const ViewerPage({
    Key? key,
    required this.meetingLink,
    required this.meetingFlow,
  }) : super(key: key);
  final String meetingLink;
  final MeetingFlow meetingFlow;

  void joinMeeting(BuildContext context) {
    // MeetingStore meetingStore = context.read<MeetingStore>();
    // meetingStore.leave();
    String url =
        'https://flutterhms.page.link/ARnn2FMfXCdk3S157?meetingUrl=https://gtribe.app.100ms.live/streaming/meeting/slx-sip-xan';
    // if (meetingLinkController.text.isEmpty) {
    //   return;
    // }
    FocusManager.instance.primaryFocus?.unfocus();
    Utilities.setRTMPUrl(url);
    MeetingFlow flow = Utilities.deriveFlow(url);
    if (flow == MeetingFlow.meeting || flow == MeetingFlow.hlsStreaming) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PreviewDetails(
            // key: UniqueKey(),
            autofocusField: true,
            meetingLink: url.trim(),
            meetingFlow: flow,
          ),
        ),
      );
    } else {
      // Utilities.showToast("Please enter valid url");
    }
  }

  void showNudge(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return const StatsModal();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    HMSSDKInteractor hmsSDKInteractor = HMSSDKInteractor(
        appGroup: "group.flutterhms",
        preferredExtension:
            "live.100ms.flutter.FlutterBroadcastUploadExtension",
        joinWithMutedAudio: true,
        joinWithMutedVideo: true,
        isSoftwareDecoderDisabled: true,
        isAudioMixerDisabled: true);
    return ListenableProvider.value(
      value: MeetingStore(hmsSDKInteractor: hmsSDKInteractor),
      child: Builder(builder: (context) {
        return Stack(
          alignment: Alignment.bottomRight,
          children: [
            // WebView(
            //   javascriptMode: JavascriptMode.unrestricted,
            //   initialUrl: 'https://www.chess.com/play',
            //   onPageFinished: (String url) {},
            // ),
            HLSScreenController(
              isBroadcast: false,
              isRoomMute: false,
              isStreamingLink:
                  meetingFlow == MeetingFlow.meeting ? false : true,
              isAudioOn: true,
              meetingLink: meetingLink,
              localPeerNetworkQuality: -1,
              user: Utilities.userName ?? 'user',
              mirrorCamera: false,
              showStats: false,
            ),
            Padding(
              padding: const EdgeInsets.all(50),
              child: GestureDetector(
                onTap: () {
                  // joinMeeting(context);
                  showNudge(context);
                },
                child: const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.amberAccent,
                  child: Icon(Icons.play_arrow),
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
