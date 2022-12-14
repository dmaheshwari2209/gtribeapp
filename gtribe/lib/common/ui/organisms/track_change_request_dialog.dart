// Package imports
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gtribe/data_store/meeting_store_broadcast.dart';

// Project imports
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:gtribe/common/util/app_color.dart';
import 'package:gtribe/enum/meeting_mode.dart';
import 'package:gtribe/hls-streaming/util/hls_title_text.dart';

import '../../../data_store/meeting_store.dart';

class TrackChangeDialogOrganism extends StatefulWidget {
  final HMSTrackChangeRequest trackChangeRequest;
  final MeetingStore? meetingStore;
  final MeetingStoreBroadcast? meetingStoreBroadcast;
  final bool isAudioModeOn;
  final bool isBroadcast;
  const TrackChangeDialogOrganism(
      {required this.trackChangeRequest,
      this.meetingStore,
      this.meetingStoreBroadcast,
      this.isAudioModeOn = false,
      required this.isBroadcast})
      : super();

  @override
  _RoleChangeDialogOrganismState createState() =>
      _RoleChangeDialogOrganismState();
}

class _RoleChangeDialogOrganismState extends State<TrackChangeDialogOrganism> {
  @override
  Widget build(BuildContext context) {
    String message =
        "‘${widget.trackChangeRequest.requestBy.name}’ requested to ${(widget.trackChangeRequest.mute) ? "mute" : "unmute"} your ‘${(widget.trackChangeRequest.track.kind == HMSTrackKind.kHMSTrackKindAudio) ? "Audio’" : "Video’"}${(widget.isAudioModeOn) ? " and switch to video view" : ""}";
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      actionsPadding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      backgroundColor: themeBottomSheetColor,
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: GoogleFonts.inter(
                color: iconColor,
              ),
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                  shadowColor: MaterialStateProperty.all(themeSurfaceColor),
                  backgroundColor:
                      MaterialStateProperty.all(themeBottomSheetColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: popupButtonBorderColor),
                    borderRadius: BorderRadius.circular(8.0),
                  ))),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12),
                child:
                    HLSTitleText(text: 'Reject', textColor: themeDefaultColor),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                  shadowColor: MaterialStateProperty.all(themeSurfaceColor),
                  backgroundColor: MaterialStateProperty.all(errorColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: errorColor),
                    borderRadius: BorderRadius.circular(8.0),
                  ))),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12),
                child: HLSTitleText(
                  text: 'Accept',
                  textColor: themeDefaultColor,
                ),
              ),
              onPressed: () {
                if (widget.trackChangeRequest.track.kind ==
                        HMSTrackKind.kHMSTrackKindVideo &&
                    widget.isAudioModeOn) {
                  if (widget.meetingStore != null) {
                    widget.meetingStore!.setMode(MeetingMode.Video);
                  } else {
                    widget.meetingStoreBroadcast!.setMode(MeetingMode.Video);
                  }
                }
                if (widget.meetingStore != null) {
                  widget.meetingStore!.changeTracks(widget.trackChangeRequest);
                } else {
                  widget.meetingStoreBroadcast!
                      .changeTracks(widget.trackChangeRequest);
                }
                Navigator.pop(context);
              },
            ),
          ],
        )
      ],
    );
  }
}
