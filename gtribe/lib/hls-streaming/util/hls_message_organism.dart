// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gtribe/common/util/app_color.dart';
import 'package:gtribe/data_store/meeting_store_broadcast.dart';
import 'package:gtribe/hls-streaming/util/hls_subtitle_text.dart';
import 'package:gtribe/hls-streaming/util/hls_title_text.dart';
import 'package:provider/provider.dart';

import '../../data_store/meeting_store.dart';

class HLSMessageOrganism extends StatelessWidget {
  final String message;
  final bool isLocalMessage;
  final String? senderName;
  final String date;
  final String role;
  final bool isBroadcast;
  const HLSMessageOrganism({
    Key? key,
    required this.message,
    required this.isLocalMessage,
    required this.senderName,
    required this.date,
    required this.role,
    required this.isBroadcast,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Align(
      alignment: isLocalMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: width - (role == "" ? 80 : 60),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: themeSurfaceColor),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            constraints: BoxConstraints(
                                maxWidth:
                                    role != "" ? width * 0.25 : width * 0.5),
                            child: HLSTitleText(
                              text: senderName ?? "Anonymous",
                              fontSize: 14,
                              letterSpacing: 0.1,
                              lineHeight: 20,
                              textColor: themeDefaultColor,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          HLSSubtitleText(
                              text: date, textColor: themeSubHeadingColor),
                        ],
                      ),
                      (role != "" || isLocalMessage)
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: role != ""
                                          ? Border.all(
                                              color: borderColor, width: 1)
                                          : const Border.symmetric()),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        if (role != "PRIVATE")
                                          Text(
                                            (isLocalMessage ? "" : "TO"),
                                            style: GoogleFonts.inter(
                                                fontSize: 10.0,
                                                color: themeSubHeadingColor,
                                                letterSpacing: 1.5,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        (isLocalMessage || (role == "PRIVATE"))
                                            ? const SizedBox()
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 2),
                                                child: Text(
                                                  "|",
                                                  style: GoogleFonts.inter(
                                                      fontSize: 10.0,
                                                      color: borderColor,
                                                      letterSpacing: 1.5,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )),
                                        role != ""
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    constraints: BoxConstraints(
                                                        maxWidth: isLocalMessage
                                                            ? width * 0.25
                                                            : width * 0.15),
                                                    child: Text(
                                                      "${role.toUpperCase()} ",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts.inter(
                                                          fontSize: 10.0,
                                                          color:
                                                              themeDefaultColor,
                                                          letterSpacing: 1.5,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox()
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    message,
                    style: GoogleFonts.inter(
                        fontSize: 14.0,
                        color: themeDefaultColor,
                        letterSpacing: 0.25,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            if (role == "")
              Positioned(
                top: 0,
                right: 0,
                bottom: 0,
                child: PopupMenuButton(
                  color: themeSurfaceColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  itemBuilder: (context) {
                    return List.generate(1, (index) {
                      return PopupMenuItem(
                          child: const Text('Pin Message'),
                          onTap: () => (isBroadcast
                              ? context
                                  .read<MeetingStoreBroadcast>()
                                  .setSessionMetadata(
                                      "${senderName!}: $message")
                              : context.read<MeetingStore>().setSessionMetadata(
                                  "${senderName!}: $message")));
                    });
                  },
                  child: SvgPicture.asset(
                    "assets/icons/more.svg",
                    fit: BoxFit.scaleDown,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
