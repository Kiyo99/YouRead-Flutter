import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:k_books/core/constants.dart';
import 'package:k_books/widgets/app_modal.dart';
import 'package:k_books/widgets/app_text_field.dart';
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
    final storageRef = FirebaseStorage.instance.ref().child("Books/$name");

    try {
      await storageRef.putFile(file);
      final url = await storageRef.getDownloadURL();
      return url;
    } catch (e) {
      debugPrint("Error caught: $e");
      return "";
    }

    // final reference = FirebaseStorage.instance.ref().child(name);
    // UploadTask uploadTask = reference.putData(asset);
    // String url = await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
    // print(url);
    // documentFileUpload(url);
  }

  Future saveImage(File file, String name) async {
    final storageRef = FirebaseStorage.instance.ref().child("Images/$name");

    try {
      await storageRef.putFile(file);
      final url = await storageRef.getDownloadURL();
      return url;
    } catch (e) {
      debugPrint("Error caught: $e");
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
    final isImageLoading = useState(false);
    final isPdfLoading = useState(false);

    final imageLink = useState("");
    final pdfLink = useState("");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload a book"),
        backgroundColor: Constants.coolBlue,
        foregroundColor: Colors.white,
        shadowColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              AppTextField(controller: title, title: "Title"),
              Visibility(
                visible: !isImageLoading.value,
                replacement: Center(
                  child: CircularProgressIndicator(
                    color: Constants.coolBlue,
                  ),
                ),
                child: MutedAppTextField(
                  controller: imageUrl,
                  title: "Image",
                  onTap: () async {
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(type: FileType.image);

                    if (result != null) {
                      File file = File(result.files.single.path!);
                      print("File chosen: $file");

                      String fileNameToDisplay = file.path.split('/').last;
                      imageUrl.text = fileNameToDisplay;

                      isImageLoading.value = true;
                      final imageLink =
                          await saveImage(file, fileNameToDisplay);
                      isImageLoading.value = false;

                      imageUrl.text = fileNameToDisplay;
                      imageLink.value = imageLink;
                    } else {
                      // User canceled the picker
                      debugPrint("I got cancelled");
                    }
                  },
                ),
              ),
              Visibility(
                visible: !isPdfLoading.value,
                replacement: Center(
                  child: CircularProgressIndicator(
                    color: Constants.coolBlue,
                  ),
                ),
                child: MutedAppTextField(
                  controller: pdfStorageUrl,
                  title: "Pdf url",
                  onTap: () async {
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(
                            type: FileType.custom, allowedExtensions: ['pdf']);

                    if (result != null) {
                      File file = File(result.files.single.path!);
                      debugPrint("File chosen: $file");
                      String fileNameToDisplay = file.path.split('/').last;
                      pdfStorageUrl.text = fileNameToDisplay;
                      isPdfLoading.value = true;

                      final pdfUrl = await savePdf(file, fileNameToDisplay);
                      isPdfLoading.value = false;

                      pdfLink.value = pdfUrl;
                      pdfStorageUrl.text = fileNameToDisplay;
                    } else {
                      // User canceled the picker
                      debugPrint("I got cancelled");
                    }
                  },
                ),
              ),
              AppTextField(controller: category, title: "Category"),
              const SizedBox(height: 30),
              PrimaryAppButton(
                title: "Upload Book",
                onPressed: () async {
                  if (title.text.isEmpty ||
                      imageUrl.text.isEmpty ||
                      pdfStorageUrl.text.isEmpty ||
                      imageLink.value.isEmpty ||
                      pdfLink.value.isEmpty ||
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
                        db['url'] = imageLink.value;
                        db['storage'] = pdfLink.value;
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
