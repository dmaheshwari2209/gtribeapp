import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:gtribe/common/constant.dart';
import 'package:gtribe/common/ui/organisms/share_link_option.dart';
import 'package:gtribe/common/util/app_color.dart';
import 'package:gtribe/common/util/utility_components.dart';
import 'package:gtribe/hls-streaming/bottom_sheets/hls_device_settings.dart';
import 'package:gtribe/hls-streaming/bottom_sheets/hls_start_bottom_sheet.dart';
import 'package:gtribe/hls-streaming/bottom_sheets/meeting_mode_sheet.dart';
import 'package:gtribe/data_store/meeting_store.dart';
import 'package:provider/provider.dart';

class HLSMoreSettings extends StatefulWidget {
  final bool isAudioMixerDisabled;

  const HLSMoreSettings({Key? key, this.isAudioMixerDisabled = true})
      : super(key: key);
  @override
  State<HLSMoreSettings> createState() => _HLSMoreSettingsState();
}

class _HLSMoreSettingsState extends State<HLSMoreSettings> {
  @override
  Widget build(BuildContext context) {
    MeetingStore meetingStore = context.read<MeetingStore>();
    return FractionallySizedBox(
      heightFactor: 0.6,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "More Options",
                      style: GoogleFonts.inter(
                          fontSize: 16,
                          color: themeDefaultColor,
                          letterSpacing: 0.15,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: SvgPicture.asset(
                        "assets/icons/close_button.svg",
                        width: 40,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 10),
              child: Divider(
                color: dividerColor,
                height: 5,
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    horizontalTitleGap: 2,
                    onTap: () async {
                      Navigator.pop(context);
                      if (Platform.isAndroid) {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: themeBottomSheetColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          context: context,
                          builder: (ctx) => ChangeNotifierProvider.value(
                              value: context.read<MeetingStore>(),
                              child: const HLSDeviceSettings()),
                        );
                      } else if (Platform.isIOS) {
                        context.read<MeetingStore>().switchAudioOutput();
                      }
                    },
                    contentPadding: EdgeInsets.zero,
                    leading: SvgPicture.asset(
                      "assets/icons/settings.svg",
                      fit: BoxFit.scaleDown,
                      color: themeDefaultColor,
                    ),
                    title: Text(
                      Platform.isAndroid ? "Device Settings" : "Audio Settings",
                      semanticsLabel: "fl_device_settings",
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          color: themeDefaultColor,
                          letterSpacing: 0.25,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  ListTile(
                    horizontalTitleGap: 2,
                    onTap: () async {
                      Navigator.pop(context);
                      showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: themeBottomSheetColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        context: context,
                        builder: (ctx) => ChangeNotifierProvider.value(
                            value: context.read<MeetingStore>(),
                            child: MeetingModeSheet()),
                      );
                    },
                    contentPadding: EdgeInsets.zero,
                    leading: SvgPicture.asset(
                      "assets/icons/participants.svg",
                      fit: BoxFit.scaleDown,
                      color: themeDefaultColor,
                    ),
                    title: Text(
                      "Meeting mode",
                      semanticsLabel: "fl_meeting_mode",
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          color: themeDefaultColor,
                          letterSpacing: 0.25,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  ListTile(
                    horizontalTitleGap: 2,
                    onTap: () async {
                      Navigator.pop(context);
                      FocusManager.instance.primaryFocus?.unfocus();
                      String name =
                          await UtilityComponents.showNameChangeDialog(
                              context: context,
                              placeholder: "Enter Name",
                              prefilledValue: context
                                      .read<MeetingStore>()
                                      .localPeer
                                      ?.name ??
                                  "");
                      if (name.isNotEmpty) {
                        meetingStore.changeName(name: name);
                      }
                      // Navigator.pop(context);
                    },
                    contentPadding: EdgeInsets.zero,
                    leading: SvgPicture.asset(
                      "assets/icons/pencil.svg",
                      fit: BoxFit.scaleDown,
                      color: themeDefaultColor,
                    ),
                    title: Text(
                      "Change Name",
                      semanticsLabel: "fl_change_name",
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          color: themeDefaultColor,
                          letterSpacing: 0.25,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  ListTile(
                    horizontalTitleGap: 2,
                    onTap: () {
                      meetingStore.toggleSpeaker();
                      Navigator.pop(context);
                    },
                    contentPadding: EdgeInsets.zero,
                    leading: SvgPicture.asset(
                      meetingStore.isSpeakerOn
                          ? "assets/icons/speaker_state_on.svg"
                          : "assets/icons/speaker_state_off.svg",
                      fit: BoxFit.scaleDown,
                      color: themeDefaultColor,
                    ),
                    title: Text(
                      meetingStore.isSpeakerOn ? "Mute Room" : "Unmute Room",
                      semanticsLabel: "fl_mute_room",
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          color: themeDefaultColor,
                          letterSpacing: 0.25,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  ListTile(
                    horizontalTitleGap: 2,
                    onTap: () {
                      meetingStore.switchCamera();
                      Navigator.pop(context);
                    },
                    contentPadding: EdgeInsets.zero,
                    leading: SvgPicture.asset(
                      "assets/icons/camera.svg",
                      fit: BoxFit.scaleDown,
                      color: themeDefaultColor,
                    ),
                    title: Text(
                      "Switch Camera",
                      semanticsLabel: "fl_switch_camera",
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          color: themeDefaultColor,
                          letterSpacing: 0.25,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  ListTile(
                    horizontalTitleGap: 2,
                    onTap: () async {
                      meetingStore.changeMetadataBRB();
                      Navigator.pop(context);
                    },
                    contentPadding: EdgeInsets.zero,
                    leading: SvgPicture.asset(
                      "assets/icons/brb.svg",
                      fit: BoxFit.scaleDown,
                      color: themeDefaultColor,
                    ),
                    title: Text(
                      "BRB",
                      semanticsLabel: "fl_brb_list_tile",
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          color: meetingStore.isBRB
                              ? errorColor
                              : themeDefaultColor,
                          letterSpacing: 0.25,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  ListTile(
                      horizontalTitleGap: 2,
                      onTap: () async {
                        meetingStore.changeStatsVisible();
                        Navigator.pop(context);
                      },
                      contentPadding: EdgeInsets.zero,
                      leading: SvgPicture.asset(
                        "assets/icons/stats.svg",
                        fit: BoxFit.scaleDown,
                        color: themeDefaultColor,
                      ),
                      title: Text(
                        "${meetingStore.isStatsVisible ? "Hide" : "Show"} Stats",
                        semanticsLabel: "fl_stats_list_tile",
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            color: themeDefaultColor,
                            letterSpacing: 0.25,
                            fontWeight: FontWeight.w600),
                      )),
                  if (meetingStore.localPeer?.role.permissions.changeRole ??
                      false)
                    ListTile(
                        horizontalTitleGap: 2,
                        onTap: () async {
                          Navigator.pop(context);
                          List<HMSRole> roles = await meetingStore.getRoles();
                          UtilityComponents.showRoleList(
                              context, roles, meetingStore);
                        },
                        contentPadding: EdgeInsets.zero,
                        leading: SvgPicture.asset(
                          "assets/icons/mic_state_off.svg",
                          fit: BoxFit.scaleDown,
                          color: themeDefaultColor,
                        ),
                        title: Text(
                          "Mute Role",
                          semanticsLabel: "fl_mute_role",
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              color: themeDefaultColor,
                              letterSpacing: 0.25,
                              fontWeight: FontWeight.w600),
                        )),
                  if (!(meetingStore.localPeer?.role.name.contains("hls-") ??
                      true))
                    Selector<MeetingStore, bool>(
                        selector: (_, meetingStore) =>
                            meetingStore.streamingType["rtmp"] ?? false,
                        builder: (_, isRTMPRunning, __) {
                          return ListTile(
                              horizontalTitleGap: 2,
                              onTap: () async {
                                if (isRTMPRunning) {
                                  meetingStore.stopRtmpAndRecording();
                                  Navigator.pop(context);
                                } else {
                                  Navigator.pop(context);
                                  Map<String, dynamic> data =
                                      await UtilityComponents.showRTMPInputDialog(
                                          context: context,
                                          placeholder:
                                              "Enter Comma separated RTMP Urls",
                                          isRecordingEnabled: meetingStore
                                                  .recordingType["browser"] ==
                                              true);
                                  List<String>? urls;
                                  if (data["url"]!.isNotEmpty) {
                                    urls = data["url"]!.split(",");
                                  }
                                  if (urls != null) {
                                    meetingStore.startRtmpOrRecording(
                                        meetingUrl: Constant.streamingUrl,
                                        toRecord: false,
                                        rtmpUrls: urls);
                                  }
                                }
                              },
                              contentPadding: EdgeInsets.zero,
                              leading: SvgPicture.asset(
                                "assets/icons/stream.svg",
                                fit: BoxFit.scaleDown,
                                color: isRTMPRunning
                                    ? errorColor
                                    : themeDefaultColor,
                              ),
                              title: Text(
                                isRTMPRunning ? "Stop RTMP" : "Start RTMP",
                                semanticsLabel: isRTMPRunning
                                    ? "fl_stop_rtmp"
                                    : "fl_start_rtmp",
                                style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: isRTMPRunning
                                        ? errorColor
                                        : themeDefaultColor,
                                    letterSpacing: 0.25,
                                    fontWeight: FontWeight.w600),
                              ));
                        }),
                  if (!(meetingStore.localPeer?.role.name.contains("hls-") ??
                      true))
                    Selector<MeetingStore, bool>(
                        selector: (_, meetingStore) =>
                            meetingStore.recordingType["browser"] ?? false,
                        builder: (_, isBrowserRecording, __) {
                          return ListTile(
                              horizontalTitleGap: 2,
                              onTap: () async {
                                if (isBrowserRecording) {
                                  meetingStore.stopRtmpAndRecording();
                                } else {
                                  meetingStore.startRtmpOrRecording(
                                      meetingUrl: Constant.streamingUrl,
                                      toRecord: true,
                                      rtmpUrls: []);
                                }
                                Navigator.pop(context);
                              },
                              contentPadding: EdgeInsets.zero,
                              leading: SvgPicture.asset(
                                "assets/icons/record.svg",
                                fit: BoxFit.scaleDown,
                                color: isBrowserRecording
                                    ? errorColor
                                    : themeDefaultColor,
                              ),
                              title: Text(
                                isBrowserRecording
                                    ? "Stop Recording"
                                    : "Start Recording",
                                semanticsLabel: isBrowserRecording
                                    ? "fl_stop_recording"
                                    : "fl_start_recording",
                                style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: isBrowserRecording
                                        ? errorColor
                                        : themeDefaultColor,
                                    letterSpacing: 0.25,
                                    fontWeight: FontWeight.w600),
                              ));
                        }),
                  if (!(meetingStore.localPeer?.role.name.contains("hls-") ??
                      true))
                    Selector<MeetingStore, bool>(
                        selector: ((_, meetingStore) =>
                            meetingStore.hasHlsStarted),
                        builder: (_, hasHLSStarted, __) {
                          return ListTile(
                              horizontalTitleGap: 2,
                              onTap: () async {
                                if (hasHLSStarted) {
                                  meetingStore.stopHLSStreaming();
                                  Navigator.pop(context);
                                  return;
                                }
                                Navigator.pop(context);
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: themeBottomSheetColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  context: context,
                                  builder: (ctx) =>
                                      ChangeNotifierProvider.value(
                                          value: context.read<MeetingStore>(),
                                          child: HLSStartBottomSheet()),
                                );
                              },
                              contentPadding: EdgeInsets.zero,
                              leading: SvgPicture.asset(
                                "assets/icons/hls.svg",
                                fit: BoxFit.scaleDown,
                                color: hasHLSStarted
                                    ? errorColor
                                    : themeDefaultColor,
                              ),
                              title: Text(
                                hasHLSStarted ? "Stop HLS" : "Start HLS",
                                semanticsLabel: hasHLSStarted
                                    ? "fl_stop_hls"
                                    : "fl_start_hls",
                                style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: hasHLSStarted
                                        ? errorColor
                                        : themeDefaultColor,
                                    letterSpacing: 0.25,
                                    fontWeight: FontWeight.w600),
                              ));
                        }),
                  if (!(meetingStore.localPeer?.role.name.contains("hls-") ??
                          true) &&
                      !(Platform.isIOS && widget.isAudioMixerDisabled))
                    ListTile(
                        horizontalTitleGap: 2,
                        onTap: () async {
                          Navigator.pop(context);
                          if (Platform.isAndroid) {
                            if (meetingStore.isAudioShareStarted) {
                              meetingStore.stopAudioShare();
                            } else {
                              meetingStore.startAudioShare();
                            }
                          } else if (Platform.isIOS) {
                            bool isPlaying =
                                await meetingStore.isPlayerRunningIos();
                            String url =
                                await UtilityComponents.showAudioShareDialog(
                                    context: context,
                                    meetingStore: meetingStore,
                                    isPlaying: isPlaying);
                            if (url != "") {
                              meetingStore.playAudioIos(url);
                            }
                          }
                        },
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.music_note,
                          color: themeDefaultColor,
                        ),
                        title: Text(
                          meetingStore.isAudioShareStarted
                              ? "Stop Audio Share"
                              : "Start Audio Share",
                          semanticsLabel: meetingStore.isAudioShareStarted
                              ? "fl_stop_audio_share"
                              : "fl_start_audio_share",
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              color: themeDefaultColor,
                              letterSpacing: 0.25,
                              fontWeight: FontWeight.w600),
                        )),
                  if (Platform.isAndroid && meetingStore.isAudioShareStarted)
                    ListTile(
                        horizontalTitleGap: 2,
                        onTap: () async {
                          if (meetingStore.isAudioShareStarted) {
                            UtilityComponents.showChangeAudioMixingModeDialog(
                                context);
                          }
                        },
                        contentPadding: EdgeInsets.zero,
                        leading: SvgPicture.asset(
                          "assets/icons/music_wave.svg",
                          fit: BoxFit.scaleDown,
                        ),
                        title: Text(
                          "Audio Mixing Mode",
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              color: themeDefaultColor,
                              letterSpacing: 0.25,
                              fontWeight: FontWeight.w600),
                        )),
                  if (Platform.isAndroid)
                    ListTile(
                        horizontalTitleGap: 2,
                        onTap: () async {
                          Navigator.pop(context);
                          context.read<MeetingStore>().enterPipMode();
                        },
                        contentPadding: EdgeInsets.zero,
                        leading: SvgPicture.asset(
                          "assets/icons/screen_share.svg",
                          fit: BoxFit.scaleDown,
                          color: themeDefaultColor,
                        ),
                        title: Text(
                          "Enter Pip Mode",
                          semanticsLabel: "fl_pip_mode",
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              color: themeDefaultColor,
                              letterSpacing: 0.25,
                              fontWeight: FontWeight.w600),
                        )),
                  ListTile(
                      horizontalTitleGap: 2,
                      onTap: () async {
                        showDialog(
                            context: context,
                            builder: (_) => ShareLinkOptionDialog(
                                roles: meetingStore.roles,
                                roomID: meetingStore.hmsRoom!.id));
                      },
                      contentPadding: EdgeInsets.zero,
                      leading: SvgPicture.asset(
                        "assets/icons/share.svg",
                        fit: BoxFit.scaleDown,
                        color: themeDefaultColor,
                      ),
                      title: Text(
                        "Share Link",
                        semanticsLabel: "fl_share_link",
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            color: themeDefaultColor,
                            letterSpacing: 0.25,
                            fontWeight: FontWeight.w600),
                      )),
                  ListTile(
                      horizontalTitleGap: 2,
                      onTap: () async {
                        UtilityComponents.onEndRoomPressed(context);
                      },
                      contentPadding: EdgeInsets.zero,
                      leading: SvgPicture.asset(
                        "assets/icons/end_room.svg",
                        fit: BoxFit.scaleDown,
                        color: themeDefaultColor,
                      ),
                      title: Text(
                        "End Room",
                        semanticsLabel: "fl_end_room",
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            color: themeDefaultColor,
                            letterSpacing: 0.25,
                            fontWeight: FontWeight.w600),
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
