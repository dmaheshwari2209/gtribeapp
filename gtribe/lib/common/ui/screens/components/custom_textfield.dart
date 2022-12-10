// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:gtribe/common/util/utility_function.dart';

class CustomTextfield extends StatefulWidget {
  const CustomTextfield({
    Key? key,
    required this.textController,
    required this.onTap,
  }) : super(key: key);
  final TextEditingController textController;
  final Function onTap;

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(40))),
      width: Utilities().screenWidth(context) * 0.7,
      height: 48,
      child: Center(
        child: TextField(
          enableSuggestions: false,
          autocorrect: false,
          controller: widget.textController,
          textInputAction: TextInputAction.go,
          onSubmitted: (value) {
            widget.onTap();
          },
          cursorColor: Colors.black,
          style: const TextStyle(
              color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
          decoration: InputDecoration(
            enabledBorder:
                const UnderlineInputBorder(borderSide: BorderSide.none),
            focusedBorder:
                const UnderlineInputBorder(borderSide: BorderSide.none),
            hintText: 'Username',
            hintStyle: TextStyle(
              color: Colors.black.withOpacity(0.4),
            ),
          ),
        ),
      ),
    );
  }
}
