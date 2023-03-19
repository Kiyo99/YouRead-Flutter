import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:k_books/core/app_text_style.dart';
import 'package:k_books/core/constants.dart';
import 'package:k_books/presentation/screens/books/book_viewer.dart';
import 'package:k_books/presentation/viewmodels/book_viewmodel.dart';
import 'package:k_books/widgets/primary_app_button.dart';

class SummaryScreen extends HookWidget {
  static String id = "summary_screen";

  const SummaryScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final bookViewModel = useProvider(BookViewModel.provider);
    final data = useState<Map<String, dynamic>>(Get.arguments);

    return Scaffold(
      appBar: AppBar(
        title: Text(data.value['title']),
        elevation: 0,
        backgroundColor: Constants.coolBlue,
        foregroundColor: Colors.white,
        shadowColor: Colors.transparent,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            data.value['url'],
                            height: 250,
                          )),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Author: ${data.value['author']}",
                        style: AppTextStyles.mutedSmallTextStyle,
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "November 14, 2016",
                        style: AppTextStyles.mutedVerySmallTextStyle,
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "Synopsis",
                        style: AppTextStyles.titleTextStyle,
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView(shrinkWrap: true, children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              data.value['synopsis'],
                              style: AppTextStyles.normalSmallTextStyle,
                            ),
                          )
                        ],
                      ),
                    ]),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                const Icon(FlutterRemix.bookmark_line, size: 30),
                Expanded(
                    child: PrimaryAppButton(
                        title: "Read",
                        onPressed: () =>
                            Get.toNamed(BookViewer.id, arguments: data.value)))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
