import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gtribe/common/ui/organisms/hms_listenable_button.dart';
import 'package:gtribe/common/util/app_color.dart';
import 'package:gtribe/common/util/utility_function.dart';
import 'package:gtribe/data_store/meeting_store_broadcast.dart';
import 'package:gtribe/enum/meeting_flow.dart';
import 'package:gtribe/hls-streaming/hls_screen_controller.dart';
import 'package:gtribe/hms_sdk_interactor.dart';
import 'package:gtribe/preview/preview_page.dart';
import 'package:gtribe/preview/preview_store.dart';
import 'package:provider/provider.dart';

class PreviewDetails extends StatefulWidget {
  final String meetingLink;
  final MeetingFlow meetingFlow;
  final bool autofocusField;
  const PreviewDetails({
    Key? key,
    required this.meetingLink,
    required this.meetingFlow,
    this.autofocusField = false,
  }) : super(key: key);
  @override
  State<PreviewDetails> createState() => _PreviewDetailsState();
}

class _PreviewDetailsState extends State<PreviewDetails> {
  TextEditingController nameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    nameController.text = await Utilities.getStringData(key: "name");
    nameController.selection = TextSelection.fromPosition(
        TextPosition(offset: nameController.text.length));
    setState(() {});
  }

  void showPreview(bool res) async {
    if (nameController.text.isEmpty) {
      // Utilities.showToast("Please enter you name");
    } else {
      Utilities.saveStringData(key: "name", value: nameController.text.trim());
      res = await Utilities.getPermissions();
      bool skipPreview =
          await Utilities.getBoolData(key: 'skip-preview') ?? false;
      bool joinWithMutedAudio =
          await Utilities.getBoolData(key: 'join-with-muted-audio') ?? true;
      bool joinWithMutedVideo =
          await Utilities.getBoolData(key: 'join-with-muted-video') ?? true;
      bool isSoftwareDecoderDisabled =
          await Utilities.getBoolData(key: 'software-decoder-disabled') ?? true;
      bool isAudioMixerDisabled =
          await Utilities.getBoolData(key: 'audio-mixer-disabled') ?? true;
      if (res) {
        if (!skipPreview) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (_) => ListenableProvider.value(
                    value: PreviewStore(
                        joinWithMutedAudio: joinWithMutedAudio,
                        joinWithMutedVideo: joinWithMutedVideo,
                        isSoftwareDecoderDisabled: isSoftwareDecoderDisabled,
                        isAudioMixerDisabled: isAudioMixerDisabled),
                    child: PreviewPage(
                        meetingFlow: widget.meetingFlow,
                        name: nameController.text,
                        meetingLink: widget.meetingLink),
                  )));
        } else {
          bool showStats =
              await Utilities.getBoolData(key: 'show-stats') ?? false;
          bool mirrorCamera =
              await Utilities.getBoolData(key: 'mirror-camera') ?? false;
          HMSSDKInteractor hmsSDKInteractor = HMSSDKInteractor(
              appGroup: "group.flutterhms",
              preferredExtension:
                  "live.100ms.flutter.FlutterBroadcastUploadExtension",
              joinWithMutedAudio: joinWithMutedAudio,
              joinWithMutedVideo: joinWithMutedVideo,
              isSoftwareDecoderDisabled: isSoftwareDecoderDisabled,
              isAudioMixerDisabled: isAudioMixerDisabled);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => ListenableProvider.value(
                value:
                    MeetingStoreBroadcast(hmsSDKInteractor: hmsSDKInteractor),
                child: HLSScreenController(
                  isBroadcast: true,
                  isRoomMute: false,
                  isStreamingLink:
                      widget.meetingFlow == MeetingFlow.meeting ? false : true,
                  isAudioOn: true,
                  meetingLink: widget.meetingLink,
                  localPeerNetworkQuality: -1,
                  user: nameController.text.trim(),
                  mirrorCamera: mirrorCamera,
                  showStats: showStats,
                ),
              ),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool res = false;
    return Scaffold(
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/user-music.svg',
              width: width / 4,
            ),
            const SizedBox(
              height: 40,
            ),
            Text("Go live in five!",
                style: GoogleFonts.inter(
                    color: themeDefaultColor,
                    fontSize: 34,
                    fontWeight: FontWeight.w600)),
            const SizedBox(
              height: 4,
            ),
            Text("Let's get started with your name",
                style: GoogleFonts.inter(
                    color: themeSubHeadingColor,
                    height: 1.5,
                    fontSize: 16,
                    fontWeight: FontWeight.w400)),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: width * 0.95,
              child: TextField(
                textInputAction: TextInputAction.done,
                onSubmitted: (value) {
                  showPreview(res);
                },
                autofocus: widget.autofocusField,
                textCapitalization: TextCapitalization.words,
                style: GoogleFonts.inter(),
                controller: nameController,
                keyboardType: TextInputType.name,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                    suffixIcon: nameController.text.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              nameController.text = "";
                              setState(() {});
                            },
                            icon: const Icon(Icons.clear),
                          ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 16),
                    fillColor: themeSurfaceColor,
                    filled: true,
                    hintText: 'Enter your name here',
                    hintStyle: GoogleFonts.inter(
                        color: themeHintColor,
                        height: 1.5,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: borderColor, width: 1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8))),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)))),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            HMSListenableButton(
                width: width * 0.5,
                onPressed: () async => {
                      FocusManager.instance.primaryFocus?.unfocus(),
                      showPreview(res),
                    },
                childWidget: Container(
                  padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Get Started',
                          style: GoogleFonts.inter(
                              color: nameController.text.isEmpty
                                  ? themeDisabledTextColor
                                  : enabledTextColor,
                              height: 1,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(
                        width: 4,
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: nameController.text.isEmpty
                            ? themeDisabledTextColor
                            : enabledTextColor,
                        size: 16,
                      )
                    ],
                  ),
                ),
                textController: nameController,
                errorMessage: "Please enter you name")
          ],
        ),
      )),
    );
  }
}
