import 'package:expat_info/provider/sign_in_provider.dart';
import 'package:expat_info/screens/Update_info.dart';
import 'package:expat_info/screens/login_page.dart';
import 'package:expat_info/screens/utils.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class DisplayInfo extends StatefulWidget {
  const DisplayInfo({Key? key}) : super(key: key);

  @override
  State<DisplayInfo> createState() => _DisplayInfoState();
}

class _DisplayInfoState extends State<DisplayInfo> {
  final RoundedLoadingButtonController buttonController =
      RoundedLoadingButtonController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future getData() async {
    final sp = context.read<SignInProvider>();
    await sp.getDataFromSharedPreferences();
  }

  // Function to show logout and delete user confirmation dialog
  Future<void> deleteUserConfirmationDialog(
      BuildContext context, SignInProvider sp) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete User"),
          content: const Text("Are you sure you want to delete your account?"),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Get.back(); // Close the dialog
                // delete user action
                await sp.deleteUser();
                Get.off(() => const LoginScreen());
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sp = context.watch<SignInProvider>();
    Future<void> logoutConfirmationDialog(BuildContext context) async {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Log Out"),
            content: const Text("Are you sure you want to log out?"),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back; // Close the dialog
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  Get.back(); // Close the dialog
                  //logout action
                  await sp.signOut();
                  Get.off(() => const LoginScreen());
                },
                child: const Text("Log Out"),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Information',
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: AppColors.cyanColor),
        ),
        centerTitle: true,
        backgroundColor: AppColors.mainBGColor,
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            color: AppColors.cyanColor,
            onSelected: (value) {
              if (value == 'logout') {
                logoutConfirmationDialog(context);
              } else if (value == 'deleteUser') {
                deleteUserConfirmationDialog(context, sp);
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('Log Out'),
              ),
              const PopupMenuItem<String>(
                value: 'deleteUser',
                child: Text('Delete User'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 180,
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: const BoxDecoration(
              color: AppColors.mainBGColor,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      sp.imageUrl ??
                          'https://cdn.pixabay.com/photo/2019/08/06/22/48/artificial-intelligence-4389372_1280.jpg',
                      // onError: (error, stackTrace) => Image.asset('assets/images/default_profile_pic.png'),
                    ),
                  ),
                  Text(
                    "${sp.name}",
                    style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: AppColors.cyanColor),
                  ),
                  Text(
                    "${sp.email}",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.cyanColor),
                  )
                ],
              ),
            ),
          ),
          const Text(
            "Personal Information :",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          Expanded(
            child: ListView(padding: const EdgeInsets.all(16.0), children: [
              // TextBio(header: "Name", bio: "${sp.name}"),
              // TextBio(header: "Email", bio: "${sp.email}"),
              TextBio(header: "Phone Number", bio: "${sp.phoneNumber}"),
              TextBio(header: "Date of Birth", bio: "${sp.dob}"),
              TextBio(header: "Age", bio: "${sp.age}"),
              TextBio(header: "Address", bio: "${sp.address}"),
              TextBio(header: "Religion", bio: "${sp.religion}"),
              TextBio(header: "Gender", bio: "${sp.gender}"),
              TextBio(header: "Language", bio: "${sp.language}"),
              TextBio(header: "About Me", bio: "${sp.personalStatement}"),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainBGColor,
                  // onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                label: const Text(
                  'Edit Profile',
                  style: TextStyle(color: AppColors.cyanColor),
                ),
                icon: const Icon(
                  Icons.edit_document,
                  size: 30,
                  color: AppColors.cyanColor,
                ),
                onPressed: () {
                  Get.to(() => const InfoInputPage());
                },
              ),
            ]),
          )
        ],
      ),
    );
  }
}
