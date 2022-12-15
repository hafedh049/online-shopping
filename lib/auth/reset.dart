import 'package:blue_diamond/auth/signin.dart';
import 'package:blue_diamond/methods_and_variables/methods.dart';
import 'package:blue_diamond/methods_and_variables/variables.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

class Reset extends StatefulWidget {
  const Reset({super.key});

  @override
  State<Reset> createState() => _ResetState();
}

class _ResetState extends State<Reset> {
  TextEditingController emailController = TextEditingController(text: "");
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        textWriter("Forgot your password ?", 30, white),
                        const SizedBox(height: 30),
                        textWriter(
                            "Please check your inbox, click in the received link to reset a password.",
                            16,
                            white.withOpacity(.8)),
                        Padding(
                          padding: const EdgeInsets.all(64.0),
                          child: Center(
                            child: LottieBuilder.asset(
                              "assets/reset.json",
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
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignIn(),
                              ),
                            );
                          },
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                textSpanWriter(
                                    "Already A Member ? ", 18, white),
                                textSpanWriter("Sign-In", 18, tulip),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        routeButton(
                          "SEND",
                          () {
                            toast("Recovery link is sent to your gmail");
                            emailController.clear();
                          },
                        ),
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
