// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:gtribe/common/util/app_color.dart';
// import 'package:gtribe/enum/meeting_mode.dart';
// import 'package:gtribe/data_store/meeting_store.dart';
// import 'package:provider/provider.dart';

// class MeetingModeSheet extends StatefulWidget {
//   const MeetingModeSheet({
//     Key? key,
//   }) : super(key: key);
//   @override
//   State<MeetingModeSheet> createState() => _MeetingModeSheetState();
// }

// class _MeetingModeSheetState extends State<MeetingModeSheet> {
//   GlobalKey? dropdownKey;

//   @override
//   void initState() {
//     super.initState();
//     dropdownKey = GlobalKey();
//   }

//   @override
//   Widget build(BuildContext context) {
//     MeetingStore meetingStore = context.read<MeetingStore>();
//     return FractionallySizedBox(
//       heightFactor: 0.6,
//       child: Padding(
//           padding: const EdgeInsets.only(top: 20.0, left: 15, right: 15),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 18,
//                     backgroundColor: borderColor,
//                     child: IconButton(
//                       icon: Icon(
//                         Icons.arrow_back_ios_new,
//                         size: 16,
//                         color: themeDefaultColor,
//                       ),
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                     ),
//                   ),
//                   Expanded(
//                     child: Text(
//                       "Meeting Modes",
//                       textAlign: TextAlign.center,
//                       style: GoogleFonts.inter(
//                           fontSize: 16,
//                           color: themeDefaultColor,
//                           letterSpacing: 0.15,
//                           fontWeight: FontWeight.w600),
//                     ),
//                   ),
//                   IconButton(
//                     icon: SvgPicture.asset(
//                       "assets/icons/close_button.svg",
//                       width: 40,
//                     ),
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                   ),
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 15, bottom: 10),
//                 child: Divider(
//                   color: dividerColor,
//                   height: 5,
//                 ),
//               ),
//               Expanded(
//                 child: ListView(
//                   children: [
//                     ListTile(
//                       horizontalTitleGap: 2,
//                       onTap: () async {
//                         if (meetingStore.meetingMode != MeetingMode.Video ||
//                             meetingStore.isActiveSpeakerMode) {
//                           meetingStore.unMuteRoomVideoLocally();
//                         }
//                         meetingStore.setMode(MeetingMode.Video);
//                         Navigator.pop(context);
//                       },
//                       contentPadding: EdgeInsets.zero,
//                       leading: SvgPicture.asset(
//                         "assets/icons/role_change.svg",
//                         semanticsLabel: "fl_normal_mode",
//                         color: (meetingStore.meetingMode == MeetingMode.Video &&
//                                 !meetingStore.isActiveSpeakerMode)
//                             ? errorColor
//                             : themeDefaultColor,
//                         fit: BoxFit.scaleDown,
//                       ),
//                       title: Text(
//                         "Normal Mode",
//                         style: GoogleFonts.inter(
//                             fontSize: 14,
//                             color: (meetingStore.meetingMode ==
//                                         MeetingMode.Video &&
//                                     !meetingStore.isActiveSpeakerMode)
//                                 ? errorColor
//                                 : themeDefaultColor,
//                             letterSpacing: 0.25,
//                             fontWeight: FontWeight.w600),
//                       ),
//                     ),
//                     ListTile(
//                       horizontalTitleGap: 2,
//                       onTap: () async {
//                         if (meetingStore.meetingMode == MeetingMode.Audio) {
//                           meetingStore.unMuteRoomVideoLocally();
//                         }
//                         if (!meetingStore.isActiveSpeakerMode) {
//                           meetingStore.setActiveSpeakerMode();
//                         }
//                         Navigator.pop(context);
//                       },
//                       contentPadding: EdgeInsets.zero,
//                       leading: SvgPicture.asset(
//                         "assets/icons/participants.svg",
//                         semanticsLabel: "fl_active_speaker_mode",
//                         color: meetingStore.isActiveSpeakerMode
//                             ? errorColor
//                             : themeDefaultColor,
//                         fit: BoxFit.scaleDown,
//                       ),
//                       title: Text(
//                         "Active Speaker Mode",
//                         style: GoogleFonts.inter(
//                             fontSize: 14,
//                             color: meetingStore.isActiveSpeakerMode
//                                 ? errorColor
//                                 : themeDefaultColor,
//                             letterSpacing: 0.25,
//                             fontWeight: FontWeight.w600),
//                       ),
//                     ),
//                     ListTile(
//                       horizontalTitleGap: 2,
//                       onTap: () async {
//                         if (meetingStore.meetingMode != MeetingMode.Audio) {
//                           meetingStore.setMode(MeetingMode.Audio);
//                         }
//                         Navigator.pop(context);
//                       },
//                       contentPadding: EdgeInsets.zero,
//                       leading: SvgPicture.asset(
//                         'assets/icons/mic_state_on.svg',
//                         color: meetingStore.meetingMode == MeetingMode.Audio
//                             ? errorColor
//                             : themeDefaultColor,
//                         semanticsLabel: "fl_audio_video_view",
//                         fit: BoxFit.scaleDown,
//                       ),
//                       title: Text(
//                         "Audio View",
//                         semanticsLabel: "fl_audio_video_mode",
//                         style: GoogleFonts.inter(
//                             fontSize: 14,
//                             color: meetingStore.meetingMode == MeetingMode.Audio
//                                 ? errorColor
//                                 : themeDefaultColor,
//                             letterSpacing: 0.25,
//                             fontWeight: FontWeight.w600),
//                       ),
//                     ),
//                     ListTile(
//                       horizontalTitleGap: 2,
//                       onTap: () async {
//                         if (meetingStore.meetingMode == MeetingMode.Audio) {
//                           meetingStore.unMuteRoomVideoLocally();
//                         }
//                         if (meetingStore.meetingMode != MeetingMode.Hero) {
//                           meetingStore.setMode(MeetingMode.Hero);
//                         }
//                         Navigator.pop(context);
//                       },
//                       contentPadding: EdgeInsets.zero,
//                       leading: SvgPicture.asset(
//                         "assets/icons/participants.svg",
//                         semanticsLabel: "fl_hero_mode",
//                         color: meetingStore.meetingMode == MeetingMode.Hero
//                             ? errorColor
//                             : themeDefaultColor,
//                         fit: BoxFit.scaleDown,
//                       ),
//                       title: Text(
//                         "Hero Mode",
//                         style: GoogleFonts.inter(
//                             fontSize: 14,
//                             color: meetingStore.meetingMode == MeetingMode.Hero
//                                 ? errorColor
//                                 : themeDefaultColor,
//                             letterSpacing: 0.25,
//                             fontWeight: FontWeight.w600),
//                       ),
//                     ),
//                     ListTile(
//                       horizontalTitleGap: 2,
//                       onTap: () async {
//                         if (meetingStore.meetingMode == MeetingMode.Audio) {
//                           meetingStore.unMuteRoomVideoLocally();
//                         }
//                         if (meetingStore.meetingMode != MeetingMode.Single) {
//                           meetingStore.setMode(MeetingMode.Single);
//                         }
//                         Navigator.pop(context);
//                       },
//                       contentPadding: EdgeInsets.zero,
//                       leading: SvgPicture.asset(
//                         "assets/icons/single_tile.svg",
//                         semanticsLabel: "fl_single_mode",
//                         color: meetingStore.meetingMode == MeetingMode.Single
//                             ? errorColor
//                             : themeDefaultColor,
//                         fit: BoxFit.scaleDown,
//                       ),
//                       title: Text(
//                         "Single Tile Mode",
//                         style: GoogleFonts.inter(
//                             fontSize: 14,
//                             color:
//                                 meetingStore.meetingMode == MeetingMode.Single
//                                     ? errorColor
//                                     : themeDefaultColor,
//                             letterSpacing: 0.25,
//                             fontWeight: FontWeight.w600),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           )),
//     );
//   }
// }
