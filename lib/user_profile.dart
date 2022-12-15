import 'dart:math';
import 'package:blue_diamond/auth/signin.dart';
import 'package:blue_diamond/methods_and_variables/methods.dart';
import 'package:blue_diamond/methods_and_variables/variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.bestForNavigation,
    distanceFilter: 0,
  );
  String coordinates = "Unknown";
  GlobalKey locationKey = GlobalKey();
  bool isSignOutButtonHovered = false;
  bool isBackButtonHovered = false;
  TextEditingController usernameController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");
  bool usernameState = false;
  bool passwordState = false;
  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void coordinatesLoader() async {
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position? position) {
      if (position == null) {
        coordinates = 'Unknown';
      } else if (coordinates !=
          '( ${position.latitude} , ${position.longitude} )') {
        coordinates = '( ${position.latitude} , ${position.longitude} )';

        locationKey.currentState!.setState(() {});
      }
    });
  }

  @override
  void initState() {
    coordinatesLoader();
    super.initState();
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
                image: AssetImage("assets/bg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height * .8,
              width: MediaQuery.of(context).size.width * .6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: const DecorationImage(
                    image: AssetImage("assets/bg.jpg"), fit: BoxFit.cover),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(64.0),
                  child: Column(
                    children: [
                      Align(
                          alignment: AlignmentDirectional.topStart,
                          child: textWriter("Account Info", 30, white)),
                      const SizedBox(height: 30),
                      StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            Map? data = snapshot.data!.data();
                            return Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        XFile? image =
                                            await ImagePicker().pickImage(
                                          source: ImageSource.gallery,
                                          imageQuality: 100,
                                        );

                                        if (image != null) {
                                          CroppedFile? imageCropped =
                                              await ImageCropper().cropImage(
                                            sourcePath: image.path,
                                            compressFormat:
                                                ImageCompressFormat.jpg,
                                            compressQuality: 100,
                                            uiSettings: <PlatformUiSettings>[
                                              WebUiSettings(
                                                  context: context,
                                                  boundary: CroppieBoundary(
                                                    width: (dynamicView(
                                                                context)[0] *
                                                            .6)
                                                        .toInt(),
                                                    height: (dynamicView(
                                                                context)[0] *
                                                            .6)
                                                        .toInt(),
                                                  ),
                                                  mouseWheelZoom: true,
                                                  enableExif: true,
                                                  enableOrientation: true,
                                                  enableResize: true,
                                                  enableZoom: true,
                                                  enforceBoundary: true,
                                                  showZoomer: true,
                                                  presentStyle:
                                                      CropperPresentStyle
                                                          .dialog),
                                            ],
                                          );
                                          if (imageCropped != null) {
                                            await FirebaseFirestore.instance
                                                .collection("users")
                                                .doc(FirebaseAuth
                                                    .instance.currentUser!.uid)
                                                .update({"image_url": ""});
                                          }
                                        }
                                      },
                                      child: Stack(
                                        alignment: AlignmentDirectional.topEnd,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: data!["image_url"].isEmpty
                                                ? Image.asset(
                                                    "assets/icognito.png",
                                                    width: 200,
                                                    height: 200,
                                                  )
                                                : Image.asset(
                                                    data["image_url"],
                                                    width: 100,
                                                    height: 100,
                                                  ),
                                          ),
                                          Icon(
                                            FontAwesomeIcons.penNib,
                                            color: white,
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        textWriter(
                                            "${data['firstname'] + ' ' + data['lastname']}",
                                            22,
                                            white),
                                        Container(
                                          height: 2,
                                          width:
                                              "${data['firstname'] + ' ' + data['lastname']}"
                                                      .length *
                                                  10,
                                          decoration: BoxDecoration(
                                            color: Colors.primaries[Random()
                                                .nextInt(
                                                    Colors.primaries.length)],
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30),
                                Container(
                                  decoration: BoxDecoration(
                                    color: white.withOpacity(.1),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      StatefulBuilder(
                                        builder: (context, stater) {
                                          return AnimatedSwitcher(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            child: !usernameState
                                                ? infoWidget("Username",
                                                    "${data['firstname'] + ' ' + data['lastname']}",
                                                    () {
                                                    stater(() {
                                                      usernameState = true;
                                                    });
                                                  })
                                                : textFieldWidget(
                                                    usernameController,
                                                    "Username",
                                                    onSubmit: (p0) {
                                                      stater(() {
                                                        usernameState = false;
                                                      });
                                                      List<String> fullname =
                                                          usernameController
                                                                  .text
                                                                  .trim()
                                                                  .split(" ") +
                                                              [" ", " "];
                                                      FirebaseFirestore.instance
                                                          .collection("users")
                                                          .doc(FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid)
                                                          .update(
                                                        {
                                                          "firstname":
                                                              fullname[0],
                                                          "lastname":
                                                              fullname[1],
                                                        },
                                                      );
                                                    },
                                                  ),
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 10),
                                      infoWidget(
                                          "E-mail", "${data['email']}", null),
                                      const SizedBox(height: 10),
                                      StatefulBuilder(
                                        builder: (context, stater) {
                                          return AnimatedSwitcher(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            child: !passwordState
                                                ? infoWidget(
                                                    "Password",
                                                    "*" *
                                                        "${data['password']}"
                                                            .length, () {
                                                    stater(() {
                                                      passwordState = true;
                                                    });
                                                  })
                                                : textFieldWidget(
                                                    passwordController,
                                                    "Password",
                                                    onSubmit: (p0) {
                                                      stater(() {
                                                        passwordState = false;
                                                      });
                                                      FirebaseFirestore.instance
                                                          .collection("users")
                                                          .doc(FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid)
                                                          .update(
                                                        {
                                                          "password":
                                                              passwordController
                                                                  .text
                                                                  .trim(),
                                                        },
                                                      );
                                                    },
                                                  ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                color: tulip,
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: white.withOpacity(.1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: StatefulBuilder(
                          key: locationKey,
                          builder: (context, setState) {
                            return infoWidget("Location", coordinates, null);
                          },
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          StatefulBuilder(
                            builder: (context, setStated) {
                              return InkWell(
                                onTap: () async {
                                  Navigator.pop(context);
                                },
                                onHover: (value) {
                                  setStated(() {
                                    isBackButtonHovered = value;
                                  });
                                },
                                child: Container(
                                  height: 40,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: white.withOpacity(.1),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      FontAwesomeIcons.chevronLeft,
                                      size: 20,
                                      color:
                                          isBackButtonHovered ? tulip : white,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          StatefulBuilder(
                            builder: (context, setStated) {
                              return InkWell(
                                onTap: () async {
                                  await FirebaseAuth.instance.signOut();
                                  // ignore: use_build_context_synchronously
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SignIn(),
                                    ),
                                  );
                                },
                                onHover: (value) {
                                  setStated(() {
                                    isSignOutButtonHovered = value;
                                  });
                                },
                                child: Container(
                                  height: 40,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: white.withOpacity(.1),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Center(
                                    child: textWriter("Sign-Out", 20,
                                        isSignOutButtonHovered ? tulip : white),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      )
                    ],
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
