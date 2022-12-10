import 'dart:io';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:gtribe/common/ui/organisms/embedded_button.dart';
import 'package:gtribe/common/ui/organisms/hms_button.dart';
import 'package:gtribe/common/util/app_color.dart';
import 'package:gtribe/common/util/utility_components.dart';
import 'package:gtribe/common/util/utility_function.dart';
import 'package:gtribe/enum/meeting_flow.dart';
import 'package:gtribe/hls-streaming/hls_screen_controller.dart';
import 'package:gtribe/data_store/meeting_store.dart';
import 'package:gtribe/hls-streaming/util/hls_title_text.dart';
import 'package:gtribe/preview/preview_device_settings.dart';
import 'package:gtribe/preview/preview_participant_sheet.dart';
import 'package:gtribe/preview/preview_store.dart';
import 'package:provider/provider.dart';

class PreviewPage extends StatefulWidget {
  final String name;
  final String meetingLink;
  final MeetingFlow meetingFlow;

  const PreviewPage(
      {required this.name,
      required this.meetingLink,
      required this.meetingFlow});
  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  @override
  void initState() {
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => PreviewStore())],
    );
    super.initState();
    initPreview();
  }

  void initPreview() async {
    String ans = await context
        .read<PreviewStore>()
        .startPreview(user: widget.name, meetingLink: widget.meetingLink);
    if (ans != "") {
      if (ans.contains("Connection")) {
        UtilityComponents.showErrorDialog(
            context: context,
            errorMessage: "Please Check the internet connection",
            errorTitle: ans,
            actionMessage: "OK",
            action: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            });
      } else {
        UtilityComponents.showErrorDialog(
            context: context,
            errorMessage: "Please check the meeting URL",
            errorTitle: ans,
            actionMessage: "OK",
            action: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double height = size.height;
    final double width = size.width;
    final Orientation orientation = MediaQuery.of(context).orientation;
    final previewStore = context.watch<PreviewStore>();
    return WillPopScope(
      onWillPop: () async {
        context.read<PreviewStore>().leave();
        return true;
      },
      child: Selector<PreviewStore, HMSException?>(
          selector: (_, previewStore) => previewStore.error,
          builder: (_, error, __) {
            if (error != null) {
              if ((error.code?.errorCode == 1003) ||
                  (error.code?.errorCode == 2000) ||
                  (error.code?.errorCode == 4005)) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  UtilityComponents.showErrorDialog(
                      context: context,
                      errorMessage:
                          "Error Code: ${error.code?.errorCode ?? ""} ${error.description}",
                      errorTitle: error.message ?? "",
                      actionMessage: "Leave Room",
                      action: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      });
                });
              } else {
                Utilities.showToast(
                    "Error : ${error.code?.errorCode ?? ""} ${error.description} ${error.message}",
                    time: 5);
              }
            }
            return Scaffold(
              body: Stack(
                children: [
                  (previewStore.peer == null)
                      ? const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : (previewStore.peer!.role.name.contains("hls-"))
                          ? Container(
                              child: Center(
                                child: CircleAvatar(
                                    backgroundColor: defaultAvatarColor,
                                    radius: 40,
                                    child: Text(
                                      Utilities.getAvatarTitle(
                                          previewStore.peer!.name),
                                      style: GoogleFonts.inter(
                                        fontSize: 40,
                                        color: Colors.white,
                                      ),
                                    )),
                              ),
                            )
                          : (previewStore.localTracks.isEmpty &&
                                  previewStore.isVideoOn)
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : SizedBox(
                                  height: height,
                                  width: width,
                                  child: (previewStore.isVideoOn)
                                      ? HMSVideoView(
                                          scaleType:
                                              ScaleType.SCALE_ASPECT_FILL,
                                          track: previewStore.localTracks[0],
                                          setMirror: true,
                                          matchParent: false,
                                        )
                                      : Container(
                                          child: Center(
                                            child: CircleAvatar(
                                                backgroundColor:
                                                    defaultAvatarColor,
                                                radius: 40,
                                                child: Text(
                                                  Utilities.getAvatarTitle(
                                                      previewStore.peer!.name),
                                                  style: GoogleFonts.inter(
                                                    fontSize: 40,
                                                    color: Colors.white,
                                                  ),
                                                )),
                                          ),
                                        ),
                                ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height: orientation == Orientation.portrait
                                    ? width * 0.1
                                    : width * 0.05,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            context
                                                .read<PreviewStore>()
                                                .leave();
                                            Navigator.of(context).popUntil(
                                                (route) => route.isFirst);
                                          },
                                          icon:
                                              const Icon(Icons.arrow_back_ios)),
                                      HLSTitleText(
                                          text: "Configure",
                                          textColor: themeDefaultColor),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      EmbeddedButton(
                                        height: 40,
                                        width: 40,
                                        onTap: () async => Platform.isAndroid
                                            ? showModalBottomSheet(
                                                isScrollControlled: true,
                                                backgroundColor:
                                                    themeBottomSheetColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                context: context,
                                                builder: (ctx) =>
                                                    ChangeNotifierProvider.value(
                                                        value: context.read<
                                                            PreviewStore>(),
                                                        child:
                                                            const PreviewDeviceSettings()),
                                              )
                                            : previewStore.toggleSpeaker(),
                                        offColor: themeHintColor,
                                        onColor: themeScreenBackgroundColor,
                                        isActive: true,
                                        child: SvgPicture.asset(
                                          !previewStore.isRoomMute
                                              ? "assets/icons/speaker_state_on.svg"
                                              : "assets/icons/speaker_state_off.svg",
                                          color: themeDefaultColor,
                                          fit: BoxFit.scaleDown,
                                          semanticsLabel: "fl_mute_room_btn",
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Badge(
                                        animationType: BadgeAnimationType.fade,
                                        badgeColor: hmsdefaultColor,
                                        badgeContent: Text(
                                            previewStore.peerCount.toString()),
                                        child: EmbeddedButton(
                                          height: 40,
                                          width: 40,
                                          onTap: () async =>
                                              showModalBottomSheet(
                                            isScrollControlled: true,
                                            backgroundColor:
                                                themeBottomSheetColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            context: context,
                                            builder: (ctx) =>
                                                ChangeNotifierProvider.value(
                                                    value: context
                                                        .read<PreviewStore>(),
                                                    child:
                                                        PreviewParticipantSheet()),
                                          ),
                                          offColor: themeHintColor,
                                          onColor: themeScreenBackgroundColor,
                                          isActive: true,
                                          child: SvgPicture.asset(
                                            "assets/icons/participants.svg",
                                            color: themeDefaultColor,
                                            fit: BoxFit.scaleDown,
                                            semanticsLabel:
                                                "fl_participants_btn",
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              bottom: 15.0, left: 8, right: 8),
                          child: (previewStore.peer != null)
                              ? Column(
                                  children: [
                                    if (previewStore.peer != null &&
                                        !previewStore.peer!.role.name
                                            .contains("hls-"))
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              if (previewStore.peer != null &&
                                                  context
                                                      .read<PreviewStore>()
                                                      .peer!
                                                      .role
                                                      .publishSettings!
                                                      .allowed
                                                      .contains("audio"))
                                                EmbeddedButton(
                                                  height: 40,
                                                  width: 40,
                                                  onTap: () async =>
                                                      previewStore.switchAudio(
                                                          isOn: previewStore
                                                              .isAudioOn),
                                                  offColor: hmsWhiteColor,
                                                  onColor: themeHMSBorderColor,
                                                  isActive:
                                                      previewStore.isAudioOn,
                                                  child: SvgPicture.asset(
                                                    previewStore.isAudioOn
                                                        ? "assets/icons/mic_state_on.svg"
                                                        : "assets/icons/mic_state_off.svg",
                                                    color:
                                                        previewStore.isAudioOn
                                                            ? themeDefaultColor
                                                            : Colors.black,
                                                    fit: BoxFit.scaleDown,
                                                    semanticsLabel:
                                                        "audio_mute_button",
                                                  ),
                                                ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              if (previewStore.peer != null &&
                                                  previewStore.peer!.role
                                                      .publishSettings!.allowed
                                                      .contains("video"))
                                                EmbeddedButton(
                                                  height: 40,
                                                  width: 40,
                                                  onTap: () async => (previewStore
                                                          .localTracks.isEmpty)
                                                      ? null
                                                      : previewStore
                                                          .switchVideo(
                                                              isOn: previewStore
                                                                  .isVideoOn),
                                                  offColor: hmsWhiteColor,
                                                  onColor: themeHMSBorderColor,
                                                  isActive:
                                                      previewStore.isVideoOn,
                                                  child: SvgPicture.asset(
                                                    previewStore.isVideoOn
                                                        ? "assets/icons/cam_state_on.svg"
                                                        : "assets/icons/cam_state_off.svg",
                                                    color:
                                                        previewStore.isVideoOn
                                                            ? themeDefaultColor
                                                            : Colors.black,
                                                    fit: BoxFit.scaleDown,
                                                    semanticsLabel:
                                                        "video_mute_button",
                                                  ),
                                                ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              if (previewStore.networkQuality !=
                                                      null &&
                                                  previewStore.networkQuality !=
                                                      -1)
                                                EmbeddedButton(
                                                    height: 40,
                                                    width: 40,
                                                    onTap: () {
                                                      switch (previewStore
                                                          .networkQuality) {
                                                        case 0:
                                                          Utilities.showToast(
                                                              "Very Bad network");
                                                          break;
                                                        case 1:
                                                          Utilities.showToast(
                                                              "Poor network");
                                                          break;
                                                        case 2:
                                                          Utilities.showToast(
                                                              "Bad network");
                                                          break;
                                                        case 3:
                                                          Utilities.showToast(
                                                              "Average network");
                                                          break;
                                                        case 4:
                                                          Utilities.showToast(
                                                              "Good network");
                                                          break;
                                                        case 5:
                                                          Utilities.showToast(
                                                              "Best network");
                                                          break;
                                                        default:
                                                          break;
                                                      }
                                                    },
                                                    offColor: dividerColor,
                                                    onColor: dividerColor,
                                                    isActive: true,
                                                    child: SvgPicture.asset(
                                                      'assets/icons/network_${previewStore.networkQuality}.svg',
                                                      fit: BoxFit.scaleDown,
                                                      semanticsLabel:
                                                          "network_button",
                                                    )),
                                            ],
                                          )
                                        ],
                                      ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    HMSButton(
                                      width: width * 0.5,
                                      onPressed: () async => {
                                        context
                                            .read<PreviewStore>()
                                            .removePreviewListener(),
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    ListenableProvider.value(
                                                      value: MeetingStore(
                                                        hmsSDKInteractor:
                                                            previewStore
                                                                .hmsSDKInteractor!,
                                                      ),
                                                      child:
                                                          HLSScreenController(
                                                        streamUrl: context
                                                                .read<
                                                                    PreviewStore>()
                                                                .isStreamingStarted
                                                            ? context
                                                                .read<
                                                                    PreviewStore>()
                                                                .room
                                                                ?.hmshlsStreamingState
                                                                ?.variants[0]
                                                                ?.hlsStreamUrl
                                                            : null,
                                                        isRoomMute: previewStore
                                                            .isRoomMute,
                                                        isStreamingLink:
                                                            widget.meetingFlow ==
                                                                    MeetingFlow
                                                                        .meeting
                                                                ? false
                                                                : true,
                                                        isAudioOn: previewStore
                                                            .isAudioOn,
                                                        meetingLink:
                                                            widget.meetingLink,
                                                        localPeerNetworkQuality:
                                                            previewStore
                                                                .networkQuality,
                                                        user: widget.name,
                                                        role: previewStore
                                                            .peer?.role,
                                                      ),
                                                    )))
                                        // }
                                      },
                                      childWidget: Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 16, 8, 16),
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8))),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text('Enter Studio',
                                                style: GoogleFonts.inter(
                                                    color: enabledTextColor,
                                                    height: 1,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            Icon(
                                              Icons.arrow_forward,
                                              color: enabledTextColor,
                                              size: 16,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox())
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}
