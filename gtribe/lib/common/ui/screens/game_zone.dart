// import 'package:flutter/material.dart';
// import 'package:hackathon_app/components/circular_icon.dart';
// import 'package:hackathon_app/data/api/game_api.dart';
// import 'package:hackathon_app/util/assets.dart';
// import 'package:hackathon_app/util/media_query.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class GameZoneScreen extends StatefulWidget {
//   // const GameZoneScreen({Key? key, required this.currentNews}) : super(key: key);
//   // final NewsModel currentNews;

//   const GameZoneScreen({
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<GameZoneScreen> createState() => _GameZoneScreenState();
// }

// class _GameZoneScreenState extends State<GameZoneScreen> {
//   static int points = 183;
//   static int views = 250;
//   static double rating = 4.4;
//   static int gamesPlayed = 224;
//   static bool firstPerson = false;
//   static bool showBanner = true;
//   static String userName = 'Nikhil K.';
//   static String gameName = 'Tower Game';

//   @override
//   void initState() {
//     // scrollExtent = 0;
//     super.initState();
//   }

//   @override
//   void didChangeDependencies() {
//     GameApi().startGame().then((value) {
//       GameApi().getStreams();
//       GameApi().viewGame('Divyansh', 'Rishabh');
//     });

//     super.didChangeDependencies();
//   }

//   @override
//   void dispose() {
//     // _scrollController!.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double width = displayWidth(context);
//     double height = displayHeight(context);

//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         body: SizedBox(
//           height: height,
//           width: width,
//           child: Stack(
//             children: [
//               topBar(width, height),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget topBar(double width, double height) {
//     return showBanner
//         ? AnimatedSwitcher(
//             duration: const Duration(milliseconds: 500),
//             child: SizedBox(
//               width: width,
//               height: height * 0.15,
//               child: Column(children: [
//                 SizedBox(
//                   width: width,
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 20.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(firstPerson ? 'Play' : 'Streams',
//                             style: const TextStyle(
//                               fontFamily: 'Be Vietnam Pro',
//                               fontStyle: FontStyle.normal,
//                               fontWeight: FontWeight.w700,
//                               fontSize: 24,
//                               color: Colors.white,
//                             )),
//                         Container(
//                           height: 42,
//                           width: width * 0.25 + 5,
//                           padding:
//                               const EdgeInsets.only(top: 1, bottom: 1, left: 1),
//                           decoration: const BoxDecoration(
//                               borderRadius: BorderRadius.only(
//                                   bottomLeft: Radius.circular(12),
//                                   topLeft: Radius.circular(12)),
//                               gradient: LinearGradient(
//                                 begin: Alignment.topRight,
//                                 end: Alignment.bottomLeft,
//                                 colors: [
//                                   Color(0xffE09422),
//                                   Color(0xffDA13AE),
//                                 ],
//                               )),
//                           child: Container(
//                             height: 40,
//                             width: width * 0.25,
//                             decoration: const BoxDecoration(
//                                 color: Color.fromARGB(255, 54, 25, 25),
//                                 borderRadius: BorderRadius.only(
//                                     bottomLeft: Radius.circular(12),
//                                     topLeft: Radius.circular(12))),
//                             child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   SvgPicture.asset(
//                                     GameAssets.coinIcon,
//                                     height: 15,
//                                     color: Colors.white,
//                                   ),
//                                   SizedBox(width: 5),
//                                   Text(points.ceil().toString(),
//                                       style: TextStyle(
//                                         fontFamily: 'Be Vietnam Pro',
//                                         fontStyle: FontStyle.normal,
//                                         fontWeight: FontWeight.w700,
//                                         fontSize: 16,
//                                         color: Colors.white,
//                                       )),
//                                 ]),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           const CircleAvatar(
//                             backgroundColor: Colors.white,
//                           ),
//                           const SizedBox(
//                             width: 8,
//                           ),
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Text(firstPerson ? gameName : userName,
//                                   style: const TextStyle(
//                                     fontFamily: 'Be Vietnam Pro',
//                                     fontStyle: FontStyle.normal,
//                                     fontWeight: FontWeight.w700,
//                                     fontSize: 16,
//                                     color: Colors.white,
//                                   )),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   !firstPerson
//                                       ? SvgPicture.asset(
//                                           GameAssets.viewingIcon,
//                                           height: 20,
//                                           color: Colors.white,
//                                         )
//                                       : const SizedBox(),
//                                   !firstPerson
//                                       ? Text('$views',
//                                           style: const TextStyle(
//                                             fontFamily: 'Be Vietnam Pro',
//                                             fontStyle: FontStyle.normal,
//                                             fontWeight: FontWeight.w400,
//                                             fontSize: 12,
//                                             color: Colors.white,
//                                           ))
//                                       : const SizedBox(),
//                                   firstPerson
//                                       ? Text('$rating',
//                                           style: const TextStyle(
//                                             fontFamily: 'Be Vietnam Pro',
//                                             fontStyle: FontStyle.normal,
//                                             fontWeight: FontWeight.w400,
//                                             fontSize: 12,
//                                             color: Colors.white,
//                                           ))
//                                       : const SizedBox(),
//                                   firstPerson
//                                       ? const SizedBox(width: 8)
//                                       : const SizedBox(),
//                                   firstPerson
//                                       ? Text('$gamesPlayed',
//                                           style: const TextStyle(
//                                             fontFamily: 'Be Vietnam Pro',
//                                             fontStyle: FontStyle.normal,
//                                             fontWeight: FontWeight.w400,
//                                             fontSize: 12,
//                                             color: Colors.white,
//                                           ))
//                                       : const SizedBox(),
//                                 ],
//                               )
//                             ],
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           CircularIcon(
//                               iconType: !firstPerson
//                                   ? IconsType.LIKE_OFF
//                                   : IconsType.STREAM_OFF),
//                           const SizedBox(
//                             width: 8,
//                           ),
//                           CircularIcon(
//                               iconType: !firstPerson
//                                   ? IconsType.STATS
//                                   : IconsType.EXIT),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ]),
//             ),
//           )
//         : SizedBox(
//             height: height * 0.1,
//             child: const Center(
//               child: Text('Swipe from top to bring the menu',
//                   style: TextStyle(
//                     fontFamily: 'Be Vietnam Pro',
//                     fontStyle: FontStyle.normal,
//                     fontWeight: FontWeight.w300,
//                     fontSize: 16,
//                     color: Colors.white,
//                   )),
//             ),
//           );
//   }
// }
