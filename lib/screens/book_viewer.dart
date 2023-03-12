import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:pdf_render/pdf_render_widgets.dart';

class BookViewer extends HookWidget {
  static String id = "pdf_viewer";

  const BookViewer({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // final String url = Get.arguments;
    final data = useState<Map<String, dynamic>>(Get.arguments);
    final zoomed = useState(false);
    PdfViewerController controller = PdfViewerController();
    TapDownDetails? doubleTapDetails;

    return Scaffold(
      appBar: AppBar(
        title:Text( data.value['title']),
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
      body: FutureBuilder<File>(
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
                child: PdfViewer.openFile(
                  snapshot.data!.path,
                  params: const PdfViewerParams(pageNumber: 2),
                  viewerController: controller,
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
              child: const Icon(Icons.first_page_outlined),
              onPressed: () => controller.ready?.goToPage(pageNumber: 1)),
          FloatingActionButton(
            child: const Icon(Icons.last_page_outlined),
            onPressed: () =>
                controller.ready?.goToPage(pageNumber: controller.pageCount),
          ),
          FloatingActionButton(
            child: const Icon(Icons.find_in_page_outlined),
            onPressed: () {
              showToast(context, "Enter a page number", controller);
              // controller.ready?.goToPage(pageNumber: controller.pageCount);
            },
          ),
        ],
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
                borderSide: const BorderSide(color: Colors.blue)),
            border: const OutlineInputBorder(),
            labelText: message,
            labelStyle: const TextStyle(color: Colors.white),
          ),
        ),
        duration: const Duration(minutes: 5),
        action: SnackBarAction(
            label: 'Enter',
            onPressed: () {
              controller.ready?.goToPage(pageNumber: int.parse(con.text));
              scaffold.hideCurrentSnackBar;
            }),
      ),
    );
  }
}
