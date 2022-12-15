import 'dart:collection';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:blue_diamond/mainer/products_view.dart';
import 'package:blue_diamond/methods_and_variables/classes.dart';
import 'package:blue_diamond/methods_and_variables/variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:window_style_dropdown_menu/window_style_dropdown_menu.dart';

Widget rowWidget(String text, IconData icon) {
  return Row(
    children: [
      Icon(
        icon,
        size: 15,
        color: tulip,
      ),
      const SizedBox(
        width: 10,
      ),
      Text(
        text,
        style: GoogleFonts.abel(color: secondaryWhite),
      )
    ],
  );
}

Widget iconWidget(void Function() func, IconData icon) {
  return Container(
    child: IconButton(
      onPressed: func,
      icon: Icon(
        icon,
        size: 15,
        color: tulip,
      ),
    ),
  );
}

TextStyle titleStyleWidget(Color color, FontWeight? fontWeight) {
  return GoogleFonts.abel(color: color, fontSize: 25, fontWeight: fontWeight);
}

Widget loginLock(void Function() func) {
  bool isHovered = false;
  return StatefulBuilder(builder: (context, setState) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: const Color.fromARGB(255, 38, 38, 38),
      ),
      child: InkWell(
        onTap: func,
        onHover: (value) {
          setState(() {
            isHovered = value;
          });
        },
        child: Center(
          child: Icon(
            FontAwesomeIcons.lock,
            color: !isHovered ? Colors.white : tulip,
            size: 20,
          ),
        ),
      ),
    );
  });
}

Widget shoppingCart(void Function() func, String numberOfItemsAndTheirPrices) {
  bool isHovered = false;
  return StatefulBuilder(builder: (context, setState) {
    return InkWell(
      onTap: func,
      onHover: (value) {
        setState(
          () {
            isHovered = value;
          },
        );
      },
      child: Container(
        width: 150,
        color: isHovered ? tulip : const Color.fromARGB(255, 38, 38, 38),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textWriter("Shopping Cart", 16, Colors.white),
                  textWriter(numberOfItemsAndTheirPrices, 14,
                      Colors.white.withOpacity(.5)),
                ],
              ),
              const Icon(
                FontAwesomeIcons.wallet,
                color: Colors.white,
                size: 20,
              )
            ],
          ),
        ),
      ),
    );
  });
}

Widget textWriter(String text, double fontSize, Color color,
    {FontWeight fontWeight = FontWeight.normal}) {
  return Text(
    text,
    overflow: TextOverflow.ellipsis,
    style: GoogleFonts.abel(
        fontSize: fontSize, color: color, fontWeight: fontWeight),
  );
}

Widget textFieldWidget(TextEditingController? controller, String labelText,
    {IconData? suffixIconBefore,
    void Function(String)? onChange,
    IconData? suffixIconAfter,
    int maxLines = 1,
    bool readOnly = false,
    void Function(String)? onSubmit,
    double containerWidth = 400,
    Color containerColor = Colors.transparent,
    RegExp? filterPattern,
    int maxLength = 255,
    String? Function(String?)? validator,
    IconData? prefixIcon}) {
  bool state = true;
  return StatefulBuilder(
    builder: (context, setState) {
      return Container(
        width: containerWidth,
        color: containerColor,
        child: TextFormField(
          maxLines: maxLines,
          readOnly: readOnly,
          cursorColor: tulip,
          style: const TextStyle(color: Colors.white),
          controller: controller,
          obscureText: labelText == "Password" ? state : false,
          inputFormatters: [
            FilteringTextInputFormatter(filterPattern ?? RegExp(r".*"),
                allow: true),
            LengthLimitingTextInputFormatter(maxLength),
          ],
          onFieldSubmitted: onSubmit,
          onChanged: onChange != null
              ? (value) {
                  onChange(value);
                }
              : null,
          validator: validator,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: tulip),
            ),
            suffixIcon: suffixIconBefore != null
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        state = !state;
                      });
                    },
                    icon: Icon(
                      state ? suffixIconBefore : suffixIconAfter,
                      color: tulip,
                      size: 20,
                    ),
                  )
                : null,
            prefixIcon: Icon(
              prefixIcon,
              color: tulip,
              size: 20,
            ),
            labelText: labelText,
            labelStyle: TextStyle(
              color: white.withOpacity(.8),
            ),
          ),
        ),
      );
    },
  );
}

