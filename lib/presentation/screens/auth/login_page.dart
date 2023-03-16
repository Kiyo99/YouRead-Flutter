import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:k_books/constants.dart';
import 'package:k_books/presentation/screens/books/book_feed.dart';
import 'package:k_books/widgets/app_modal.dart';
import 'package:k_books/widgets/app_text_field.dart';
import 'package:k_books/widgets/primary_app_button.dart';

class LoginPage extends HookWidget {
  LoginPage({Key? key}) : super(key: key);

  static const id = 'login';

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final auth = FirebaseAuth.instance;
  final store = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
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
                            style: GoogleFonts.exo2(fontSize: 25),
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
                          style: GoogleFonts.exo2(color: Constants.coolOrange),
                        ),
                      ),
                      PrimaryAppButton(
                        title: "Login",
                        onPressed: () async {
                          //todo All of these should be done in the viewmodel.
                          //todo cache the user using shared preferences so that the user doesnt have to log in multiple times

                          if (emailController.text.isEmpty ||
                              passwordController.text.isEmpty) {
                            print("Please enter all fields");
                            Constants.showToast(
                                context, 'Please enter all fields');
                            // const AlertDialog(
                            //   title: Text("Please enter all fields"),
                            // );
                            return;
                          }

                          isLoading.value = true;

                          try {
                            await auth.signInWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text);

                            //todo: Add something here like setting user destination

                            // final studentsDoc = await store
                            //     .collection("Users")
                            //     .doc(emailController.text)
                            //     .get();

                            // final user = AppUser.fromJson(studentsDoc.data()!);

                            // ref
                            //     .read(AuthLocalDataSource.provider)
                            //     .cacheUser(user);

                            isLoading.value = false;
                            Get.toNamed(BookFeed.id);
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
                          }
                        },
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'Don\'t have account?',
                            style: GoogleFonts.exo2(),
                          ),
                          TextButton(
                            child: Text(
                              'Sign up',
                              style: GoogleFonts.exo2(
                                  color: Constants.coolOrange, fontSize: 20),
                            ),
                            onPressed: () {
                              // Get.to(RegisterPage());
                              //signup screen
                            },
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                    ],
                  ),
                ),
              )
            : const Center(child: CircularProgressIndicator()));
  }
}
