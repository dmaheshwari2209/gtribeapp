import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gtribe/data_store/meeting_store_broadcast.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:gtribe/common/ui/organisms/audio_device_change.dart';
import 'package:gtribe/common/ui/organisms/embedded_button.dart';
import 'package:gtribe/common/ui/organisms/stream_timer.dart';
import 'package:gtribe/common/util/app_color.dart';
import 'package:gtribe/common/util/utility_components.dart';
import 'package:gtribe/enum/meeting_mode.dart';
import 'package:gtribe/hls-streaming/bottom_sheets/hls_start_bottom_sheet.dart';
import 'package:gtribe/hls-streaming/bottom_sheets/hls_message.dart';
import 'package:gtribe/hls-streaming/util/hls_subtitle_text.dart';
import 'package:gtribe/hls-streaming/util/hls_title_text.dart';
import 'package:gtribe/hls-streaming/util/pip_view.dart';
import 'package:gtribe/hls_viewer/hls_viewer.dart';
import 'package:gtribe/model/peer_track_node.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HLSBroadcasterPage extends StatefulWidget {
  final String meetingLink;
  final bool isAudioOn;
  final bool isStreamingLink;
  final bool isRoomMute;
  const HLSBroadcasterPage(
      {Key? key,
      required this.meetingLink,
      required this.isAudioOn,
      this.isStreamingLink = false,
      this.isRoomMute = true})
      : super(key: key);

  @override
  State<HLSBroadcasterPage> createState() => _HLSBroadcasterPageState();
}

class _HLSBroadcasterPageState extends State<HLSBroadcasterPage> {
  bool isAudioMixerDisabled = true;
  @override
  void initState() {
    super.initState();
    checkAudioState();
  }

