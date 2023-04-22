import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:k_books/data/datasource/auth_local_datasource.dart';
import 'package:k_books/presentation/screens/auth/components/intro_pager_item.dart';
import 'package:k_books/presentation/screens/auth/login_page.dart';
import 'package:k_books/widgets/primary_app_button.dart';
import 'package:k_books/widgets/secondary_app_button.dart';
import 'package:k_books/widgets/slider_indicator.dart';

class IntroScreen extends HookWidget {
  static const id = "/intro";

  const IntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentSlide = useState(0);
    final pageController = usePageController();

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: PageView(
                controller: pageController,
                onPageChanged: (idx) => currentSlide.value = idx,
                children: IntroPagerModel.slides
                    .map((e) => IntroPagerItem(slide: e))
                    .toList(),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: SliderIndicator(
                    slideCount: IntroPagerModel.slides.length,
                    currentSlide: currentSlide.value,
                  ),
                ),
                PrimaryAppButton(
                  title: currentSlide.value < 3 ? "Next" : "Done",
                  onPressed: () {
                    if (currentSlide.value < 3) {
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.linear,
                      );
                    } else {
                      context
                          .read(AuthLocalDataSource.provider)
                          .setViewedIntro();

                      Get.offAllNamed(LoginPage.id);
                    }
                  },
                ),
                const SizedBox(height: 10),
                AnimatedContainer(
                  curve: Curves.linear,
                  margin: const EdgeInsets.only(bottom: 30),
                  duration: const Duration(milliseconds: 300),
                  child: Visibility(
                    replacement: const SizedBox(
                      height: 30,
                    ),
                    visible: currentSlide.value < 3,
                    child: SecondaryAppButton(
                      title: "Skip",
                      onPressed: () {
                        context
                            .read(AuthLocalDataSource.provider)
                            .setViewedIntro();
                        Get.offAllNamed(LoginPage.id);
                        // user == null
                        //     ? Get.offAllNamed(LoginPage.id)
                        //     : Get.offAllNamed(StaffPage.id);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}