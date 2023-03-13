import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:k_books/widgets/app_modal.dart';
import 'package:k_books/widgets/app_text_field.dart';
import 'package:k_books/widgets/drawer.dart';
import 'package:k_books/widgets/muted_app_text_field.dart';
import 'package:k_books/widgets/primary_app_button.dart';

class UploadScreen extends HookWidget {
  static String id = "upload_screen";

  final _fireStore = FirebaseFirestore.instance;

  final TextEditingController title = TextEditingController();
  final TextEditingController imageUrl = TextEditingController();
  final TextEditingController pdfStorageUrl = TextEditingController();
  final TextEditingController category = TextEditingController();

  UploadScreen({Key? key}) : super(key: key);

  Future savePdf(File file, String name) async {
    final storageRef = FirebaseStorage.instance.ref().child("Books/$name}");

    try {
      await storageRef.putFile(file);
      final url = await storageRef.getDownloadURL();
      return url;
    } catch (e) {
      debugPrint("Error caught: $e}");
      return "";
    }

    // final reference = FirebaseStorage.instance.ref().child(name);
    // UploadTask uploadTask = reference.putData(asset);
    // String url = await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
    // print(url);
    // documentFileUpload(url);
  }

  Future saveImage(File file, String name) async {
    final storageRef = FirebaseStorage.instance.ref().child("Images/$name}");

    try {
      await storageRef.putFile(file);
      final url = await storageRef.getDownloadURL();
      return url;
    } catch (e) {
      debugPrint("Error caught: $e}");
      return "";
    }

    // final reference = FirebaseStorage.instance.ref().child(name);
    // UploadTask uploadTask = reference.putData(asset);
    // String url = await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
    // print(url);
    // documentFileUpload(url);
  }

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
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              AppTextField(controller: title, title: "Title"),
              MutedAppTextField(
                controller: imageUrl,
                title: "Image",
                onTap: () async {
                  // var rng = new Random();
                  // String randomName = "";
                  // for (var i = 0; i < 20; i++) {
                  //   print(rng.nextInt(100));
                  //   randomName += rng.nextInt(100).toString();
                  // }

                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(type: FileType.image);

                  if (result != null) {
                    File file = File(result.files.single.path!);
                    print("File chosen: ${file}");

                    // String fileName = '${randomName}.pdf';
                    // print("fileNameeeee: $fileName");

                    String fileNameToDisplay = file.path.split('/').last;
                    imageUrl.text = fileNameToDisplay;

                    final imageLink = await saveImage(file, fileNameToDisplay);

                    imageUrl.text = imageLink;

                    //Going into firebase

                  } else {
                    // User canceled the picker
                    debugPrint("I got cancelled");
                  }
                },
              ),
              MutedAppTextField(
                controller: pdfStorageUrl,
                title: "Pdf url",
                onTap: () async {
                  // var rng = new Random();
                  // String randomName = "";
                  // for (var i = 0; i < 20; i++) {
                  //   print(rng.nextInt(100));
                  //   randomName += rng.nextInt(100).toString();
                  // }

                  FilePickerResult? result = await FilePicker.platform
                      .pickFiles(
                          type: FileType.custom, allowedExtensions: ['pdf']);

                  if (result != null) {
                    File file = File(result.files.single.path!);
                    debugPrint("File chosen: $file");

                    // String fileName = '${randomName}.pdf';
                    // print("fileNameeeee: $fileName");

                    String fileNameToDisplay = file.path.split('/').last;
                    pdfStorageUrl.text = fileNameToDisplay;

                    final pdfUrl = await savePdf(file, fileNameToDisplay);

                    pdfStorageUrl.text = pdfUrl;
                  } else {
                    // User canceled the picker
                    debugPrint("I got cancelled");
                  }
                },
              ),
              AppTextField(controller: category, title: "Category"),
              const SizedBox(height: 30),
              PrimaryAppButton(
                // onPressed: () async {
                //   var rng = new Random();
                //   String randomName = "";
                //   for (var i = 0; i < 20; i++) {
                //     print(rng.nextInt(100));
                //     randomName += rng.nextInt(100).toString();
                //   }
                //
                //   FilePickerResult? result = await FilePicker.platform
                //       .pickFiles(
                //           type: FileType.custom, allowedExtensions: ['pdf']);
                //
                //   if (result != null) {
                //     File file = File(result.files.single.path!);
                //     print("File chosen: ${file}");
                //
                //     String fileName = '${randomName}.pdf';
                //     print("fileNameeeee: $fileName");
                //
                //     String fileNameToDisplay = file.path.split('/').last;
                //     imageUrl.text = fileNameToDisplay;
                //
                //     final pdfUrl = await savePdf(file, fileNameToDisplay);
                //
                //     pdfUrlText.text = pdfUrl;
                //
                //     //Going into firebase
                //
                //   } else {
                //     // User canceled the picker
                //     print("I got cancelled");
                //   }
                // },
                title: "Upload Book",
                onPressed: () async {
                  //Make sure both links are there properly
                  if (title.text.isEmpty ||
                      imageUrl.text.isEmpty ||
                      pdfStorageUrl.text.isEmpty ||
                      category.text.isEmpty) {
                    AppModal.showToast(context, 'Please enter all fields');
                    return;
                  }

                  AppModal.showModal(
                      context: context,
                      title: "Upload?",
                      message: "Are you sure you want to upload ${title.text}?",
                      asset: "assets/lottie/warning.json",
                      primaryAction: () async {
                        Get.back();
                        // AppDialogs.lottieLoader();

                        Map<String, Object> db = {};
                        db['title'] = title.text;
                        db['url'] = imageUrl.text;
                        db['storage'] = pdfStorageUrl.text;
                        db['category'] = category.text;

                        _fireStore
                            .collection("books")
                            .doc(db['title'].toString())
                            .set(db)
                            .whenComplete(() {
                          Get.back();

                          AppModal.showModal(
                            context: context,
                            title: 'Success',
                            message:
                                'You have successfully uploaded ${title.text}.',
                            asset: 'assets/lottie/success.json',
                            primaryAction: () {
                              Get.back();
                            },
                            buttonText: 'Okay',
                          );

                          title.clear();
                          category.clear();
                          pdfStorageUrl.clear();
                          imageUrl.clear();
                        }).onError((error, stackTrace) => () {
                                  Get.back();
                                  AppModal.showModal(
                                    context: context,
                                    title: 'Error',
                                    message: 'Failed to upload ${title.text}.',
                                    asset: 'assets/lottie/error.json',
                                    primaryAction: () {
                                      Get.back();
                                    },
                                    buttonText: 'Okay',
                                  );
                                });
                      },
                      buttonText: "Yes, upload",
                      showSecondary: true);
                },
                padding: const EdgeInsets.symmetric(horizontal: 10),
              )
            ],
          ),
        ),
      ),
    );
  }
}
