//package imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../hls-streaming/util/hls_subtitle_text.dart';
import '../../../model/peer_track_node.dart';
import '../../util/app_color.dart';
import 'audio_level_avatar.dart';

//Package imports

class DegradeTile extends StatefulWidget {
  final double itemHeight;

  final double itemWidth;
  const DegradeTile({
    Key? key,
    this.itemHeight = 200,
    this.itemWidth = 200,
  }) : super(key: key);

  @override
  State<DegradeTile> createState() => _DegradeTileState();
}

class _DegradeTileState extends State<DegradeTile> {
  @override
  Widget build(BuildContext context) {
    return Selector<PeerTrackNode, bool>(
        builder: (_, data, __) {
          return Visibility(
              visible: data,
              child: Container(
                height: widget.itemHeight + 110,
                width: widget.itemWidth - 4,
                decoration: BoxDecoration(
                    color: themeBottomSheetColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Stack(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 45.0),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: HLSSubtitleText(
                            text: "DEGRADED", textColor: Colors.white),
                      ),
                    ),
                    Positioned(
                      bottom: 5.0,
                      right: 5.0,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                        child: SvgPicture.asset(
                          'assets/icons/degrade.svg',
                        ),
                      ),
                    ),
                    const AudioLevelAvatar()
                  ],
                ),
              ));
        },
        selector: (_, peerTrackNode) =>
            peerTrackNode.track?.isDegraded ?? false);
  }
}
