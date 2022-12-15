import 'package:blue_diamond/methods_and_variables/methods.dart';
import 'package:blue_diamond/methods_and_variables/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  TextEditingController usernameController = TextEditingController(text: "");
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController messageController = TextEditingController(text: "");
  @override
  void dispose() {
    usernameController.dispose();
    messageController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 23, 42),
      body: Padding(
        padding: const EdgeInsets.all(64.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textWriter("Get a quote", 35, white),
                  const SizedBox(height: 20),
                  Wrap(
                    children:
                        "Fill up the form and our Team will get back to you within a couple of hours."
                            .split(" ")
                            .map(
                              (String text) => wordColorizer(
                                  text, white.withOpacity(.6), tulip),
                            )
                            .toList(),
                  ),
                  const Spacer(),
                  amazingContainer(platformCallNumber, FontAwesomeIcons.phone),
                  amazingContainer(emailAddress, FontAwesomeIcons.envelope),
                  amazingContainer("Ave Habib Bourguiba, Tunis",
                      FontAwesomeIcons.locationDot),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      roundedIcon(FontAwesomeIcons.facebookF),
                      const SizedBox(width: 20),
                      roundedIcon(FontAwesomeIcons.twitter),
                      const SizedBox(width: 20),
                      roundedIcon(FontAwesomeIcons.instagram),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: tulip.withOpacity(.1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          textFieldWidget(
                            usernameController,
                            "Username",
                            prefixIcon: FontAwesomeIcons.userAstronaut,
                          ),
                          const SizedBox(height: 30),
                          textFieldWidget(
                            emailController,
                            "E-mail",
                            prefixIcon: FontAwesomeIcons.envelope,
                          ),
                          const SizedBox(height: 30),
                          textFieldWidget(
                            messageController,
                            "Message",
                            prefixIcon: FontAwesomeIcons.message,
                            maxLines: 7,
                          ),
                          const SizedBox(height: 30),
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: AnimatedButton(
                              text: "Send Message",
                              textStyle: TextStyle(color: white, fontSize: 14),
                              onPress: () {
                                if (usernameController.text.trim().isEmpty) {
                                  toast("username is mandatory");
                                } else if (!usernameController.text
                                    .trim()
                                    .contains(RegExp(r"[a-zA-Z ]+"))) {
                                  toast(
                                      "username field contains only alphabetics and a single whitespace");
                                } else if (emailController.text
                                    .trim()
                                    .isEmpty) {
                                  toast("email is mandatory");
                                } else if (!emailController.text
                                    .trim()
                                    .contains(RegExp(
                                        r"[a-zA-Z_]+\@[a-z]+\.[a-z]{2,3}"))) {
                                  toast("email format is xxx@yyy.zzz");
                                } else if (messageController.text
                                    .trim()
                                    .isEmpty) {
                                  toast("message cannot be empty");
                                } else {
                                  toast("Form Submitted Successfully");
                                  usernameController.clear();
                                  emailController.clear();
                                  messageController.clear();
                                }
                              },
                              animatedOn: AnimatedOn.onHover,
                              animationDuration:
                                  const Duration(milliseconds: 300),
                              backgroundColor: Colors.blueGrey,
                              borderRadius: 5,
                              selectedBackgroundColor: tulip,
                              selectedTextColor: white,
                              width: 200,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
