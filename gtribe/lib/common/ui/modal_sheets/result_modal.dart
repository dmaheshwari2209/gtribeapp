// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:gtribe/common/ui/buttons/primary_button.dart';
import 'package:gtribe/common/ui/buttons/secondary_button.dart';
import 'package:gtribe/common/ui/modal_sheets/component/modal_sheet_bar.dart';
import 'package:gtribe/common/ui/modal_sheets/component/result_batch.dart';
import 'package:gtribe/common/util/app_color.dart';
import 'package:gtribe/common/util/utility_function.dart';
import 'package:gtribe/enum/modal_enum.dart';

class ResultModal extends StatelessWidget {
  const ResultModal({
    Key? key,
    required this.modalEnum,
  }) : super(key: key);
  final ModalEnum modalEnum;

  String getText() {
    if (modalEnum == ModalEnum.right) {
      return 'Right!';
    } else if (modalEnum == ModalEnum.wrong) {
      return 'Wrong';
    } else {
      return 'Abandoned';
    }
  }

  Widget getButton() {
    if (modalEnum == ModalEnum.right) {
      return PrimaryButton(label: 'Collect Coins', onTap: () {});
    } else if (modalEnum == ModalEnum.wrong) {
      return SecondaryButton(label: 'Try Again', onTap: () {});
    } else {
      return PrimaryButton(label: 'See More Games', onTap: () {});
    }
  }

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 12,
            ),
            const Center(child: ModalSheetBar()),
            const SizedBox(
              height: 42,
            ),
            Text(
              'RESULTS ARE IN',
              style: Utilities.spacedStyle,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              modalEnum == ModalEnum.abandoned
                  ? 'The game was'
                  : 'Your Prediction was',
              style: Utilities.simpleStyle,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              getText(),
              style:
                  Utilities.simpleStyle.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            ResultBatch(modalEnum: modalEnum),
            const SizedBox(
              height: 20,
            ),
            getButton(),
            const SizedBox(
              height: 60,
            ),
          ],
        ),
      ),
    );
  }
}
