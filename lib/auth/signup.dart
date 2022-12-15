import 'package:blue_diamond/auth/signin.dart';
import 'package:blue_diamond/exception.dart';
import 'package:blue_diamond/mainer/initializer.dart';
import 'package:blue_diamond/methods_and_variables/methods.dart';
import 'package:blue_diamond/methods_and_variables/variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");
  TextEditingController firstNameController = TextEditingController(text: "");
  TextEditingController lastNameController = TextEditingController(text: "");
  TextEditingController phoneController = TextEditingController(text: "");
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool loading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    phoneController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
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
                borderRadius: BorderRadius.circular(10),
                color: white.withOpacity(.2),
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          textWriter(
                              "START FOR FREE", 25, white.withOpacity(.8)),
                          const SizedBox(height: 5),
                          Wrap(
                            alignment: WrapAlignment.center,
                            children: "Create new account"
                                .split(" ")
                                .map((text) => textWriter("$text ", 60, white))
                                .toList(),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              textFieldWidget(
                                firstNameController,
                                "First name",
                                filterPattern:
                                    RegExp(r"^[a-zA-Z][a-zA-Z0-9_]*$"),
                                validator: (String? value) {
                                  return inputValidator(
                                      "first name",
                                      value,
                                      r"^[a-zA-Z][a-zA-Z0-9_]*$",
                                      "first name must start with alphabet");
                                },
                                containerWidth: 190,
                                prefixIcon: FontAwesomeIcons.firstOrder,
                              ),
                              const SizedBox(width: 20),
                              textFieldWidget(
                                lastNameController,
                                "Last name",
                                filterPattern:
                                    RegExp(r"^[a-zA-Z][a-zA-Z0-9_]*$"),
                                validator: (String? value) {
                                  return inputValidator(
                                      "last name",
                                      value,
                                      r"^[a-zA-Z][a-zA-Z0-9_]*$",
                                      "Eg : blue_diamond");
                                },
                                containerWidth: 190,
                                prefixIcon: FontAwesomeIcons.jediOrder,
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  width: 60,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: white.withOpacity(.4),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: textWriter("+216", 18, tulip),
                                  )),
                              const SizedBox(
                                width: 10,
                              ),
                              textFieldWidget(
                                phoneController,
                                "Phone",
                                onChange: (String value) {
                                  if (phoneController.text.length == 2 ||
                                      phoneController.text.length == 6) {
                                    phoneController.text = "$value ";
                                  }
                                  phoneController.selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset: phoneController.text.length));
                                },
                                containerWidth: 330,
                                filterPattern: RegExp(r"[\d ]+"),
                                maxLength: 10,
                                validator: (String? value) {
                                  return inputValidator(
                                      "phone",
                                      value,
                                      r"^\d\d \d\d\d \d\d\d$",
                                      "follow the pattern : xx xxx xxx");
                                },
                                prefixIcon: FontAwesomeIcons.phone,
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          textFieldWidget(
                            emailController,
                            "E-mail",
                            filterPattern: RegExp(r"[_a-zA-Z0-9\@\.-]+"),
                            validator: (String? value) {
                              return inputValidator(
                                  "email",
                                  value,
                                  r"[_a-zA-Z]\w+\@[a-zA-Z]+\.[a-z]{2,3}",
                                  "abc@xyz.t");
                            },
                            prefixIcon: FontAwesomeIcons.solidEnvelope,
                          ),
                          const SizedBox(height: 30),
                          textFieldWidget(
                            passwordController,
                            "Password",
                            filterPattern: RegExp(r"[_a-zA-Z0-9]+"),
                            validator: (String? value) {
                              return inputValidator(
                                  "password",
                                  value,
                                  r"(?=.*[a-z].*)(?=.*[A-Z].*)(?=.*[0-9].*)(?=.*_.*)[a-zA-Z0-9_]+",
                                  "password contains alphanumerics & _(s)");
                            },
                            prefixIcon: FontAwesomeIcons.lock,
                            suffixIconAfter: Icons.visibility,
                            suffixIconBefore: Icons.visibility_off,
                          ),
                          const SizedBox(height: 30),
                          StatefulBuilder(
                            builder: (context, set) {
                              return loading
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: tulip,
                                      ),
                                    )
                                  : routeButton(
                                      "Create",
                                      () async {
                                        try {
                                          if (formKey.currentState!
                                              .validate()) {
                                            set(() {
                                              loading = true;
                                            });
                                            toast(
                                                "Please Wait For Account Creation");
                                            await FirebaseAuth.instance
                                                .createUserWithEmailAndPassword(
                                              email: emailController.text
                                                  .toLowerCase()
                                                  .trim(),
                                              password: passwordController.text
                                                  .trim(),
                                            );
                                            await FirebaseFirestore.instance
                                                .collection("users")
                                                .doc(FirebaseAuth
                                                    .instance.currentUser!.uid)
                                                .set(
                                              {
                                                "firstname": firstNameController
                                                    .text
                                                    .trim(),
                                                "lastname": lastNameController
                                                    .text
                                                    .trim(),
                                                "phone":
                                                    "+216 ${phoneController.text.trim()}",
                                                "email": emailController.text
                                                    .toLowerCase()
                                                    .trim(),
                                                "password": passwordController
                                                    .text
                                                    .trim(),
                                                "product_in_cart": 0,
                                                "products": {},
                                                "image_url": "",
                                              },
                                            );
                                            // ignore: use_build_context_synchronously
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const Init(),
                                              ),
                                            );
                                          }
                                        } catch (e) {
                                          toast(
                                              "Error Occured During Account Creation");
                                          set(() {
                                            loading = false;
                                          });
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              content: FlutterException(
                                                exception: e.toString(),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    );
                            },
                          ),
                        ],
                      ),
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
