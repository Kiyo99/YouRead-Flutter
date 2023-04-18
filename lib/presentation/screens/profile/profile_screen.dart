import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:k_books/core/app_text_style.dart';
import 'package:k_books/core/constants.dart';
import 'package:k_books/data/datasource/auth_local_datasource.dart';
import 'package:k_books/presentation/screens/auth/login_page.dart';
import 'package:k_books/widgets/app_drawer.dart';
import 'package:k_books/widgets/app_modal.dart';
import 'package:k_books/widgets/primary_app_button.dart';

class ProfileScreen extends HookWidget {
  static String id = "profile_screen";

  const ProfileScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final user = context.read(AuthLocalDataSource.provider).getCachedUser();
    print("App user: ${user}");

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Profile",
          style: AppTextStyles.boldedStyle,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Constants.coolBlue,
        shadowColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.black,
                      child: user?.profilePicture == null
                          ? Image.asset(
                              user?.gender == "male"
                                  ? "assets/images/placeholder-male.jpg"
                                  : "assests/images/placeholder-female.jpg",
                            )
                          : Image.network(user?.profilePicture),
                    ),
                    const SizedBox(height: 20),
                    PrimaryAppButton(
                      title: "Edit Profile",
                      onPressed: () {},
                      bgColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  Text(
                    "Account",
                    style: AppTextStyles.titleTextStyle,
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Name",
                    style: AppTextStyles.normalSmallTextStyle,
                  ),
                  Text(
                    user?.fullName,
                    style: AppTextStyles.normalSmallTextStyle,
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Email",
                    style: AppTextStyles.normalSmallTextStyle,
                  ),
                  Text(
                    user?.email,
                    style: AppTextStyles.normalSmallTextStyle,
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Phone Number",
                    style: AppTextStyles.normalSmallTextStyle,
                  ),
                  Text(
                    user?.phoneNumber,
                    style: AppTextStyles.normalSmallTextStyle,
                  )
                ],
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  Text(
                    "More",
                    style: AppTextStyles.titleTextStyle,
                  )
                ],
              ),
              const SizedBox(height: 20),
              NavTile(
                icon: Icons.info_outline,
                title: "Help and Support",
                onPressed: () {},
                padding: EdgeInsets.zero,
                color: Colors.black,
                trailing: const Icon(Icons.arrow_forward_ios_outlined),
              ),
              const SizedBox(height: 10),
              NavTile(
                icon: Icons.star_outline,
                title: "Make a Suggestion",
                onPressed: () {},
                padding: EdgeInsets.zero,
                color: Colors.black,
                trailing: const Icon(Icons.arrow_forward_ios_outlined),
              ),
              const SizedBox(height: 10),
              NavTile(
                icon: Icons.share_outlined,
                title: "Share and invite",
                onPressed: () {},
                padding: EdgeInsets.zero,
                color: Colors.black,
                trailing: const Icon(Icons.arrow_forward_ios_outlined),
              ),
              const SizedBox(height: 10),
              NavTile(
                icon: Icons.logout_outlined,
                title: "Log out",
                onPressed: () async {
                  AppModal.showModal(
                      context: context,
                      title: "Log out?",
                      message: "Are you sure you want to log out?",
                      asset: "assets/lottie/warning.json",
                      primaryAction: () async {
                        final auth = FirebaseAuth.instance;
                        //
                        await auth.signOut();

                        context
                            .read(AuthLocalDataSource.provider)
                            .clearUserData();

                        // print(auth.currentUser);
                        Get.offAndToNamed(LoginPage.id);
                      },
                      buttonText: "Yes, log out",
                      showSecondary: true);
                },
                padding: EdgeInsets.zero,
                color: Colors.green,
              ),
              const SizedBox(height: 10),
              NavTile(
                icon: Icons.delete_outline,
                title: "Delete account",
                onPressed: () {},
                padding: EdgeInsets.zero,
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
