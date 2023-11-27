import 'dart:async';

import 'package:expat_info/provider/sign_in_provider.dart';
import 'package:expat_info/screens/display_info.dart';
import 'package:expat_info/screens/Update_info.dart';
import 'package:expat_info/screens/login_page.dart';
import 'package:expat_info/screens/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    final sp = context.read<SignInProvider>();

    super.initState();

    Timer(const Duration(seconds: 3), () {
      sp.isSignedIn == false
          ? nextScreen(() => const LoginScreen())
          : nextScreen(() => const DisplayInfo());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Image.asset(
          "lib/assets/expatswap1.jpeg",
          height: 200,
          width: 100,
        ),
      ),
    );
  }
}
