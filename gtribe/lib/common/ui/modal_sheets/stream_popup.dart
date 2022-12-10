import 'package:flutter/material.dart';
import 'package:gtribe/common/ui/buttons/primary_button.dart';
import 'package:gtribe/common/ui/buttons/secondary_button.dart';
import 'package:gtribe/common/ui/modal_sheets/component/modal_sheet_bar.dart';
import 'package:gtribe/common/util/app_color.dart';
import 'package:gtribe/common/util/utility_function.dart';

class StreamPopup extends StatelessWidget {
  const StreamPopup({Key? key}) : super(key: key);

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
        child: ListView(
          shrinkWrap: true,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: ModalSheetBar()),
            const SizedBox(
              height: 42,
            ),
            Text(
              'STREAM & EARN',
              style: Utilities.spacedStyle,
            ),
            const SizedBox(
              height: 8,
            ),
            SizedBox(
              width: Utilities().screenWidth(context) * 0.55,
              child: Text(
                'Stream for atleast 10 mins and earn.',
                style:
                    Utilities.simpleStyle.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PrimaryButton(label: 'Start', onTap: () {}),
                SecondaryButton(label: 'Cancel', onTap: () {})
              ],
            ),
            const SizedBox(
              height: 84,
            ),
          ],
        ),
      ),
    );
  }
}