Widget menuWidget(String name, List<List> children) {
  bool isHovered = false;
  return StatefulBuilder(
    builder: (context, setState) {
      return InkWell(
        onTap: () {},
        onHover: (value) {
          setState(() {
            isHovered = value;
          });
        },
        child: WindowStyleDropdownMenu(
          buttonTitle: name,
          buttonTitleStyle:
              GoogleFonts.abel(fontSize: 18, color: isHovered ? tulip : white),
          dropdownItems: children.map((e) {
            return ListTile(
              hoverColor: tulip,
              title: Text(
                e[0],
                style: GoogleFonts.abel(
                  fontSize: 18,
                  color: white,
                ),
              ),
              onTap: e[1],
            );
          }).toList(),
          dropdownBackgroundColor: white.withOpacity(.1),
        ),
      );
    },
  );
}

Widget carouselWidget(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    child: IntroSlider(
      indicatorConfig: IndicatorConfig(
          colorIndicator: white,
          colorActiveIndicator: tulip,
          typeIndicatorAnimation: TypeIndicatorAnimation.sliding),
      isShowNextBtn: true,
      isShowPrevBtn: true,
      isShowDoneBtn: false,
      isShowSkipBtn: false,
      autoScrollInterval: const Duration(seconds: 6),
      curveScroll: Curves.fastOutSlowIn,
      isLoopAutoScroll: true,
      isAutoScroll: true,
      scrollPhysics: const NeverScrollableScrollPhysics(),
      renderNextBtn: Icon(
        FontAwesomeIcons.chevronRight,
        color: tulip,
        size: 50,
      ),
      renderPrevBtn: Icon(
        FontAwesomeIcons.chevronLeft,
        color: tulip,
        size: 50,
      ),
      listCustomTabs: List.generate(
        6,
        (index) => Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Image.asset(
            "assets/$index.jpg",
            fit: BoxFit.cover,
          ),
        ),
      ),
    ),
  );
}

Widget titleWidget() {
  return Container(
    child: RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: "M",
            style: titleStyleWidget(tulip, FontWeight.bold),
          ),
          TextSpan(
            text: "on",
            style: titleStyleWidget(white, null),
          ),
          const TextSpan(text: " "),
          TextSpan(
            text: "P",
            style: titleStyleWidget(tulip, FontWeight.bold),
          ),
          TextSpan(
            text: "anier",
            style: titleStyleWidget(white, null),
          )
        ],
      ),
    ),
  );
}

