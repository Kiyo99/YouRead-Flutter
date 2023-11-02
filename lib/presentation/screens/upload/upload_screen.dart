import 'dart:io';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:k_books/presentation/viewmodels/book_viewmodel.dart';
import 'package:path_provider/path_provider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:k_books/core/constants.dart';
import 'package:k_books/widgets/app_dialogs.dart';
import 'package:k_books/widgets/app_modal.dart';
import 'package:k_books/widgets/app_text_field.dart';
import 'package:k_books/widgets/muted_app_text_field.dart';
import 'package:k_books/widgets/primary_app_button.dart';

class UploadScreen extends HookConsumerWidget {
  static String id = "upload_screen";

  final _fireStore = FirebaseFirestore.instance;

  final TextEditingController title = TextEditingController();
  final TextEditingController imageUrl = TextEditingController();
  final TextEditingController pdfStorageUrl = TextEditingController();
  final TextEditingController synopsis = TextEditingController();
  final TextEditingController author = TextEditingController();

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
  }

  Future<File?> resizeImage(
      File originalImageFile, int targetWidth, int targetHeight) async {
    try {
      img.Image? originalImage =
          img.decodeImage(originalImageFile.readAsBytesSync());
      img.Image resizedImage = img.copyResize(originalImage!,
          width: targetWidth, height: targetHeight);

      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      File resizedImageFile = File('$tempPath/resized_image.jpg');
      resizedImageFile
          .writeAsBytesSync(img.encodeJpg(resizedImage, quality: 85));

      return resizedImageFile;
    } catch (e) {
      print("Error resizing: ${e}");
    }
  }

  // Future<File?> resizeImage(
  //     File originalImageFile, int targetWidth, int targetHeight) async {
  //   try {
  //     // Read the original image file
  //     img.Image? originalImage =
  //         img.decodeImage(originalImageFile.readAsBytesSync());
  //
  //     // Resize the image
  //     img.Image resizedImage = img.copyResize(originalImage!,
  //         width: targetWidth, height: targetHeight);
  //
  //     // Encode the resized image to a file
  //     File resizedImageFile = File('path_to_save_resized_image.jpg');
  //     resizedImageFile
  //         .writeAsBytesSync(img.encodeJpg(resizedImage, quality: 85));
  //
  //     return resizedImageFile;
  //   } catch (e) {
  //     print("Error resizing: ${e}");
  //   }
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookViewModel = ref.watch(BookViewModel.provider.notifier);

    final isImageLoading = useState(false);
    final isPdfLoading = useState(false);
    final isLoading = useState(false);

    final imageLink = useState("");
    final pdfLink = useState("");

    final brightness = Theme.of(context).brightness;
    final categoryItems = useState([
      "Category ...",
      "Adult",
      "Christian",
      "Drama",
      "Educational",
      "Fantasy",
      "Horror",
      "Mystery",
      "Poetry",
      "Romance",
    ]);
    final selectedCategoryValue = useState(categoryItems.value[0]);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload a Book"),
        backgroundColor: Constants.coolBlue,
        foregroundColor: Colors.white,
        shadowColor: Colors.transparent,
        elevation: 0,
      ),
      body: isLoading.value == false
          ? Container(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    AppTextField(
                      controller: title,
                      title: "Title",
                      capitilize: TextCapitalization.words,
                    ),
                    AppTextField(
                      controller: author,
                      title: "Author",
                      capitilize: TextCapitalization.words,
                    ),
                    AppTextField(controller: synopsis, title: "Synopsis"),
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

                            String fileNameToDisplay =
                                file.path.split('/').last;
                            imageUrl.text = fileNameToDisplay;

                            isImageLoading.value = true;
                            //Resizing image
                            final resizedImage =
                                await resizeImage(file, 880, 1360);

                            //Getting the download url from Firebase
                            final imageDownloadLink = await saveImage(
                                resizedImage!, fileNameToDisplay);
                            isImageLoading.value = false;

                            imageUrl.text = fileNameToDisplay;
                            imageLink.value = imageDownloadLink;
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
                                  type: FileType.custom,
                                  allowedExtensions: ['pdf']);

                          if (result != null) {
                            File file = File(result.files.single.path!);
                            debugPrint("File chosen: $file");
                            String fileNameToDisplay =
                                file.path.split('/').last;
                            pdfStorageUrl.text = fileNameToDisplay;
                            isPdfLoading.value = true;

                            final pdfUrl =
                                await savePdf(file, fileNameToDisplay);
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
                    Container(
                      height: 55,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: brightness == Brightness.light
                                ? Constants.coolBlue
                                : Constants.coolWhite),
                        borderRadius: BorderRadius.circular(
                          15.0,
                        ),
                      ),
                      child: DropdownButtonFormField(
                        items: categoryItems.value
                            .map<DropdownMenuItem<String>>(
                                (String value) => DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value,
                                          style: GoogleFonts.exo(
                                              color:
                                                  brightness == Brightness.light
                                                      ? Constants.coolBlue
                                                      : Constants.coolWhite)),
                                    ))
                            .toList(),
                        value: selectedCategoryValue.value,
                        focusColor: Colors.white,
                        iconEnabledColor: Constants.coolBlue,
                        style: GoogleFonts.exo2(fontSize: 16),
                        dropdownColor: brightness == Brightness.light
                            ? Constants.coolWhite
                            : Constants.coolBlue,
                        onChanged: (val) {
                          selectedCategoryValue.value = val.toString();
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    PrimaryAppButton(
                      title: "Upload Book",
                      onPressed: () async {
                        if (title.text.isEmpty ||
                            author.text.isEmpty ||
                            synopsis.text.isEmpty ||
                            imageUrl.text.isEmpty ||
                            pdfStorageUrl.text.isEmpty ||
                            imageLink.value.isEmpty ||
                            pdfLink.value.isEmpty ||
                            selectedCategoryValue.value ==
                                categoryItems.value[0]) {
                          AppModal.showToast(
                              context, 'Please enter all fields');
                          return;
                        }

                        AppModal.showModal(
                            context: context,
                            title: "Upload?",
                            message:
                                "Are you sure you want to upload ${title.text}?",
                            asset: "assets/lottie/warning.json",
                            primaryAction: () async {
                              Get.back();
                              // AppDialogs.lottieLoader();

                              Map<String, Object> db = {};
                              db['title'] = title.text;
                              db['url'] = imageLink.value;
                              db['storage'] = pdfLink.value;
                              db['category'] = selectedCategoryValue.value;
                              db['author'] = author.text;
                              db['synopsis'] = synopsis.text;
                              db['rating'] = 0.0;
                              db['reads'] = 0;
                              db['dateCreated'] = DateTime.now().toString();
                              // db['pages'] = 0;
                              // db['date'] = ;

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
                                    bookViewModel.getAllBooks();
                                    bookViewModel.getRecentBooks();
                                  },
                                  buttonText: 'Okay',
                                );

                                title.clear();
                                selectedCategoryValue.value =
                                    categoryItems.value[0];
                                pdfStorageUrl.clear();
                                imageUrl.clear();
                              }).onError((error, stackTrace) => () {
                                        Get.back();
                                        AppModal.showModal(
                                          context: context,
                                          title: 'Error',
                                          message:
                                              'Failed to upload ${title.text}.',
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
            )
          : Center(
              child: Transform.scale(
                child: AppDialogs.loader(),
                scale: 0.75,
              ),
            ),
    );
  }
}

//Date uploaded, reads, rating, intro
