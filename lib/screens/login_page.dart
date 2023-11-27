import 'package:expat_info/provider/internet_provider.dart';
import 'package:expat_info/provider/sign_in_provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:expat_info/screens/display_info.dart';
import 'package:expat_info/screens/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey _scaffoldkey = GlobalKey<ScaffoldState>();
  final RoundedLoadingButtonController googleController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController facebookController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.cyanColor,
      body: Column(children: [
        Stack(
          children: [
            CustomPaint(
              painter: MyPainter(),
              child: Container(
                height: 400.0,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 150),
              child: Center(
                child: BounceInDown(
                  delay: const Duration(milliseconds: 50),
                  child: const CircleAvatar(
                    radius: 70.0,
                    backgroundColor: Colors.teal,
                    backgroundImage: AssetImage("lib/assets/expatswap1.jpeg"),
                  ),
                ),
              ),
            ),
          ],
        ),
        BounceInDown(
            delay: const Duration(milliseconds: 50),
            child: const Center(
                child: Text("Welcome To ExpatInfo",
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.w600)))),
        const SizedBox(
          height: 100,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BounceInLeft(
              delay: const Duration(milliseconds: 50),
              child: RoundedLoadingButton(
                width: MediaQuery.of(context).size.width * 0.6,
                borderRadius: 25,
                elevation: 4,
                controller: googleController,
                successColor: Colors.green,
                errorColor: AppColors.redColor,
                onPressed: () {
                  handleGoogleSignIn();
                  // Get.to(InfoInputPage());
                },
                color: AppColors.mainBGColor,
                child: const Wrap(
                  children: [
                    Icon(
                      FontAwesomeIcons.google,
                      size: 25,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Continue with Google",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Row(
              children: [
                Expanded(
                  child: Divider(
                    indent: 20,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Or',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
                Expanded(
                  child: Divider(
                    endIndent: 20,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            BounceInRight(
                delay: const Duration(milliseconds: 50),
                child: RoundedLoadingButton(
                  width: MediaQuery.of(context).size.width * 0.6,
                  borderRadius: 25,
                  elevation: 4,
                  controller: facebookController,
                  successColor: Colors.blue,
                  errorColor: AppColors.redColor,
                  onPressed: () {
                    handleFacebookSignIn();
                  },
                  color: Colors.blue,
                  child: const Wrap(
                    children: [
                      Icon(
                        FontAwesomeIcons.facebook,
                        size: 30,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Continue with Facebook",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                )),
          ],
        ),
      ]),
    );
  }

  Future handleGoogleSignIn() async {
    final sp = context.read<SignInProvider>();
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();

    if (ip.hasInternet == false) {
      Get.snackbar(
        'Error',
        'Check your Internet Connection',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(.8),
        colorText: Colors.white,
      );
      googleController.reset();
    } else {
      try {
        await sp.signInWithGoogle();

        if (sp.hasError == true) {
          Get.snackbar(
            'Error',
            'Log in Terminated',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red.withOpacity(.8),
            colorText: Colors.white,
          );
          googleController.reset();
        } else {
          // User sign-in was successful
          // Check if the user exists
          sp.checkUserExist().then((value) async {
            if (value == true) {
              await sp.getUserDataFromFirestore(sp.uid).then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignIn().then((value) {
                        googleController.success();
                        handleAfterSignIn();
                      })));
            } else {
              // User does not exist
              sp.saveDataToFirestore().then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignIn().then((value) {
                        googleController.success();
                        handleAfterSignIn();
                      })));
            }
          });
        }
      } on PlatformException catch (e) {
        print("PlatformException: $e");
        if (e.code == 'sign_in_canceled') {
          Get.snackbar(
            'Error',
            'Sign-in canceled by user',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red.withOpacity(.8),
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            'Error',
            'Unexpected error: ${e.message}',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red.withOpacity(.8),
            colorText: Colors.white,
          );
        }
        googleController.reset();
      }
    }
  }

  // handling Facebook auth
  Future handleFacebookSignIn() async {
    final sp = context.read<SignInProvider>();
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();

    if (ip.hasInternet == false) {
      Get.snackbar(
        'Error',
        'Check your Internet Connection',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(.8),
        colorText: Colors.white,
      );
      facebookController.reset();
    } else {
      try {
        await sp.signInwithFacebook();
        if (sp.hasError == true) {
          Get.snackbar(
            'Error',
            'Log in Terminated',
            // sp.errorCode.toString(),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red.withOpacity(.8),
            colorText: Colors.white,
          );
          facebookController.reset();
        } else {
          // check if user exist
          sp.checkUserExist().then((value) async {
            if (value == true) {
              await sp.getUserDataFromFirestore(sp.uid).then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignIn().then((value) {
                        facebookController.success();
                        handleAfterSignIn();
                      })));
            } else {
              sp.saveDataToFirestore().then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignIn().then((value) {
                        facebookController.success();
                        handleAfterSignIn();
                      })));
            }
          });
        }
      } on PlatformException catch (e) {
        print("PlatformException: $e");
        if (e.code == 'sign_in_canceled') {
          Get.snackbar(
            'Error',
            'Sign-in canceled by user',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red.withOpacity(.8),
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            'Error',
            'Unexpected error: ${e.message}',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red.withOpacity(.8),
            colorText: Colors.white,
          );
        }
        facebookController.reset();
      }
    }
  }
}

void handleAfterSignIn() {
  Future.delayed(const Duration(milliseconds: 1000)).then((value) {
    nextScreenReplace(() => const DisplayInfo());
    LoginSnackBar('Login successful');
  });
}
