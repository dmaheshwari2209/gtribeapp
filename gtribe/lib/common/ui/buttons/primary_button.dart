// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:gtribe/common/util/app_color.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    Key? key,
    required this.label,
    required this.onTap,
    this.child,
  }) : super(key: key);
  final String label;
  final Function onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        height: 48,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: primaryButtonGradient),
            borderRadius: const BorderRadius.all(Radius.circular(48))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Center(
            child: child ??
                Text(
                  label,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
          ),
        ),
      ),
    );
  }
}
