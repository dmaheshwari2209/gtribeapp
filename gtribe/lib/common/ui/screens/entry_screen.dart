import 'package:flutter/material.dart';
import 'package:gtribe/common/ui/buttons/primary_button.dart';
import 'package:gtribe/common/ui/screens/components/custom_textfield.dart';
import 'package:gtribe/common/ui/screens/home_screen.dart';
import 'package:gtribe/common/util/utility_function.dart';
import 'package:gtribe/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EntryScreen extends StatefulWidget {
  const EntryScreen({Key? key}) : super(key: key);

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  final TextEditingController textController = TextEditingController();

  Future saveUsername() async {
    Utilities.userName = textController.text;
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(USERNAME, textController.text);
  }

  void onTap() {
    if (textController.text == '') return;
    saveUsername();
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (_) {
        return const HomePage();
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: Utilities().screenHeight(context),
          width: Utilities().screenWidth(context),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Image.asset(
                'assets/entry.jpg',
                fit: BoxFit.cover,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Utilities().screenWidth(context) * 0.1),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    CustomTextfield(
                      textController: textController,
                      onTap: onTap,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    PrimaryButton(label: 'Let\'s go!', onTap: onTap),
                    const SizedBox(
                      height: 80,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