  void checkAudioState() async {
    if (!widget.isAudioOn) context.read<MeetingStoreBroadcast>().switchAudio();

    if (widget.isRoomMute) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<MeetingStoreBroadcast>().toggleSpeaker();
      });
    }
  }

  Widget _showPopupMenuButton({required bool isHLSRunning}) {
    return PopupMenuButton(
        tooltip: "leave_end_stream",
        offset: const Offset(0, 45),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        icon: SvgPicture.asset(
          "assets/icons/leave_hls.svg",
          color: Colors.white,
          fit: BoxFit.scaleDown,
        ),
        color: themeBottomSheetColor,
        onSelected: (int value) async {
          switch (value) {
            case 1:
              await UtilityComponents.onLeaveStudio(context, true);
              break;
            case 2:
              await UtilityComponents.onEndStream(
                  isBroadcast: true,
                  leaveRoom: true,
                  context: context,
                  title: 'End Session',
                  content:
                      "The session will end for everyone and all the activities will stop. You can’t undo this action.",
                  ignoreText: "Don't End ",
                  actionText: 'End Session');
              break;
            default:
              break;
          }
        },
        itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Row(children: [
                  SvgPicture.asset("assets/icons/leave_hls.svg",
                      width: 17, color: themeDefaultColor),
                  const SizedBox(
                    width: 12,
                  ),
                  HLSTitleText(
                    text: "Leave Studio",
                    textColor: themeDefaultColor,
                    fontSize: 14,
                    lineHeight: 20,
                    letterSpacing: 0.25,
                  ),
                  Divider(
                    height: 5,
                    color: dividerColor,
                  ),
                ]),
              ),
              PopupMenuItem(
                value: 2,
                child: Row(children: [
                  SvgPicture.asset("assets/icons/end_warning.svg",
                      width: 17, color: errorColor),
                  const SizedBox(
                    width: 12,
                  ),
                  HLSTitleText(
                    text: "End Session",
                    textColor: errorColor,
                    fontSize: 14,
                    lineHeight: 20,
                    letterSpacing: 0.25,
                  ),
                  Divider(
                    height: 1,
                    color: dividerColor,
                  ),
                ]),
              ),
            ]);
  }

  @override
  Widget build(BuildContext context) {
    bool isPortraitMode =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return WillPopScope(
      onWillPop: () async {
        bool ans =
            await UtilityComponents.onBackPressed(context, true) ?? false;
        return ans;
      },
      child: Selector<MeetingStoreBroadcast, Tuple2<bool, HMSException?>>(
          selector: (_, meetingStoreBroMeetingStoreBroadcast) => Tuple2(
              meetingStoreBroMeetingStoreBroadcast.isRoomEnded,
              meetingStoreBroMeetingStoreBroadcast.hmsException),
          builder: (_, data, __) {
            if (data.item2 != null) {
              if (data.item2?.code?.errorCode == 1003 ||
                  data.item2?.code?.errorCode == 2000 ||
                  data.item2?.code?.errorCode == 4005) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  UtilityComponents.showErrorDialog(
                      context: context,
                      errorMessage:
                          "Error Code: ${data.item2!.code?.errorCode ?? ""} ${data.item2!.description}",
                      errorTitle: data.item2!.message ?? "",
                      actionMessage: "Leave Room",
                      action: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      });
                });
              } else {
                // Utilities.showToast(
                //     "Error : ${data.item2!.code?.errorCode ?? ""} ${data.item2!.description} ${data.item2!.message}",
                //     time: 5);
              }
              context.read<MeetingStoreBroadcast>().hmsException = null;
            }
            if (data.item1) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                // Utilities.showToast(context.read<MeetingStoreBroadcast>().description);
                Navigator.of(context).popUntil((route) => route.isFirst);
              });
            }
            return Selector<MeetingStoreBroadcast, bool>(
                selector: (_, meetingStoreBroMeetingStoreBroadcast) =>
                    meetingStoreBroMeetingStoreBroadcast.isPipActive,
                builder: (_, isPipActive, __) {
                  return isPipActive
                      ? PipView()
                      : Scaffold(
                          resizeToAvoidBottomInset: false,
                          body: SafeArea(
                            child: Stack(
                              children: [
                                Selector<
                                        MeetingStoreBroadcast,
                                        Tuple6<List<PeerTrackNode>, bool, int,
                                            int, MeetingMode, PeerTrackNode?>>(
                                    selector: (_,
                                            meetingStoreBroMeetingStoreBroadcast) =>
                                        Tuple6(
                                            meetingStoreBroMeetingStoreBroadcast
                                                .peerTracks,
                                            meetingStoreBroMeetingStoreBroadcast
                                                .isHLSLink,
                                            meetingStoreBroMeetingStoreBroadcast
                                                .peerTracks.length,
                                            meetingStoreBroMeetingStoreBroadcast
                                                .screenShareCount,
                                            meetingStoreBroMeetingStoreBroadcast
                                                .meetingMode,
                                            meetingStoreBroMeetingStoreBroadcast
                                                    .peerTracks.isNotEmpty
                                                ? meetingStoreBroMeetingStoreBroadcast
                                                        .peerTracks[
                                                    meetingStoreBroMeetingStoreBroadcast
                                                        .screenShareCount]
                                                : null),
                                    builder: (_, data, __) {
                                      if (data.item2) {
                                        return Selector<MeetingStoreBroadcast,
                                                bool>(
                                            selector: (_,
                                                    meetingStoreBroMeetingStoreBroadcast) =>
                                                meetingStoreBroMeetingStoreBroadcast
                                                    .hasHlsStarted,
                                            builder: (_, hasHlsStarted, __) {
                                              return hasHlsStarted
                                                  ? SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.735,
                                                      child: Center(
                                                        child: HLSPlayer(
                                                            isBroadcast: true,
                                                            streamUrl: context
                                                                .read<
                                                                    MeetingStoreBroadcast>()
                                                                .streamUrl),
                                                      ),
                                                    )
                                                  : SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.735,
                                                      child: Center(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          8.0),
                                                              child: Text(
                                                                "Waiting for HLS to start...",
                                                                style: GoogleFonts
                                                                    .inter(
                                                                        color:
                                                                            iconColor,
                                                                        fontSize:
                                                                            20),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                            });
                                      }
                                      if (data.item3 == 0) {
                                        return SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.735,
                                          child: const Center(
                                              child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          )),
                                        );
                                      }
                                      return Selector<
                                              MeetingStoreBroadcast,
                                              Tuple3<MeetingMode, HMSPeer?,
                                                  int>>(
                                          selector: (_,
                                                  meetingStoreBroMeetingStoreBroadcast) =>
                                              Tuple3(
                                                  meetingStoreBroMeetingStoreBroadcast
                                                      .meetingMode,
                                                  meetingStoreBroMeetingStoreBroadcast
                                                      .localPeer,
                                                  meetingStoreBroMeetingStoreBroadcast
                                                      .peers.length),
                                          builder: (_, modeData, __) {
                                            Size size = Size(
                                                MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                MediaQuery.of(context)
                                                        .size
                                                        .height -
                                                    (widget.isStreamingLink
                                                        ? 163
                                                        : 122) -
                                                    MediaQuery.of(context)
                                                        .padding
                                                        .bottom -
                                                    MediaQuery.of(context)
                                                        .padding
                                                        .top);
                                            return Positioned(
                                              top: 55,
                                              left: 0,
                                              right: 0,
                                              bottom: widget.isStreamingLink
                                                  ? 108
                                                  : 68,
                                              child: SizedBox(
                                                  width: 800,
                                                  height: 300,
                                                  child: WebView(
                                                    javascriptMode:
                                                        JavascriptMode
                                                            .unrestricted,
                                                    initialUrl:
                                                        'https://www.chess.com/play',
                                                    onPageFinished:
                                                        (String url) {
                                                      // if (url.endsWith('/formResponse')) {
                                                      //   if (!toastShown) {
                                                      //     FirebaseEvents().logLearnSectionFeedbackSubmitted();
                                                      //     Navigator.popUntil(context, (route) => route.isFirst);
                                                      //     toastShown = true;
                                                      //     customToast('Thank you for your valuable feedback');
                                                      //   }
                                                      // }
                                                    },
                                                  )
                                                  // child: ((modeData.item1 ==
                                                  //             MeetingMode
                                                  //                 .Video) &&
                                                  //         (data.item3 == 2) &&
                                                  //         (modeData.item2 !=
                                                  //             null) &&
                                                  //         (modeData.item3 == 2))
                                                  //     ? OneToOneMode(
                                                  //         bottomMargin:
                                                  //             widget.isStreamingLink
                                                  //                 ? 272
                                                  //                 : 235,
                                                  //         peerTracks: data.item1,
                                                  //         screenShareCount:
                                                  //             data.item4,
                                                  //         context: context,
                                                  //         size: size)
                                                  //     : (modeData.item1 ==
                                                  //             MeetingMode.Hero)
                                                  //         ? gridHeroView(
                                                  //             peerTracks:
                                                  //                 data.item1,
                                                  //             itemCount:
                                                  //                 data.item3,
                                                  //             screenShareCount:
                                                  //                 data.item4,
                                                  //             context: context,
                                                  //             isPortrait:
                                                  //                 isPortraitMode,
                                                  //             size: size)
                                                  //         : (modeData.item1 ==
                                                  //                 MeetingMode
                                                  //                     .Audio)
                                                  //             ? gridAudioView(
                                                  //                 peerTracks: data
                                                  //                     .item1
                                                  //                     .sublist(data
                                                  //                         .item4),
                                                  //                 itemCount: data
                                                  //                     .item1
                                                  //                     .sublist(
                                                  //                         data.item4)
                                                  //                     .length,
                                                  //                 context: context,
                                                  //                 isPortrait: isPortraitMode,
                                                  //                 size: size)
                                                  //             : (data.item5 == MeetingMode.Single)
                                                  //                 ? fullScreenView(peerTracks: data.item1, itemCount: data.item3, screenShareCount: data.item4, context: context, isPortrait: isPortraitMode, size: size)
                                                  //                 : hlsGridView(peerTracks: data.item1, itemCount: data.item3, screenShareCount: data.item4, context: context, isPortrait: true, size: size),
                                                  ),
                                            );
                                          });
                                    }),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15,
                                          right: 15,
                                          top: 5,
                                          bottom: 2),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Selector<MeetingStoreBroadcast,
                                                      bool>(
                                                  selector: (_,
                                                          meetingStoreBroMeetingStoreBroadcast) =>
                                                      meetingStoreBroMeetingStoreBroadcast
                                                          .hasHlsStarted,
                                                  builder:
                                                      (_, hasHlsStarted, __) {
                                                    return hasHlsStarted
                                                        ? EmbeddedButton(
                                                            onTap: () async =>
                                                                {},
                                                            width: 40,
                                                            height: 40,
                                                            offColor:
                                                                const Color(
                                                                    0xffCC525F),
                                                            onColor:
                                                                const Color(
                                                                    0xffCC525F),
                                                            disabledBorderColor:
                                                                const Color(
                                                                    0xffCC525F),
                                                            isActive: false,
                                                            child: _showPopupMenuButton(
                                                                isHLSRunning:
                                                                    hasHlsStarted))
                                                        : EmbeddedButton(
                                                            onTap: () async => {
                                                              await UtilityComponents
                                                                  .onBackPressed(
                                                                      context,
                                                                      true)
                                                            },
                                                            width: 40,
                                                            height: 40,
                                                            offColor:
                                                                const Color(
                                                                    0xffCC525F),
                                                            onColor:
                                                                const Color(
                                                                    0xffCC525F),
                                                            disabledBorderColor:
                                                                const Color(
                                                                    0xffCC525F),
                                                            isActive: false,
                                                            child: SvgPicture
                                                                .asset(
                                                              "assets/icons/leave_hls.svg",
                                                              color:
                                                                  Colors.white,
                                                              fit: BoxFit
                                                                  .scaleDown,
                                                              semanticsLabel:
                                                                  "leave_button",
                                                            ),
                                                          );
                                                  }),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Selector<MeetingStoreBroadcast,
                                                      bool>(
                                                  selector: (_,
                                                          meetingStoreBroMeetingStoreBroadcast) =>
                                                      meetingStoreBroMeetingStoreBroadcast
                                                          .hasHlsStarted,
                                                  builder:
                                                      (_, hasHlsStarted, __) {
                                                    if (hasHlsStarted) {
                                                      return Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            5.0),
                                                                child:
                                                                    SvgPicture
                                                                        .asset(
                                                                  "assets/icons/live_stream.svg",
                                                                  color:
                                                                      errorColor,
                                                                  fit: BoxFit
                                                                      .scaleDown,
                                                                ),
                                                              ),
                                                              Text(
                                                                "Live",
                                                                semanticsLabel:
                                                                    "fl_live_stream_running",
                                                                style: GoogleFonts.inter(
                                                                    fontSize:
                                                                        16,
                                                                    color:
                                                                        themeDefaultColor,
                                                                    letterSpacing:
                                                                        0.5,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  SvgPicture
                                                                      .asset(
                                                                    "assets/icons/clock.svg",
                                                                    color:
                                                                        themeSubHeadingColor,
                                                                    fit: BoxFit
                                                                        .scaleDown,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 6,
                                                                  ),
                                                                  Selector<
                                                                          MeetingStoreBroadcast,
                                                                          HMSRoom?>(
                                                                      selector: (_,
                                                                              meetingStoreBroMeetingStoreBroadcast) =>
                                                                          meetingStoreBroMeetingStoreBroadcast
                                                                              .hmsRoom,
                                                                      builder: (_,
                                                                          hmsRoom,
                                                                          __) {
                                                                        if (hmsRoom != null &&
                                                                            hmsRoom.hmshlsStreamingState !=
                                                                                null &&
                                                                            hmsRoom
                                                                                .hmshlsStreamingState!.variants.isNotEmpty &&
                                                                            hmsRoom.hmshlsStreamingState!.variants[0]!.startedAt !=
                                                                                null) {
                                                                          return StreamTimer(
                                                                              startedAt: hmsRoom.hmshlsStreamingState!.variants[0]!.startedAt!);
                                                                        }
                                                                        return HLSSubtitleText(
                                                                          text:
                                                                              "00:00",
                                                                          textColor:
                                                                              themeSubHeadingColor,
                                                                        );
                                                                      }),
                                                                ],
                                                              ),
                                                              HLSSubtitleText(
                                                                text: " | ",
                                                                textColor:
                                                                    dividerColor,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  SvgPicture
                                                                      .asset(
                                                                    "assets/icons/watching.svg",
                                                                    color:
                                                                        themeSubHeadingColor,
                                                                    fit: BoxFit
                                                                        .scaleDown,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 6,
                                                                  ),
                                                                  Selector<
                                                                          MeetingStoreBroadcast,
                                                                          int>(
                                                                      selector: (_,
                                                                              meetingStoreBroMeetingStoreBroadcast) =>
                                                                          meetingStoreBroMeetingStoreBroadcast
                                                                              .peers
                                                                              .length,
                                                                      builder: (_,
                                                                          length,
                                                                          __) {
                                                                        return HLSSubtitleText(
                                                                            text:
                                                                                length.toString(),
                                                                            textColor: themeSubHeadingColor);
                                                                      })
                                                                ],
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      );
                                                    }
                                                    return const SizedBox();
                                                  })
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Selector<MeetingStoreBroadcast,
                                                      bool>(
                                                  selector: (_,
                                                          meetingStoreBroMeetingStoreBroadcast) =>
                                                      meetingStoreBroMeetingStoreBroadcast
                                                          .isRaisedHand,
                                                  builder: (_, handRaised, __) {
                                                    return EmbeddedButton(
                                                      onTap: () => {
                                                        context
                                                            .read<
                                                                MeetingStoreBroadcast>()
                                                            .changeMetadata()
                                                      },
                                                      width: 40,
                                                      height: 40,
                                                      disabledBorderColor:
                                                          borderColor,
                                                      offColor:
                                                          themeScreenBackgroundColor,
                                                      onColor: themeHintColor,
                                                      isActive: handRaised,
                                                      child: SvgPicture.asset(
                                                        "assets/icons/hand_outline.svg",
                                                        color:
                                                            themeDefaultColor,
                                                        fit: BoxFit.scaleDown,
                                                        semanticsLabel:
                                                            "hand_raise_button",
                                                      ),
                                                    );
                                                  }),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              // EmbeddedButton(
                                              //   onTap: () => {
                                              //     showModalBottomSheet(
                                              //       isScrollControlled: true,
                                              //       backgroundColor:
                                              //           themeBottomSheetColor,
                                              //       shape:
                                              //           RoundedRectangleBorder(
                                              //         borderRadius:
                                              //             BorderRadius.circular(
                                              //                 20),
                                              //       ),
                                              //       context: context,
                                              //       builder: (ctx) =>
                                              //           ChangeNotifierProvider.value(
                                              //               value: context.read<
                                              //                   MeetingStoreBroadcast>(),
                                              //               child:
                                              //                   HLSParticipantSheet()),
                                              //     )
                                              //   },
                                              //   width: 40,
                                              //   height: 40,
                                              //   offColor:
                                              //       themeScreenBackgroundColor,
                                              //   onColor:
                                              //       themeScreenBackgroundColor,
                                              //   isActive: true,
                                              //   child: SvgPicture.asset(
                                              //     "assets/icons/participants.svg",
                                              //     color: themeDefaultColor,
                                              //     fit: BoxFit.scaleDown,
                                              //     semanticsLabel:
                                              //         "participants_button",
                                              //   ),
                                              // ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Selector<MeetingStoreBroadcast,
                                                      bool>(
                                                  selector: (_,
                                                          meetingStoreBroMeetingStoreBroadcast) =>
                                                      meetingStoreBroMeetingStoreBroadcast
                                                          .isNewMessageReceived,
                                                  builder: (_,
                                                      isNewMessageReceived,
                                                      __) {
                                                    return EmbeddedButton(
                                                      onTap: () => {
                                                        context
                                                            .read<
                                                                MeetingStoreBroadcast>()
                                                            .getSessionMetadata(),
                                                        context
                                                            .read<
                                                                MeetingStoreBroadcast>()
                                                            .setNewMessageFalse(),
                                                        showModalBottomSheet(
                                                          isScrollControlled:
                                                              true,
                                                          backgroundColor:
                                                              themeBottomSheetColor,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                          context: context,
                                                          builder: (ctx) =>
                                                              ChangeNotifierProvider
                                                                  .value(
                                                                      value: context
                                                                          .read<
                                                                              MeetingStoreBroadcast>(),
                                                                      child:
                                                                          const HLSMessage(
                                                                        isBroadcast:
                                                                            true,
                                                                      )),
                                                        )
                                                      },
                                                      width: 40,
                                                      height: 40,
                                                      offColor: themeHintColor,
                                                      onColor:
                                                          themeScreenBackgroundColor,
                                                      isActive: true,
                                                      child: SvgPicture.asset(
                                                        isNewMessageReceived
                                                            ? "assets/icons/message_badge_on.svg"
                                                            : "assets/icons/message_badge_off.svg",
                                                        fit: BoxFit.scaleDown,
                                                        semanticsLabel:
                                                            "chat_button",
                                                      ),
                                                    );
                                                  })
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Column(
                                        children: [
                                          if (Provider.of<MeetingStoreBroadcast>(
                                                          context)
                                                      .localPeer !=
                                                  null &&
                                              !Provider.of<
                                                          MeetingStoreBroadcast>(
                                                      context)
                                                  .localPeer!
                                                  .role
                                                  .name
                                                  .contains("hls-"))
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                if (Provider.of<MeetingStoreBroadcast>(context)
                                                        .localPeer !=
                                                    null)
                                                  (Provider.of<MeetingStoreBroadcast>(context)
                                                              .localPeer
                                                              ?.role
                                                              .publishSettings
                                                              ?.allowed
                                                              .contains(
                                                                  "audio") ??
                                                          false)
                                                      ? Selector<
                                                              MeetingStoreBroadcast,
                                                              bool>(
                                                          selector: (_, meetingStoreBroMeetingStoreBroadcast) =>
                                                              meetingStoreBroMeetingStoreBroadcast
                                                                  .isMicOn,
                                                          builder: (_, isMicOn, __) {
                                                            return EmbeddedButton(
                                                              onTap: () => {
                                                                context
                                                                    .read<
                                                                        MeetingStoreBroadcast>()
                                                                    .switchAudio()
                                                              },
                                                              width: 40,
                                                              height: 40,
                                                              disabledBorderColor:
                                                                  borderColor,
                                                              offColor:
                                                                  themeHMSBorderColor,
                                                              onColor:
                                                                  themeScreenBackgroundColor,
                                                              isActive: isMicOn,
                                                              child: SvgPicture
                                                                  .asset(
                                                                isMicOn
                                                                    ? "assets/icons/mic_state_on.svg"
                                                                    : "assets/icons/mic_state_off.svg",
                                                                color:
                                                                    themeDefaultColor,
                                                                fit: BoxFit
                                                                    .scaleDown,
                                                                semanticsLabel:
                                                                    "audio_mute_button",
                                                              ),
                                                            );
                                                          })
                                                      : Selector<
                                                              MeetingStoreBroadcast,
                                                              bool>(
                                                          selector: (_,
                                                                  meetingStoreBroMeetingStoreBroadcast) =>
                                                              meetingStoreBroMeetingStoreBroadcast
                                                                  .isSpeakerOn,
                                                          builder: (_, isSpeakerOn, __) {
                                                            return EmbeddedButton(
                                                              onTap: () => {
                                                                context
                                                                    .read<
                                                                        MeetingStoreBroadcast>()
                                                                    .toggleSpeaker(),
                                                              },
                                                              width: 40,
                                                              height: 40,
                                                              disabledBorderColor:
                                                                  borderColor,
                                                              offColor:
                                                                  themeHMSBorderColor,
                                                              onColor:
                                                                  themeScreenBackgroundColor,
                                                              isActive:
                                                                  isSpeakerOn,
                                                              child: SvgPicture.asset(
                                                                  isSpeakerOn
                                                                      ? "assets/icons/speaker_state_on.svg"
                                                                      : "assets/icons/speaker_state_off.svg",
                                                                  color:
                                                                      themeDefaultColor,
                                                                  fit: BoxFit
                                                                      .scaleDown,
                                                                  semanticsLabel:
                                                                      "speaker_mute_button"),
                                                            );
                                                          }),
                                                if (Provider.of<MeetingStoreBroadcast>(context)
                                                        .localPeer !=
                                                    null)
                                                  (Provider.of<MeetingStoreBroadcast>(context)
                                                              .localPeer
                                                              ?.role
                                                              .publishSettings
                                                              ?.allowed
                                                              .contains(
                                                                  "video") ??
                                                          false)
                                                      ? Selector<
                                                              MeetingStoreBroadcast,
                                                              Tuple2<bool,
                                                                  bool>>(
                                                          selector: (_, meetingStoreBroMeetingStoreBroadcast) => Tuple2(
                                                              meetingStoreBroMeetingStoreBroadcast
                                                                  .isVideoOn,
                                                              meetingStoreBroMeetingStoreBroadcast
                                                                      .meetingMode ==
                                                                  MeetingMode
                                                                      .Audio),
                                                          builder: (_, data, __) {
                                                            return EmbeddedButton(
                                                              onTap: () => {
                                                                (data.item2)
                                                                    ? null
                                                                    : context
                                                                        .read<
                                                                            MeetingStoreBroadcast>()
                                                                        .switchVideo(),
                                                              },
                                                              width: 40,
                                                              height: 40,
                                                              disabledBorderColor:
                                                                  borderColor,
                                                              offColor:
                                                                  themeHMSBorderColor,
                                                              onColor:
                                                                  themeScreenBackgroundColor,
                                                              isActive:
                                                                  data.item1,
                                                              child: SvgPicture.asset(
                                                                  data.item1
                                                                      ? "assets/icons/cam_state_on.svg"
                                                                      : "assets/icons/cam_state_off.svg",
                                                                  color:
                                                                      themeDefaultColor,
                                                                  fit: BoxFit
                                                                      .scaleDown,
                                                                  semanticsLabel:
                                                                      "video_mute_button"),
                                                            );
                                                          })
                                                      : Selector<
                                                              MeetingStoreBroadcast,
                                                              bool>(
                                                          selector: (_, meetingStoreBroMeetingStoreBroadcast) =>
                                                              meetingStoreBroMeetingStoreBroadcast
                                                                  .isStatsVisible,
                                                          builder: (_, isStatsVisible, __) {
                                                            return EmbeddedButton(
                                                              width: 40,
                                                              height: 40,
                                                              onTap: () => context
                                                                  .read<
                                                                      MeetingStoreBroadcast>()
                                                                  .changeStatsVisible(),
                                                              disabledBorderColor:
                                                                  borderColor,
                                                              offColor:
                                                                  themeScreenBackgroundColor,
                                                              onColor:
                                                                  themeHMSBorderColor,
                                                              isActive:
                                                                  isStatsVisible,
                                                              child: SvgPicture.asset(
                                                                  "assets/icons/stats.svg",
                                                                  fit: BoxFit
                                                                      .scaleDown,
                                                                  semanticsLabel:
                                                                      "stats_button"),
                                                            );
                                                          }),
                                                if (Provider.of<MeetingStoreBroadcast>(
                                                                context)
                                                            .localPeer !=
                                                        null &&
                                                    widget.isStreamingLink)
                                                  Selector<
                                                          MeetingStoreBroadcast,
                                                          Tuple2<bool, bool>>(
                                                      selector: (_,
                                                              meetingStoreBroMeetingStoreBroadcast) =>
                                                          Tuple2(
                                                              meetingStoreBroMeetingStoreBroadcast
                                                                  .hasHlsStarted,
                                                              meetingStoreBroMeetingStoreBroadcast
                                                                  .isHLSLoading),
                                                      builder: (_, data, __) {
                                                        if (data.item1) {
                                                          return Column(
                                                            children: [
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  UtilityComponents.onEndStream(
                                                                      isBroadcast:
                                                                          true,
                                                                      context:
                                                                          context,
                                                                      title:
                                                                          'End live stream for all?',
                                                                      content:
                                                                          "Your live stream will end and stream viewers will go offline immediately in this room. You can’t undo this action.",
                                                                      ignoreText:
                                                                          "Don't End ",
                                                                      actionText:
                                                                          'End Stream');
                                                                },
                                                                child:
                                                                    CircleAvatar(
                                                                  radius: 40,
                                                                  backgroundColor:
                                                                      errorColor,
                                                                  child: SvgPicture.asset(
                                                                      "assets/icons/end.svg",
                                                                      color:
                                                                          themeDefaultColor,
                                                                      height:
                                                                          36,
                                                                      semanticsLabel:
                                                                          "hls_end_button"),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              Text(
                                                                "END STREAM",
                                                                style: GoogleFonts.inter(
                                                                    letterSpacing:
                                                                        1.5,
                                                                    fontSize:
                                                                        10,
                                                                    height: 1.6,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              )
                                                            ],
                                                          );
                                                        } else if (data.item2) {
                                                          return Column(
                                                            children: [
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              InkWell(
                                                                onTap: () {},
                                                                child:
                                                                    CircleAvatar(
                                                                        radius:
                                                                            40,
                                                                        backgroundColor:
                                                                            themeScreenBackgroundColor,
                                                                        child:
                                                                            CircularProgressIndicator(
                                                                          semanticsLabel:
                                                                              "hls_loader",
                                                                          strokeWidth:
                                                                              2,
                                                                          color:
                                                                              hmsdefaultColor,
                                                                        )),
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              Text(
                                                                "STARTING HLS",
                                                                style: GoogleFonts.inter(
                                                                    letterSpacing:
                                                                        1.5,
                                                                    fontSize:
                                                                        10,
                                                                    height: 1.6,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              )
                                                            ],
                                                          );
                                                        }
                                                        return Column(
                                                          children: [
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                showModalBottomSheet(
                                                                  isScrollControlled:
                                                                      true,
                                                                  backgroundColor:
                                                                      themeBottomSheetColor,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                  ),
                                                                  context:
                                                                      context,
                                                                  builder: (ctx) => ChangeNotifierProvider.value(
                                                                      value: context
                                                                          .read<
                                                                              MeetingStoreBroadcast>(),
                                                                      child:
                                                                          const HLSStartBottomSheet()),
                                                                );
                                                              },
                                                              child:
                                                                  CircleAvatar(
                                                                radius: 40,
                                                                backgroundColor:
                                                                    hmsdefaultColor,
                                                                child: SvgPicture.asset(
                                                                    "assets/icons/live.svg",
                                                                    color:
                                                                        themeDefaultColor,
                                                                    fit: BoxFit
                                                                        .scaleDown,
                                                                    semanticsLabel:
                                                                        "start_hls_button"),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(
                                                              "GO LIVE",
                                                              style: GoogleFonts.inter(
                                                                  letterSpacing:
                                                                      1.5,
                                                                  fontSize: 10,
                                                                  height: 1.6,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            )
                                                          ],
                                                        );
                                                      }),
                                                if (Provider.of<MeetingStoreBroadcast>(context)
                                                        .localPeer !=
                                                    null)
                                                  (Provider.of<MeetingStoreBroadcast>(context)
                                                              .localPeer
                                                              ?.role
                                                              .publishSettings
                                                              ?.allowed
                                                              .contains(
                                                                  "screen") ??
                                                          false)
                                                      ? Selector<
                                                              MeetingStoreBroadcast,
                                                              bool>(
                                                          selector: (_, meetingStoreBroMeetingStoreBroadcast) =>
                                                              meetingStoreBroMeetingStoreBroadcast
                                                                  .isScreenShareOn,
                                                          builder: (_, data, __) {
                                                            return EmbeddedButton(
                                                              onTap: () {
                                                                MeetingStoreBroadcast
                                                                    meetingStoreBroMeetingStoreBroadcast =
                                                                    Provider.of<
                                                                            MeetingStoreBroadcast>(
                                                                        context,
                                                                        listen:
                                                                            false);
                                                                if (meetingStoreBroMeetingStoreBroadcast
                                                                    .isScreenShareOn) {
                                                                  meetingStoreBroMeetingStoreBroadcast
                                                                      .stopScreenShare();
                                                                } else {
                                                                  meetingStoreBroMeetingStoreBroadcast
                                                                      .startScreenShare();
                                                                }
                                                              },
                                                              width: 40,
                                                              height: 40,
                                                              disabledBorderColor:
                                                                  borderColor,
                                                              offColor:
                                                                  themeScreenBackgroundColor,
                                                              onColor:
                                                                  borderColor,
                                                              isActive: data,
                                                              child: SvgPicture.asset(
                                                                  "assets/icons/screen_share.svg",
                                                                  color:
                                                                      themeDefaultColor,
                                                                  fit: BoxFit
                                                                      .scaleDown,
                                                                  semanticsLabel:
                                                                      "screen_share_button"),
                                                            );
                                                          })
                                                      : Selector<
                                                              MeetingStoreBroadcast,
                                                              bool>(
                                                          selector: (_,
                                                                  meetingStoreBroMeetingStoreBroadcast) =>
                                                              (meetingStoreBroMeetingStoreBroadcast
                                                                  .isBRB),
                                                          builder: (_, isBRB, __) {
                                                            return EmbeddedButton(
                                                              width: 40,
                                                              height: 40,
                                                              onTap: () => context
                                                                  .read<
                                                                      MeetingStoreBroadcast>()
                                                                  .changeMetadataBRB(),
                                                              disabledBorderColor:
                                                                  borderColor,
                                                              offColor:
                                                                  themeScreenBackgroundColor,
                                                              onColor:
                                                                  borderColor,
                                                              isActive: isBRB,
                                                              child: SvgPicture.asset(
                                                                  "assets/icons/brb.svg",
                                                                  fit: BoxFit
                                                                      .scaleDown,
                                                                  semanticsLabel:
                                                                      "brb_button"),
                                                            );
                                                          }),
                                                // if (Provider.of<MeetingStoreBroadcast>(
                                                //             context)
                                                //         .localPeer !=
                                                //     null)
                                                // EmbeddedButton(
                                                //   onTap: () async => {
                                                //     isAudioMixerDisabled =
                                                //         await Utilities
                                                //                 .getBoolData(
                                                //                     key:
                                                //                         "audio-mixer-disabled") ??
                                                //             true,
                                                //     showModalBottomSheet(
                                                //       isScrollControlled:
                                                //           true,
                                                //       backgroundColor:
                                                //           themeBottomSheetColor,
                                                //       shape:
                                                //           RoundedRectangleBorder(
                                                //         borderRadius:
                                                //             BorderRadius
                                                //                 .circular(20),
                                                //       ),
                                                //       context: context,
                                                //       builder: (ctx) =>
                                                //           ChangeNotifierProvider
                                                //               .value(
                                                //                   value: context
                                                //                       .read<
                                                //                           MeetingStoreBroadcast>(),
                                                //                   child:
                                                //                       HLSMoreSettings(
                                                //                     isAudioMixerDisabled:
                                                //                         isAudioMixerDisabled,
                                                //                   )),
                                                //     )
                                                //   },
                                                //   width: 40,
                                                //   height: 40,
                                                //   offColor: themeHintColor,
                                                //   onColor:
                                                //       themeScreenBackgroundColor,
                                                //   isActive: true,
                                                //   child: SvgPicture.asset(
                                                //       "assets/icons/more.svg",
                                                //       color:
                                                //           themeDefaultColor,
                                                //       fit: BoxFit.scaleDown,
                                                //       semanticsLabel:
                                                //           "more_button"),
                                                // ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Selector<MeetingStoreBroadcast,
                                        HMSRoleChangeRequest?>(
                                    selector:
                                        (_, meetingStoreBroMeetingStoreBroadcast) =>
                                            meetingStoreBroMeetingStoreBroadcast
                                                .currentRoleChangeRequest,
                                    builder: (_, roleChangeRequest, __) {
                                      if (roleChangeRequest != null) {
                                        HMSRoleChangeRequest currentRequest =
                                            roleChangeRequest;
                                        context
                                            .read<MeetingStoreBroadcast>()
                                            .currentRoleChangeRequest = null;
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          UtilityComponents
                                              .showRoleChangeDialog(
                                                  currentRequest, context);
                                        });
                                      }
                                      return const SizedBox();
                                    }),
                                Selector<MeetingStoreBroadcast,
                                        HMSTrackChangeRequest?>(
                                    selector:
                                        (_, meetingStoreBroMeetingStoreBroadcast) =>
                                            meetingStoreBroMeetingStoreBroadcast
                                                .hmsTrackChangeRequest,
                                    builder: (_, hmsTrackChangeRequest, __) {
                                      if (hmsTrackChangeRequest != null) {
                                        HMSTrackChangeRequest currentRequest =
                                            hmsTrackChangeRequest;
                                        context
                                            .read<MeetingStoreBroadcast>()
                                            .hmsTrackChangeRequest = null;
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          UtilityComponents
                                              .showTrackChangeDialog(context,
                                                  currentRequest, true);
                                        });
                                      }
                                      return const SizedBox();
                                    }),
                                Selector<MeetingStoreBroadcast, bool>(
                                    selector:
                                        (_, meetingStoreBroMeetingStoreBroadcast) =>
                                            meetingStoreBroMeetingStoreBroadcast
                                                .showAudioDeviceChangePopup,
                                    builder:
                                        (_, showAudioDeviceChangePopup, __) {
                                      if (showAudioDeviceChangePopup) {
                                        context
                                            .read<MeetingStoreBroadcast>()
                                            .showAudioDeviceChangePopup = false;
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          showDialog(
                                              context: context,
                                              builder: (_) =>
                                                  AudioDeviceChangeDialog(
                                                    currentAudioDevice: context
                                                        .read<
                                                            MeetingStoreBroadcast>()
                                                        .currentAudioOutputDevice!,
                                                    audioDevicesList: context
                                                        .read<
                                                            MeetingStoreBroadcast>()
                                                        .availableAudioOutputDevices,
                                                    changeAudioDevice:
                                                        (audioDevice) {
                                                      context
                                                          .read<
                                                              MeetingStoreBroadcast>()
                                                          .switchAudioOutput(
                                                              audioDevice:
                                                                  audioDevice);
                                                    },
                                                  ));
                                        });
                                      }
                                      return const SizedBox();
                                    }),
                                Selector<MeetingStoreBroadcast, bool>(
                                    selector:
                                        (_, meetingStoreBroMeetingStoreBroadcast) =>
                                            meetingStoreBroMeetingStoreBroadcast
                                                .reconnecting,
                                    builder: (_, reconnecting, __) {
                                      if (reconnecting) {
                                        return UtilityComponents
                                            .showReconnectingDialog(
                                                context, true);
                                      }
                                      return const SizedBox();
                                    }),
                              ],
                            ),
                          ),
                        );
                });
          }),
    );
  }
}
