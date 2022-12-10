// //Package imports
// import 'package:flutter/material.dart';
// import 'package:gtribe/common/util/utility_function.dart';
// import 'package:provider/provider.dart';

// //Project imports
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:hmssdk_flutter/hmssdk_flutter.dart';
// import 'package:gtribe/common/ui/organisms/video_tile.dart';
// import 'package:gtribe/data_store/meeting_store.dart';
// import 'package:gtribe/model/peer_track_node.dart';

// Widget hlsGridView(
//     {required List<PeerTrackNode> peerTracks,
//     required int itemCount,
//     required int screenShareCount,
//     required BuildContext context,
//     required bool isPortrait,
//     required Size size}) {
//   return GridView.builder(
//       shrinkWrap: true,
//       itemCount: itemCount,
//       scrollDirection: Axis.horizontal,
//       physics: const PageScrollPhysics(),
//       itemBuilder: (context, index) {
//         if (peerTracks[index].track != null &&
//             peerTracks[index].track?.source != "REGULAR") {
//           return ChangeNotifierProvider.value(
//             key: ValueKey("${peerTracks[index].uid}video_view"),
//             value: peerTracks[index],
//             child: VideoTile(
//               islongPressEnabled: false,
//               key: Key("${peerTracks[index].uid}video_tile"),
//               scaleType: ScaleType.SCALE_ASPECT_FIT,
//               itemHeight: size.height,
//               itemWidth: size.width,
//             ),
//           );
//         }

//         if (screenShareCount == 0 &&
//             index < 4 &&
//             peerTracks[index].isOffscreen) {
//           peerTracks[index].setOffScreenStatus(false);
//         }
//         return ChangeNotifierProvider.value(
//             key: ValueKey("${peerTracks[index].uid}video_view"),
//             value: peerTracks[index],
//             child: VideoTile(
//               islongPressEnabled: false,
//               key: ValueKey("${peerTracks[index].uid}audio_view"),
//               itemHeight: size.height,
//               itemWidth: size.width,
//             ));
//       },
//       controller: Provider.of<MeetingStore>(context).controller,
//       gridDelegate: SliverStairedGridDelegate(
//           startCrossAxisDirectionReversed: true,
//           pattern: isPortrait
//               ? portraitPattern(itemCount, screenShareCount, size, context)
//               : landscapePattern(itemCount, screenShareCount, size, context)));
// }

// List<StairedGridTile> portraitPattern(
//     int itemCount, int screenShareCount, Size size, BuildContext context) {
//   double ratio = Utilities.getHLSRatio(size, context);
//   List<StairedGridTile> tiles = [];
//   for (int i = 0; i < screenShareCount; i++) {
//     tiles.add(StairedGridTile(1, ratio));
//   }
//   int normalTile = (itemCount - screenShareCount);
//   int gridView = normalTile ~/ 4;
//   int tileLeft = normalTile - (gridView * 4);
//   for (int i = 0; i < (normalTile - tileLeft); i++) {
//     tiles.add(StairedGridTile(0.5, ratio));
//   }
//   if (tileLeft == 1) {
//     tiles.add(StairedGridTile(1, ratio));
//   } else if (tileLeft == 2) {
//     tiles.add(StairedGridTile(0.5, ratio / 2));
//     tiles.add(StairedGridTile(0.5, ratio / 2));
//   } else {
//     tiles.add(StairedGridTile(0.5, ratio / 2));
//     tiles.add(StairedGridTile(0.5, ratio / 2));
//     tiles.add(StairedGridTile(1, ratio));
//   }
//   return tiles;
// }

// List<StairedGridTile> landscapePattern(
//     int itemCount, int screenShareCount, Size size, BuildContext context) {
//   double ratio = Utilities.getHLSRatio(size, context);
//   List<StairedGridTile> tiles = [];
//   for (int i = 0; i < screenShareCount; i++) {
//     tiles.add(StairedGridTile(1, ratio));
//   }
//   int normalTile = (itemCount - screenShareCount);
//   int gridView = normalTile ~/ 2;
//   int tileLeft = normalTile - (gridView * 2);
//   for (int i = 0; i < (normalTile - tileLeft); i++) {
//     tiles.add(StairedGridTile(1, ratio / 0.5));
//   }
//   if (tileLeft == 1) tiles.add(StairedGridTile(1, ratio));

//   return tiles;
// }
