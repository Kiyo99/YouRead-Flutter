import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:k_books/widgets/app_modal.dart';
import 'package:k_books/widgets/app_text_field.dart';
import 'package:k_books/widgets/drawer.dart';
import 'package:k_books/widgets/primary_app_button.dart';

class UploadScreen extends HookWidget {
  static String id = "upload_screen";

  final _fireStore = FirebaseFirestore.instance;

  final TextEditingController title = TextEditingController();
  final TextEditingController storage = TextEditingController();
  final TextEditingController url = TextEditingController();
  final TextEditingController category = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        shadowColor: Colors.transparent,
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(FlutterRemix.menu_2_line),
            );
          },
        ),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(FlutterRemix.more_2_fill))
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              AppTextField(controller: title, title: "Title"),
              AppTextField(controller: storage, title: "Storage"),
              AppTextField(controller: url, title: "url"),
              AppTextField(controller: category, title: "Category"),
              const SizedBox(height: 30),
              PrimaryAppButton(
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();

                  if (result != null) {
                    File file = File(result.files.single.path!);
                  } else {
                    // User canceled the picker
                    print("I got cancelled");
                  }
                },
                title: "Upload Book",
                // onPressed: () async {
                //   if (title.text.isEmpty ||
                //       storage.text.isEmpty ||
                //       url.text.isEmpty ||
                //       category.text.isEmpty) {
                //     AppModal.showToast(context, 'Please enter all fields');
                //     return;
                //   }
                //
                //   AppModal.showModal(
                //       context: context,
                //       title: "Upload?",
                //       message: "Are you sure you want to upload ${title.text}?",
                //       asset: "assets/lottie/warning.json",
                //       primaryAction: () async {
                //         Get.back();
                //         // AppDialogs.lottieLoader();
                //
                //         Map<String, Object> db = {};
                //         db['courseName'] = title.text;
                //         db['courseCode'] = storage.text;
                //         db['dueDate'] = url.text;
                //         db['teacher'] = category.text;
                //
                //         _fireStore
                //             .collection("Courses")
                //             .doc(db['courseCode'].toString())
                //             .set(db)
                //             .whenComplete(() {
                //           Get.back();
                //
                //           AppModal.showModal(
                //             context: context,
                //             title: 'Success',
                //             message:
                //                 'You have successfully uploaded ${title.text}.',
                //             asset: 'assets/lottie/success.json',
                //             primaryAction: () {
                //               Get.back();
                //             },
                //             buttonText: 'Okay',
                //           );
                //
                //           title.clear();
                //           category.clear();
                //           url.clear();
                //           storage.clear();
                //         }).onError((error, stackTrace) => () {
                //                   Get.back();
                //                   AppModal.showModal(
                //                     context: context,
                //                     title: 'Error',
                //                     message: 'Failed to upload ${title.text}.',
                //                     asset: 'assets/lottie/error.json',
                //                     primaryAction: () {
                //                       Get.back();
                //                     },
                //                     buttonText: 'Okay',
                //                   );
                //                 });
                //       },
                //       buttonText: "Yes, upload",
                //       showSecondary: true);
                // },
                padding: const EdgeInsets.symmetric(horizontal: 10),
              )
            ],
          ),
        ),
      ),
    );
  }
}
