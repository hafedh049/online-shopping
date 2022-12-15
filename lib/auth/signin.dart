import 'package:blue_diamond/auth/reset.dart';
import 'package:blue_diamond/auth/signup.dart';
import 'package:blue_diamond/exception.dart';
import 'package:blue_diamond/mainer/initializer.dart';
import 'package:blue_diamond/methods_and_variables/methods.dart';
import 'package:blue_diamond/methods_and_variables/variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

//autoamtic eye display is only in MS EDGE
class _SignInState extends State<SignIn> {
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    "assets/bg.jpg",
                  ),
                  fit: BoxFit.cover),
            ),
          ),
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height * .8,
              width: MediaQuery.of(context).size.width * .6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: white.withOpacity(.2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            textWriter("Sign-In", 60, white),
                            textWriter(".", 80, tulip),
                          ],
                        ),
                        const SizedBox(height: 30),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUp(),
                              ),
                            );
                          },
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                textSpanWriter(
                                    "You Are Not A Member ? ", 18, white),
                                textSpanWriter("Sign-Up", 18, tulip),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        textFieldWidget(
                          emailController,
                          "E-mail",
                          prefixIcon: FontAwesomeIcons.solidEnvelope,
                        ),
                        const SizedBox(height: 30),
                        textFieldWidget(
                          passwordController,
                          "Password",
                          prefixIcon: FontAwesomeIcons.lock,
                          suffixIconAfter: Icons.visibility,
                          suffixIconBefore: Icons.visibility_off,
                        ),
                        const SizedBox(height: 30),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Reset(),
                              ),
                            );
                          },
                          child: textWriter("Recover password", 20, tulip),
                        ),
                        const SizedBox(height: 30),
                        routeButton(
                          "Sign-In",
                          () async {
                            try {
                              if (emailController.text.trim().isNotEmpty &&
                                  passwordController.text.trim().isNotEmpty) {
                                await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                  email:
                                      emailController.text.toLowerCase().trim(),
                                  password: passwordController.text.trim(),
                                );
                                toast("Welcome");
                                // ignore: use_build_context_synchronously
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Init(),
                                  ),
                                );
                              } else {
                                toast("E-mail | Password fields are empty");
                              }
                            } catch (e) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: transparent,
                                  content:
                                      FlutterException(exception: e.toString()),
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Container(
                                      height: .5,
                                      color: white.withOpacity(.6))),
                              textWriter(" OR ", 20, white),
                              Expanded(
                                  child: Container(
                                      height: 1, color: white.withOpacity(.6))),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              FontAwesomeIcons.googlePlusG,
                              size: 40,
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