Widget genderWidget(
    String text, IconData icon, void Function() func, List<List> children) {
  bool isHovered = false;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      StatefulBuilder(builder: (context, setState) {
        return Container(
          color: isHovered ? black : Colors.white.withOpacity(.2),
          width: 300,
          child: Row(
            children: [
              Container(
                color: tulip,
                width: 40,
                height: 40,
                child: Center(
                  child: Icon(
                    icon,
                  ),
                ),
              ),
              Container(
                width: 260,
                height: 40,
                child: InkWell(
                  onHover: (value) {
                    setState(() {
                      isHovered = value;
                    });
                  },
                  onTap: func,
                  child: Center(
                    child: Text(
                      text.toUpperCase(),
                      style: GoogleFonts.abel(color: white, fontSize: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
      ...children.map((e) => genderElement(e[0], e[1])).toList(),
    ],
  );
}

Widget genderElement(String text, void Function() func) {
  bool isHovered = false;
  return Container(
    width: 300,
    child: StatefulBuilder(builder: (context, setState) {
      return InkWell(
        onTap: () {},
        onHover: (value) {
          setState(() {
            isHovered = value;
          });
        },
        child: ListTile(
          onTap: func,
          leading: Icon(
            Icons.done,
            size: 20,
            color: isHovered ? tulip : white.withOpacity(.5),
          ),
          title: Text(
            text,
            style: GoogleFonts.abel(
              color: isHovered ? tulip : white.withOpacity(.5),
              fontSize: isHovered ? 22 : 20,
            ),
          ),
        ),
      );
    }),
  );
}

Widget productDetails(BuildContext context, Product product) {
  List<bool> sizeListStates =
      List.generate(product.size.length, (index) => false);
  sizeListStates[0] = true;
  List<bool> colorListStates =
      List.generate(product.colorsList.length, (index) => false);
  colorListStates[0] = true;
  return Container(
    width: MediaQuery.of(context).size.width * .7,
    height: MediaQuery.of(context).size.height * .7,
    decoration: BoxDecoration(
      image: const DecorationImage(
          image: AssetImage("assets/bg.jpg"), fit: BoxFit.cover),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Image.asset(
                product.imagePath,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Wrap(
                      children: product.productName
                          .split(" ")
                          .map(
                            (String text) => textWriter("$text ", 20, white,
                                fontWeight: FontWeight.bold),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "${product.originalPrice.toStringAsFixed(2)} DT",
                        style: TextStyle(
                            fontSize: 18,
                            color: white.withOpacity(.8),
                            decoration: TextDecoration.lineThrough),
                      ),
                      const SizedBox(width: 10),
                      textWriter("( - ${product.discount} % )", 18,
                          white.withOpacity(.8)),
                      const SizedBox(width: 30),
                      textWriter(
                          "${(product.originalPrice - product.originalPrice * product.discount / 100).toStringAsFixed(2)} DT",
                          18,
                          tulip,
                          fontWeight: FontWeight.bold),
                    ],
                  ),
                  const SizedBox(height: 10),
                  RatingBar.builder(
                    ignoreGestures: true,
                    allowHalfRating: true,
                    itemCount: 5,
                    unratedColor: white.withOpacity(.6),
                    initialRating: product.ratingValue,
                    itemSize: 20.0,
                    itemPadding: const EdgeInsets.only(right: 4),
                    itemBuilder: (context, index) {
                      return Icon(FontAwesomeIcons.star, color: tulip);
                    },
                    onRatingUpdate: (value) {},
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: StatefulBuilder(
                      builder: (context, set) {
                        return Container(
                          decoration: BoxDecoration(
                            color: white.withOpacity(.1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                for (int i = 0; i < product.size.length; i++)
                                  InkWell(
                                    onTap: () {
                                      if (!sizeListStates[i]) {
                                        set(() {
                                          for (int j = 0;
                                              j < sizeListStates.length;
                                              j++) {
                                            sizeListStates[j] = false;
                                          }
                                          sizeListStates[i] = true;
                                        });
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: sizeListStates[i]
                                            ? white.withOpacity(.2)
                                            : transparent,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: textWriter(
                                            product.size[i],
                                            16,
                                            tulip,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  StatefulBuilder(
                    builder: (context, set) {
                      return Container(
                        decoration: BoxDecoration(
                          color: white.withOpacity(.1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              for (int i = 0;
                                  i < product.colorsList.length;
                                  i++)
                                InkWell(
                                  onTap: () {
                                    if (!colorListStates[i]) {
                                      set(() {
                                        for (int j = 0;
                                            j < colorListStates.length;
                                            j++) {
                                          colorListStates[j] = false;
                                        }
                                        colorListStates[i] = true;
                                      });
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(
                                          255,
                                          product.colorsList[i][0],
                                          product.colorsList[i][1],
                                          product.colorsList[i][2],
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      child: colorListStates[i]
                                          ? const Center(
                                              child: Icon(
                                                Icons.done,
                                                color: Colors.lightGreenAccent,
                                              ),
                                            )
                                          : null,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        DocumentSnapshot<Map<String, dynamic>>? data =
                            snapshot.data;
                        return Row(
                          children: [
                            InkWell(
                              onTap: () {
                                if (data!.get("product_in_cart") != 0) {
                                  LinkedHashMap<String, dynamic> prods =
                                      data.get("products");

                                  () {
                                    for (Map<String, dynamic> v
                                        in prods[product.productName]) {
                                      if (v["size"] ==
                                              product.size[
                                                  sizeListStates.indexWhere(
                                                      (element) => element)] &&
                                          const ListEquality().equals(
                                              v["color"].values.toList(),
                                              product.colorsList[
                                                  colorListStates.indexWhere(
                                                      (element) => element)])) {
                                        if (v["nb"] > 1) {
                                          v["nb"] -= 1;
                                        } else {
                                          v.clear();
                                        }
                                        List li = prods[product.productName];
                                        li.removeWhere(
                                            (element) => element.length == 0);
                                        prods[product.productName] = li;
                                        prods.removeWhere(
                                            (key, value) => value.length == 0);
                                        FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .update(
                                          {
                                            "product_in_cart":
                                                data.get("product_in_cart") - 1,
                                            "products": prods,
                                          },
                                        );
                                        return;
                                      }
                                    }
                                  }();
                                }
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    color: tulip,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Icon(
                                    FontAwesomeIcons.minus,
                                    color: white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            textWriter(
                              data != null
                                  ? data.get("product_in_cart").toString()
                                  : "0",
                              20,
                              white,
                            ),
                            const SizedBox(width: 20),
                            InkWell(
                              onTap: () {
                                LinkedHashMap<String, dynamic> prods =
                                    data!.get("products");
                                prods.update(
                                  product.productName,
                                  (value) {
                                    for (Map v in value) {
                                      if (v["size"] ==
                                              product.size[
                                                  sizeListStates.indexWhere(
                                                      (element) => element)] &&
                                          const ListEquality().equals(
                                              v["color"].values.toList(),
                                              product.colorsList[
                                                  colorListStates.indexWhere(
                                                      (element) => element)])) {
                                        v["nb"] += 1;
                                        return value;
                                      }
                                    }
                                    List color = product.colorsList[
                                        colorListStates
                                            .indexWhere((element) => element)];
                                    return value +
                                        [
                                          {
                                            "name": product.productName,
                                            "img_path": product.imagePath,
                                            "final_price":
                                                (product.originalPrice -
                                                        product.originalPrice *
                                                            product.discount /
                                                            100)
                                                    .toStringAsFixed(2),
                                            "size": product.size[
                                                sizeListStates.indexWhere(
                                                    (element) => element)],
                                            "color": {
                                              "r": color[0],
                                              "g": color[1],
                                              "b": color[2]
                                            },
                                            "nb": 1
                                          }
                                        ];
                                  },
                                  ifAbsent: () {
                                    List color = product.colorsList[
                                        colorListStates
                                            .indexWhere((element) => element)];
                                    return [
                                      {
                                        "name": product.productName,
                                        "img_path": product.imagePath,
                                        "final_price": (product.originalPrice -
                                                product.originalPrice *
                                                    product.discount /
                                                    100)
                                            .toStringAsFixed(2),
                                        "size": product.size[sizeListStates
                                            .indexWhere((element) => element)],
                                        "color": {
                                          "r": color[0],
                                          "g": color[1],
                                          "b": color[2]
                                        },
                                        "nb": 1
                                      }
                                    ];
                                  },
                                );
                                FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .update({
                                  "product_in_cart":
                                      data.get("product_in_cart") + 1,
                                  "products": prods
                                });
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    color: tulip,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Icon(
                                    FontAwesomeIcons.plus,
                                    color: white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ),
  );
}

Widget productCard(Product product) {
  bool isCardHovered = false;
  return StatefulBuilder(
    builder: (context, setState) {
      return AnimatedScale(
        scale: isCardHovered ? 1.1 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          width: 350,
          height: 450,
          color: isCardHovered ? tulip : white.withOpacity(.5),
          child: InkWell(
            splashColor: transparent,
            focusColor: transparent,
            highlightColor: transparent,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: AlertDialog(
                    backgroundColor: transparent,
                    content: productDetails(context, product),
                  ),
                ),
              );
            },
            onHover: (value) {
              setState(() {
                isCardHovered = value;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    product.imagePath,
                    alignment: AlignmentDirectional.center,
                    width: 250,
                    height: 250,
                  ),
                  Wrap(
                    children: product.productName
                        .split(" ")
                        .map((e) => textWriter("$e ", 20, white))
                        .toList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            textWriter(product.ratingValue.toStringAsFixed(2),
                                16, white.withOpacity(.8)),
                            const Icon(
                              Icons.star,
                              color: Colors.amberAccent,
                              size: 20,
                            ),
                          ],
                        ),
                        textWriter(
                          "${(product.originalPrice - product.discount * product.originalPrice / 100).toStringAsFixed(2)} DT",
                          18,
                          white,
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: isCardHovered ? true : false,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Center(
                        child: MaterialButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                                child: AlertDialog(
                                  backgroundColor: transparent,
                                  content: productDetails(context, product),
                                ),
                              ),
                            );
                          },
                          height: 40,
                          color: isCardHovered
                              ? Colors.amberAccent
                              : Colors.transparent,
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(color: Colors.amberAccent),
                              borderRadius: BorderRadius.circular(5)),
                          textColor: white,
                          child: textWriter("Add To Cart", 20, white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Future<List<Product>> productInfo(String subject) async {
  String response = await rootBundle.loadString("transformer.json");
  List data = (await json.decode(response))[subject];
  return data.map((data) => Product.fromJson(data)).toList();
}

void travelToProduct(BuildContext context, String subject) async {
  List<Product> products = await productInfo(subject);
  // ignore: use_build_context_synchronously
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ProductsView(
        products: products,
      ),
    ),
  );
}

TextSpan textSpanWriter(String text, double fontSize, Color color) {
  return TextSpan(
      text: text, style: GoogleFonts.abel(color: color, fontSize: fontSize));
}

Widget routeButton(String text, void Function() func) {
  return AnimatedButton(
    text: text,
    onPress: func,
    animatedOn: AnimatedOn.onHover,
    animationDuration: const Duration(milliseconds: 500),
    backgroundColor: white.withOpacity(.2),
    borderColor: tulip,
    borderRadius: 5,
    borderWidth: 1,
    width: 200,
    selectedBackgroundColor: tulip,
    selectedTextColor: white,
    height: 40,
  );
}

String? inputValidator(
    String field, String? value, String regex, String description) {
  if (value!.isEmpty) {
    return "$field ${[
      'cannot be empty',
      'cannot be empty',
      'is mandatory'
    ][Random().nextInt(3)]}";
  } else if (!RegExp(regex).hasMatch(value)) {
    return description;
  }
  return null;
}

Widget infoWidget(String title, String subtitle, void Function()? change) {
  return ListTile(
    onTap: change,
    title: textWriter(title, 16, white.withOpacity(.6)),
    subtitle: textWriter(subtitle, 18, white),
  );
}

Widget decoratorContainer(
    String header, TextEditingController? controller, double maxWidth,
    {bool readOnly = false,
    String? Function(String?)? validator,
    String labelValue = "",
    String pattern = r"\w*",
    int maxLength = 255}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (header.isNotEmpty)
        textWriter(header, 18, tulip, fontWeight: FontWeight.bold),
      Container(
        width: maxWidth,
        decoration: BoxDecoration(
          color: white.withOpacity(.3),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: TextFormField(
          validator: validator,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(pattern)),
            LengthLimitingTextInputFormatter(maxLength)
          ],
          showCursor: false,
          readOnly: readOnly,
          controller: controller,
          style: TextStyle(color: white),
          decoration: InputDecoration(
            hintText: labelValue,
            hintStyle: TextStyle(color: white, fontWeight: FontWeight.bold),
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              borderSide: BorderSide(width: 0, color: transparent),
            ),
            constraints: BoxConstraints(maxWidth: maxWidth),
            hoverColor: tulip,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          ),
        ),
      ),
    ],
  );
}

List<double> dynamicView(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  return [size.width, size.height];
}

Future<bool?> toast(String text) {
  return Fluttertoast.showToast(
    msg: text,
    backgroundColor: tulip,
    fontSize: 20,
    gravity: ToastGravity.BOTTOM,
    textColor: white,
    timeInSecForIosWeb: 4,
    toastLength: Toast.LENGTH_LONG,
    webBgColor: "rgb(33,150,243)",
    webPosition: "center",
    webShowClose: true,
  );
}

Widget amazingContainer(String text, IconData icon) {
  bool hovered = false;
  return StatefulBuilder(builder: (context, se) {
    return InkWell(
      onHover: (bool value) {
        se(() {
          hovered = value;
        });
      },
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: hovered ? tulip : transparent)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 15,
              color: tulip,
            ),
            const SizedBox(width: 10),
            textWriter(text, 18, white.withOpacity(.8)),
          ],
        ),
      ),
    );
  });
}

Widget roundedIcon(IconData icon) {
  bool hovered = false;
  return StatefulBuilder(
    builder: (context, setState) {
      return AnimatedAlign(
        duration: const Duration(milliseconds: 500),
        alignment: Alignment(0, hovered ? 1 : 0),
        child: InkWell(
          splashColor: transparent,
          highlightColor: transparent,
          hoverColor: transparent,
          onHover: (value) {
            setState(() {
              hovered = value;
            });
          },
          onTap: () {},
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: hovered ? tulip : transparent,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Center(child: Icon(icon, size: 20, color: white)),
          ),
        ),
      );
    },
  );
}

Widget wordColorizer(String text, Color normalColor, Color hoverColor) {
  bool isHovered = false;
  return StatefulBuilder(builder: (context, setState) {
    return InkWell(
      onTap: () {},
      onHover: (value) {
        setState(() {
          isHovered = value;
        });
      },
      child: textWriter(
        "$text ",
        18,
        isHovered ? hoverColor : normalColor,
      ),
    );
  });
}
