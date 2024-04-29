import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:k_books/core/constants.dart';
import 'package:k_books/data/app_user/app_user.dart';
import 'package:k_books/presentation/screens/auth/register_page.dart';
import 'package:k_books/presentation/screens/main_app.dart';
import 'package:k_books/widgets/app_dialogs.dart';
import 'package:k_books/widgets/app_modal.dart';
import 'package:k_books/widgets/app_text_field.dart';
import 'package:k_books/widgets/primary_app_button.dart';
import 'package:k_books/data/datasource/auth_local_datasource.dart';

class LoginPage extends HookConsumerWidget {
  LoginPage({Key? key}) : super(key: key);

  static const id = 'login';

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final auth = FirebaseAuth.instance;
  final store = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (auth.currentUser != null) {
          Get.offNamed(MainApp.id);
        }
      });
      return;
    }, const []);

    final isLoading = useState(false);
    return Scaffold(
      body: isLoading.value == false
          ? Container(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          'Sign in',
                          style: GoogleFonts.nunito(fontSize: 25),
                        )),
                    AppTextField(
                      controller: emailController,
                      title: "Email",
                    ),
                    AppTextField(
                      controller: passwordController,
                      title: "Password",
                      obscureText: true,
                    ),
                    TextButton(
                      onPressed: () {
                        //forgot password screen
                      },
                      child: Text(
                        'Forgot Password?',
                        style: GoogleFonts.nunito(color: Constants.coolBlue),
                      ),
                    ),
                    PrimaryAppButton(
                      title: "Login",
                      onPressed: () async {
                        //todo All of these should be done in the viewmodel.
                        //todo cache the user using shared preferences so that the user doesnt have to log in multiple times

                        if (emailController.text.isEmpty ||
                            passwordController.text.isEmpty) {
                          Constants.showToast(
                            context,
                            'Please enter all fields',
                          );
                          return;
                        }

                        isLoading.value = true;

                        try {
                          await auth.signInWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text);

                          final studentsDoc = await store
                              .collection("Users")
                              .doc(emailController.text)
                              .get();

                          final user = AppUser.fromJson(studentsDoc.data()!);

                          ref
                              .read(AuthLocalDataSource.provider)
                              .cacheUser(user);

                          isLoading.value = false;
                          Get.offAllNamed(MainApp.id);
                        } on FirebaseAuthException catch (e) {
                          isLoading.value = false;

                          AppModal.showModal(
                            context: context,
                            title: "Login failed 😪",
                            message: e.message!,
                            asset: "assets/lottie/error.json",
                            primaryAction: () => Get.back(),
                            buttonText: "Okay",
                          );

                          print("The error here is: ${e}");
                        }
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Don\'t have account?',
                          style: GoogleFonts.nunito(),
                        ),
                        TextButton(
                          child: Text(
                            'Sign up',
                            style: GoogleFonts.nunito(
                                color: Constants.coolBlue, fontSize: 20),
                          ),
                          onPressed: () {
                            Get.to(RegisterPage());
                          },
                        )
                      ],
                    ),
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
