import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:k_books/core/constants.dart';
import 'package:pdf_render/pdf_render_widgets.dart';

class BookViewer extends HookWidget {
  static String id = "pdf_viewer";

  final _fireStore = FirebaseFirestore.instance;

  BookViewer({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final data = useState<Map<String, dynamic>>(Get.arguments);
    final zoomed = useState(false);
    PdfViewerController controller = PdfViewerController();
    TapDownDetails? doubleTapDetails;

    final bookmarked = useState(false);

    return WillPopScope(
      onWillPop: () {
        //todo: Save last page to shared Preferences
        Map<String, Object> db = {};
        db['lastPage'] = controller.currentPageNumber;
        _fireStore
            .collection("books")
            .doc(data.value['title'])
            .update(db)
            .onError((error, stackTrace) => print("ERRRRRR: $error"));

        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Constants.coolBlue,
        appBar: AppBar(
          title: Text(data.value['title']),
          centerTitle: true,
          elevation: 0,
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          actions: [
            IconButton(
                onPressed: () {
                  bookmarked.value = !bookmarked.value;
                  //todo: More logic on this
                },
                icon: Icon(bookmarked.value
                    ? FlutterRemix.bookmark_fill
                    : FlutterRemix.bookmark_line))
          ],
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
          child: FutureBuilder<File>(
            future: DefaultCacheManager().getSingleFile(data.value['storage']),
            builder: (context, snapshot) => snapshot.hasData
                ? GestureDetector(
                    onDoubleTapDown: (details) => doubleTapDetails = details,
                    onDoubleTap: () {
                      if (zoomed.value == false) {
                        controller.ready?.setZoomRatio(
                          zoomRatio: controller.zoomRatio * 1.5,
                          center: doubleTapDetails!.localPosition,
                        );
                        zoomed.value = true;
                      } else {
                        controller.ready?.setZoomRatio(
                          zoomRatio: controller.zoomRatio / 1.5,
                          center: doubleTapDetails!.localPosition,
                        );
                        zoomed.value = false;
                      }
                    },
                    child: Container(
                      padding:
                          const EdgeInsets.only(top: 10, left: 8, right: 8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: PdfViewer.openFile(
                        snapshot.data!.path,
                        params: PdfViewerParams(
                          padding: 0,
                          pageNumber: data.value['lastPage'] ?? 1,
                          pageDecoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                        ),
                        viewerController: controller,
                      ),
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
                backgroundColor: Constants.coolBlue,
                child: Icon(
                  Icons.first_page_outlined,
                  color: Constants.coolWhite,
                ),
                onPressed: () => controller.ready?.goToPage(pageNumber: 1)),
            const SizedBox(height: 5),
            FloatingActionButton(
              backgroundColor: Constants.coolBlue,
              child: Icon(
                Icons.last_page_outlined,
                color: Constants.coolWhite,
              ),
              onPressed: () =>
                  controller.ready?.goToPage(pageNumber: controller.pageCount),
            ),
            const SizedBox(height: 5),
            FloatingActionButton(
              backgroundColor: Constants.coolBlue,
              child: Icon(
                Icons.find_in_page_outlined,
                color: Constants.coolWhite,
              ),
              onPressed: () {
                showToast(context, "Enter a page number", controller);
                // controller.ready?.goToPage(pageNumber: controller.pageCount);
              },
            ),
          ],
        ),
      ),
    );
  }

  static void showToast(
      BuildContext context, String message, PdfViewerController controller) {
    final scaffold = ScaffoldMessenger.of(context);
    TextEditingController con = TextEditingController();

    scaffold.showSnackBar(
      SnackBar(
        content: TextField(
          controller: con,
          style: TextStyle(color: Constants.coolWhite),
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.circular(
                15.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  15.0,
                ),
                borderSide: const BorderSide(
                  color: Colors.blue,
                )),
            border: const OutlineInputBorder(),
            labelText: message,
            labelStyle: const TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Constants.coolBlue,
        duration: const Duration(minutes: 5),
        action: SnackBarAction(
            label: 'Enter',
            onPressed: () {
              debugPrint("Current page:  ${controller.currentPageNumber}");
              controller.ready?.goToPage(pageNumber: int.parse(con.text));
              scaffold.hideCurrentSnackBar;
            }),
      ),
    );
  }
}
