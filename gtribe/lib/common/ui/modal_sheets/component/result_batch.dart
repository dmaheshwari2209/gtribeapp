// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:gtribe/common/util/utility_function.dart';
import 'package:gtribe/enum/modal_enum.dart';

class ResultBatch extends StatelessWidget {
  const ResultBatch({
    Key? key,
    required this.modalEnum,
  }) : super(key: key);
  final ModalEnum modalEnum;

  Color getBorderColor() {
    if (modalEnum == ModalEnum.right) {
      return Colors.green;
    } else if (modalEnum == ModalEnum.wrong) {
      return Colors.pink;
    } else {
      return Colors.white.withOpacity(0.3);
    }
  }

  Color getColor() {
    if (modalEnum == ModalEnum.right) {
      return Colors.green.withOpacity(0.4);
    } else if (modalEnum == ModalEnum.wrong) {
      return Colors.pink.withOpacity(0.4);
    } else {
      return Colors.transparent;
    }
  }

  String getText() {
    if (modalEnum == ModalEnum.right) {
      return 'YOU WON';
    } else if (modalEnum == ModalEnum.wrong) {
      return 'YOU LOST';
    } else {
      return 'REFUND';
    }
  }

  String getNum() {
    if (modalEnum == ModalEnum.right) {
      return '25';
    } else if (modalEnum == ModalEnum.wrong) {
      return '10';
    } else {
      return '10';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 100),
      height: 76,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: getColor(),
          border: Border.all(color: getBorderColor(), width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            getText(),
            style: Utilities.spacedStyle.copyWith(color: Colors.white),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                getNum(),
                style: Utilities.simpleStyle,
              )
            ],
          )
        ],
      ),
    );
  }
}
