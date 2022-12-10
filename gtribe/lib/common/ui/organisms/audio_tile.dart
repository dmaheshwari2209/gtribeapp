// // Package imports
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// // Project imports
// import 'package:hmssdk_flutter/hmssdk_flutter.dart';

// import '../../../data_store/meeting_store.dart';
// import '../../../model/peer_track_node.dart';
// import '../../util/app_color.dart';
// import '../../util/utility_components.dart';
// import 'audio_level_avatar.dart';
// import 'audio_mute_status.dart';
// import 'brb_tag.dart';
// import 'change_role_options.dart';
// import 'hand_raise.dart';
// import 'local_peer_tile_dialog.dart';
// import 'network_icon_widget.dart';
// import 'peer_name.dart';
// import 'remote_peer_tile_dialog.dart';
// import 'rtc_stats_view.dart';
// import 'tile_border.dart';

// class AudioTile extends StatelessWidget {
//   final double itemHeight;
//   final double itemWidth;
//   final bool isBroadcast;
//   const AudioTile(
//       {this.itemHeight = 200.0,
//       this.itemWidth = 200.0,
//       Key? key,
//       required this.isBroadcast})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     MeetingStore meetingStore = context.read<MeetingStore>();

//     bool mutePermission =
//         meetingStore.localPeer?.role.permissions.mute ?? false;
//     bool unMutePermission =
//         meetingStore.localPeer?.role.permissions.unMute ?? false;
//     bool removePeerPermission =
//         meetingStore.localPeer?.role.permissions.removeOthers ?? false;
//     bool changeRolePermission =
//         meetingStore.localPeer?.role.permissions.changeRole ?? false;

//     return InkWell(
//       onLongPress: () {
//         var peerTrackNode = context.read<PeerTrackNode>();
//         HMSPeer peerNode = peerTrackNode.peer;
//         if (!mutePermission ||
//             !unMutePermission ||
//             !removePeerPermission ||
//             !changeRolePermission) return;
//         if (peerTrackNode.peer.peerId != meetingStore.localPeer!.peerId) {
//           showDialog(
//               context: context,
//               builder: (_) => RemotePeerTileDialog(
//                     isAudioMuted: peerTrackNode.audioTrack?.isMute ?? true,
//                     isVideoMuted: peerTrackNode.track == null
//                         ? true
//                         : peerTrackNode.track!.isMute,
//                     peerName: peerNode.name,
//                     changeVideoTrack: (mute, isVideoTrack) {
//                       Navigator.pop(context);
//                       meetingStore.changeTrackState(peerTrackNode.track!, mute);
//                     },
//                     changeAudioTrack: (mute, isAudioTrack) {
//                       Navigator.pop(context);
//                       meetingStore.changeTrackState(
//                           peerTrackNode.audioTrack!, mute);
//                     },
//                     removePeer: () async {
//                       Navigator.pop(context);
//                       var peer =
//                           await meetingStore.getPeer(peerId: peerNode.peerId);
//                       meetingStore.removePeerFromRoom(peer!);
//                     },
//                     changeRole: () {
//                       Navigator.pop(context);
//                       showDialog(
//                           context: context,
//                           builder: (_) => ChangeRoleOptionDialog(
//                                 peerName: peerNode.name,
//                                 roles: meetingStore.roles,
//                                 peer: peerNode,
//                                 changeRole: (role, forceChange) {
//                                   Navigator.pop(context);
//                                   meetingStore.changeRole(
//                                       peer: peerNode,
//                                       roleName: role,
//                                       forceChange: forceChange);
//                                 },
//                               ));
//                     },
//                     mute: mutePermission,
//                     unMute: unMutePermission,
//                     removeOthers: removePeerPermission,
//                     roles: changeRolePermission,
//                   ));
//         } else {
//           showDialog(
//               context: context,
//               builder: (_) => LocalPeerTileDialog(
//                   isAudioMode: true,
//                   toggleCamera: () {
//                     if (meetingStore.isVideoOn) meetingStore.switchCamera();
//                   },
//                   peerName: peerNode.name,
//                   changeRole: () {
//                     Navigator.pop(context);
//                     showDialog(
//                         context: context,
//                         builder: (_) => ChangeRoleOptionDialog(
//                               peerName: peerNode.name,
//                               roles: meetingStore.roles,
//                               peer: peerNode,
//                               changeRole: (role, forceChange) {
//                                 Navigator.pop(context);
//                                 meetingStore.changeRole(
//                                     peer: peerNode,
//                                     roleName: role,
//                                     forceChange: forceChange);
//                               },
//                             ));
//                   },
//                   roles: changeRolePermission,
//                   changeName: () async {
//                     String name = await UtilityComponents.showInputDialog(
//                         context: context, placeholder: "Enter Name");
//                     if (name.isNotEmpty) {
//                       meetingStore.changeName(name: name);
//                     }
//                   }));
//         }
//       },
//       child: Container(
//         key: key,
//         padding: const EdgeInsets.all(2),
//         margin: const EdgeInsets.all(2),
//         height: itemHeight + 110,
//         width: itemWidth - 5.0,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: themeBottomSheetColor,
//         ),
//         child: Semantics(
//           label: "${context.read<PeerTrackNode>().peer.name}_audio",
//           child: Stack(
//             children: [
//               const Center(child: AudioLevelAvatar()),
//               Positioned(
//                 //Bottom left
//                 bottom: 5,
//                 left: 5,
//                 child: Container(
//                   decoration: BoxDecoration(
//                       color: const Color.fromRGBO(0, 0, 0, 0.9),
//                       borderRadius: BorderRadius.circular(8)),
//                   child: Center(
//                     child: Padding(
//                       padding: const EdgeInsets.all(4),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           NetworkIconWidget(),
//                           PeerName(),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               HandRaise(), //bottom left
//               BRBTag(), //top right
//               AudioMuteStatus(), //bottom center
//               RTCStatsView(isLocal: context.read<PeerTrackNode>().peer.isLocal),
//               TileBorder(
//                   name: context.read<PeerTrackNode>().peer.name,
//                   itemHeight: itemHeight,
//                   itemWidth: itemWidth,
//                   uid: context.read<PeerTrackNode>().uid)
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
