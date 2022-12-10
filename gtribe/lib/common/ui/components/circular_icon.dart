import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/assets.dart';

enum IconsType {
  LIKE_ON,
  LIKE_OFF,
  STREAM_ON,
  STREAM_OFF,
  STATS,
  EXIT,
  TREND,
}

Map<IconsType, String> assetMap = {
  IconsType.LIKE_ON: GameAssets.likeOnIcon,
  IconsType.LIKE_OFF: GameAssets.likeOffIcon,
  IconsType.STATS: GameAssets.trendsIcon,
  IconsType.EXIT: GameAssets.backIcon,
  IconsType.TREND: GameAssets.trendsIcon,
  IconsType.STREAM_OFF: GameAssets.streamOffIcon,
  IconsType.STREAM_ON: GameAssets.streamOnIcon,
};

//  {Key? key, required this.toggle, required this.tabScrollController, required this.isSavedAdvices})
//       : super(key: key);
//   final Function toggle;
class CircularIcon extends StatelessWidget {
  final IconsType iconType;
  const CircularIcon({Key? key, required this.iconType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black38,
        border: Border.all(color: Colors.white),
      ),
      child: Center(
        child: SvgPicture.asset(
          assetMap[iconType] ?? GameAssets.playingIcon,
          height: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}
