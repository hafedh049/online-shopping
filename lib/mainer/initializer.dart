import 'dart:ui';
import 'package:blue_diamond/contact.dart';
import 'package:blue_diamond/methods_and_variables/classes.dart';
import 'package:blue_diamond/methods_and_variables/methods.dart';
import 'package:blue_diamond/methods_and_variables/variables.dart';
import 'package:blue_diamond/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Init extends StatefulWidget {
  const Init({super.key});

  @override
  State<Init> createState() => _InitState();
}

class _InitState extends State<Init> {
  TextEditingController searchController = TextEditingController(text: "");
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                carouselWidget(context),
                Wrap(
                  spacing: 50,
                  runSpacing: 20,
                  children: [
                    genderWidget(
                      "man",
                      Icons.man,
                      () {},
                      [
                        [
                          "Jeans & Trousers",
                          () {
                            travelToProduct(context, "male-pants-");
                          }
                        ],
                        [
                          "Shirts & Jackets",
                          () {
                            travelToProduct(context, "male-shirts-");
                          }
                        ],
                        [
                          "Hats",
                          () {
                            travelToProduct(context, "male-hats-");
                          }
                        ],
                        [
                          "Shoes",
                          () {
                            travelToProduct(context, "male-shoes-");
                          }
                        ],
                        [
                          "Sunglasses",
                          () {
                            travelToProduct(context, "male-sunglasses-");
                          }
                        ],
                      ],
                    ),
                    genderWidget(
                      "female",
                      Icons.woman,
                      () {},
                      [
                        [
                          "Jeans & Trousers",
                          () {
                            travelToProduct(context, "female-pants-");
                          }
                        ],
                        [
                          "Robes",
                          () {
                            travelToProduct(context, "female-dress-");
                          }
                        ],
                        [
                          "Shirts",
                          () {
                            travelToProduct(context, "female-shirts-");
                          }
                        ],
                        [
                          "Sunglasses",
                          () {
                            travelToProduct(context, "female-glasses-");
                          }
                        ],
                        [
                          "Hats",
                          () {
                            travelToProduct(context, "female-hat-");
                          }
                        ],
                        [
                          "Hijabs",
                          () {
                            travelToProduct(context, "female-hijab-");
                          }
                        ],
                        [
                          "Shoes",
                          () {
                            travelToProduct(context, "female-shoes-");
                          }
                        ],
                      ],
                    ),
                    genderWidget(
                      "child",
                      FontAwesomeIcons.child,
                      () {},
                      [
                        [
                          "Robes",
                          () {
                            travelToProduct(context, "child-dress-");
                          }
                        ],
                        [
                          "Trousers",
                          () {
                            travelToProduct(context, "child-pants-");
                          }
                        ],
                        [
                          "Shirts",
                          () {
                            travelToProduct(context, "child-shirts-");
                          }
                        ],
                        [
                          "Shoes",
                          () {
                            travelToProduct(context, "child-shoes-");
                          }
                        ],
                      ],
                    ),
                    genderWidget(
                      "tech",
                      FontAwesomeIcons.child,
                      () {},
                      [
                        [
                          "Accessories",
                          () {
                            travelToProduct(
                                context, "informatique-accessoires-");
                          }
                        ],
                        [
                          "Computers",
                          () {
                            travelToProduct(
                                context, "informatique-ordinateur-");
                          }
                        ],
                        [
                          "Phones",
                          () {
                            travelToProduct(context, "informatique-phone-");
                          }
                        ],
                        [
                          "Storage",
                          () {
                            travelToProduct(context, "informatique-stockage-");
                          }
                        ],
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      rowWidget(platformCallNumber, FontAwesomeIcons.phone),
                      const SizedBox(width: 20),
                      rowWidget(emailAddress, FontAwesomeIcons.envelope),
                      const Spacer(),
                      iconWidget(() async {
                        await launchUrlString(
                            "https://www.facebook.com/sagittarius.aurora.25.12.2020");
                      }, FontAwesomeIcons.facebookF),
                      iconWidget(() async {}, FontAwesomeIcons.instagram),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                color: blackGrey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    runAlignment: WrapAlignment.center,
                    runSpacing: 20,
                    spacing: 20,
                    children: [
                      titleWidget(),
                      textFieldWidget(searchController, "Search"),
                      loginLock(() {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const UserProfile(),
                        ));
                      }),
                      StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection("users")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            return shoppingCart(() {
                              showDialog(
                                context: context,
                                builder: (context) => BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                                  child: AlertDialog(
                                    backgroundColor: transparent,
                                    content: const ShoppingCart(),
                                  ),
                                ),
                              );
                            },
                                snapshot.hasData
                                    ? snapshot.data!
                                        .get("product_in_cart")
                                        .toString()
                                    : "");
                          }),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                color: blackGrey,
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    menuWidget(
                      "Home",
                      [
                        ["Man", () {}],
                        ["Woman", () {}],
                        ["Child", () {}]
                      ],
                    ),
                    menuWidget("Pages", [
                      [
                        "Settings",
                        () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const UserProfile(),
                          ));
                        }
                      ],
                    ]),
                    menuWidget("Contact", [
                      [
                        "Contact Us",
                        () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ContactUs(),
                          ));
                        }
                      ]
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
