import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:k_books/core/app_text_style.dart';
import 'package:k_books/core/constants.dart';
import 'package:k_books/data/app_user/app_user.dart';
import 'package:k_books/data/datasource/auth_local_datasource.dart';
import 'package:k_books/presentation/screens/auth/login_page.dart';
import 'package:k_books/widgets/app_drawer.dart';
import 'package:k_books/widgets/app_modal.dart';
import 'package:k_books/widgets/primary_app_button.dart';

class ProfileScreen extends HookWidget {
  static String id = "profile_screen";

  ProfileScreen({Key? key}) : super(key: key);

  final _fireStore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final user = context.read(AuthLocalDataSource.provider).getCachedUser();
    final appUser = useState<AppUser?>(user);

    final isImageLoading = useState(false);

    Future saveImage(File file, String name) async {
      final storageRef =
          FirebaseStorage.instance.ref().child("profilePics/$name");

      try {
        await storageRef.putFile(file);
        final url = await storageRef.getDownloadURL();
        return url;
      } catch (e) {
        debugPrint("Error caught: $e");
        return "";
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
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
                    GestureDetector(
                      onTap: () async {
                        FilePickerResult? result = await FilePicker.platform
                            .pickFiles(type: FileType.image);

                        if (result != null) {
                          File file = File(result.files.single.path!);

                          String fileNameToDisplay = file.path.split('/').last;

                          isImageLoading.value = true;

                          final imageDownloadLink =
                              await saveImage(file, fileNameToDisplay);
                          //isImageLoading.value = false;

                          Map<String, Object> db = {};
                          db['profilePicture'] = imageDownloadLink;

                          _fireStore
                              .collection("Users")
                              .doc(auth.currentUser!.email.toString())
                              .update(db)
                              .whenComplete(() async {
                            Constants.showToast(
                                context, 'Changed profile image');

                            final studentsDoc = await _fireStore
                                .collection("Users")
                                .doc(auth.currentUser?.email)
                                .get();

                            final user = AppUser.fromJson(studentsDoc.data()!);

                            context
                                .read(AuthLocalDataSource.provider)
                                .cacheUser(user);

                            appUser.value = user;

                            isImageLoading.value = false;
                          }).catchError((error, stackTrace) => () {
                                    Constants.showToast(
                                        context, 'Failed to save 😪');
                                    debugPrint('Failed: $error');
                                  });
                        } else {
                          // User canceled the picker
                          debugPrint("I got cancelled");
                        }
                      },
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100)),
                        child: isImageLoading.value == true
                            ? CircularProgressIndicator(
                                color: Constants.coolBlue,
                              )
                            : appUser.value?.profilePicture == null
                                ? CircleAvatar(
                                    radius: 70,
                                    backgroundImage: AssetImage(
                                      appUser.value?.gender == "Male"
                                          ? "assets/images/placeholder-male.jpg"
                                          : "assets/images/placeholder-female.jpg",
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 70,
                                    backgroundColor: Colors.white,
                                    backgroundImage: NetworkImage(
                                      appUser.value?.profilePicture,
                                    ),
                                  ),
                      ),
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
                  Text(
                    "Name",
                    style: AppTextStyles.normalSmallTextStyle,
                  ),
                  Text(
                    appUser.value?.fullName,
                    style: AppTextStyles.normalSmallTextStyle,
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Email",
                    style: AppTextStyles.normalSmallTextStyle,
                  ),
                  Text(
                    appUser.value?.email,
                    style: AppTextStyles.normalSmallTextStyle,
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Phone Number",
                    style: AppTextStyles.normalSmallTextStyle,
                  ),
                  Text(
                    appUser.value?.phoneNumber,
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
