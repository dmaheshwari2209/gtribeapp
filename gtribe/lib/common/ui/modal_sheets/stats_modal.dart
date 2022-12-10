// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gtribe/common/ui/buttons/primary_button.dart';
import 'package:gtribe/common/ui/modal_sheets/component/modal_sheet_bar.dart';
import 'package:gtribe/common/util/app_color.dart';
import 'package:gtribe/common/util/utility_function.dart';
import 'package:gtribe/utils/assets.dart';

class StatsModal extends StatefulWidget {
  const StatsModal({
    Key? key,
  }) : super(key: key);

  @override
  State<StatsModal> createState() => _StatsModalState();
}

class _StatsModalState extends State<StatsModal> {
  bool collaped = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Utilities().screenWidth(context),
      decoration: BoxDecoration(
          color: modalBackground,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24), topRight: Radius.circular(24))),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Utilities.horizontalPadding,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 24,
              ),
              const Center(child: ModalSheetBar()),
              const SizedBox(
                height: 20,
              ),
              Text(
                'PLAYER\'S IN-GAME STATS',
                style: Utilities.spacedStyle,
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getColumn('Current Rank', '33'),
                  getColumn('Highest Score', '930'),
                  getColumn('Average Score', '155')
                ],
              ),
              const SizedBox(
                height: 32,
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                child: collaped
                    ? Container(
                        child: showMore(),
                      )
                    : Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              getColumn('Hours Played', '200h'),
                              getColumn('Global Highest', '1230'),
                              getColumn('Global Average', '40'),
                            ],
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Image.asset('assets/graph.png'),
                          const SizedBox(
                            height: 24,
                          ),
                          showMore(),
                        ],
                      ),
              ),
              const SizedBox(
                height: 32,
              ),
              Text(
                'CHEER / BOO',
                style: Utilities.spacedStyle,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                'Will Nikhil beat their high score?',
                style: Utilities.simpleStyle,
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                children: const [],
              ),
              Row(),
              PrimaryButton(
                label: '',
                onTap: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Cheer for',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SvgPicture.asset(GameAssets.coinIcon),
                    ),
                    const Text(
                      '10',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              // Text(
              //   modalEnum == ModalEnum.abandoned
              //       ? 'The game was'
              //       : 'Your Prediction was',
              //   style: Utilities.simpleStyle,
              // ),
              // const SizedBox(
              //   height: 8,
              // ),
              // Text(
              //   modalEnum == ModalEnum.abandoned
              //       ? 'The game was'
              //       : 'Your Prediction was',
              //   style:
              //       Utilities.simpleStyle.copyWith(fontWeight: FontWeight.w900),
              // ),
              // const SizedBox(height: 12),
              // ResultBatch(modalEnum: modalEnum),
              // const SizedBox(
              //   height: 20,
              // ),
              // getButton(),
              // const SizedBox(
              //   height: 40,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getColumn(String title, String data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Utilities.simpleStyle
              .copyWith(color: Colors.white.withOpacity(0.4), fontSize: 13),
        ),
        Text(
          data,
          style: Utilities.simpleStyle.copyWith(color: Colors.white),
        )
      ],
    );
  }

  Widget showMore() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 2,
          color: Colors.white.withOpacity(0.3),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              collaped = !collaped;
            });
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: 4,
              ),
              const Text('See More'),
              const SizedBox(
                width: 4,
              ),
              Icon(
                collaped ? Icons.expand_more : Icons.expand_less,
                size: 30,
              ),
              const SizedBox(
                width: 4,
              ),
            ],
          ),
        ),
        Container(
          height: 2,
          color: Colors.white.withOpacity(0.3),
        ),
      ],
    );
  }

  // Widget getOptionRow(bool yes) {
  //   return Row(
  //     children: [
  //       Text(yes ? 'Yes' : 'No', style: Utilities.simpleStyle.copyWith(color: Colors.white.withOpacity(yes ? 1 : 0.4)),),
  //       Container(
  //         height: 50,
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(12),
  //           border: Border.all(color: yes ? Colors.white : Colors.white.withOpacity(0.2), width: 2),
  //         ),
  //         child: ,
  //       )
  //     ],
  //   );
  // }
}
