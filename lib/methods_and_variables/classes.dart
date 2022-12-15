import 'dart:collection';
import 'package:blue_diamond/methods_and_variables/methods.dart';
import 'package:blue_diamond/methods_and_variables/variables.dart';
import 'package:city_picker_from_map/city_picker_from_map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Product {
  late String imagePath, productName, mark;
  late int originalPrice, discount, stockSize;
  late double ratingValue;
  late List colorsList;
  late List size;
  Product(
    this.size,
    this.colorsList,
    this.imagePath,
    this.productName,
    this.mark,
    this.originalPrice,
    this.discount,
    this.stockSize,
    this.ratingValue,
  );
  Product.fromJson(Map<String, dynamic> json) {
    size = json["size"];
    colorsList = json["colors"];
    imagePath = json["image_path"];
    productName = json["product_name"];
    mark = json["mark"];
    originalPrice = json["original_price"];
    discount = json["remise"];
    stockSize = json["stock_size"];
    ratingValue = json["rating_value"];
  }
}

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({super.key});

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  Widget activity() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: white.withOpacity(.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Activity(),
      ),
    );
  }

  Widget order() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: white.withOpacity(.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Order(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .8,
      width: MediaQuery.of(context).size.width * .6,
      decoration: BoxDecoration(
        image: const DecorationImage(
            image: AssetImage("assets/bg.jpg"), fit: BoxFit.cover),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: textWriter("Shopping Cart", 30, white,
                fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: LayoutBuilder(
                builder: (p0, p1) {
                  if (p1.maxWidth <= 350 || p1.maxHeight <= 350) {
                    return Container();
                  } else if (p1.maxWidth >= 700) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        activity(),
                        const SizedBox(width: 20),
                        order(),
                      ],
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        activity(),
                        const SizedBox(height: 20),
                        order(),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Order extends StatelessWidget {
  const Order({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textWriter("Your Order", 30, white, fontWeight: FontWeight.bold),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Divider(),
            ),
            const SizedBox(height: 20),
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List joiner = [];
                    LinkedHashMap products = snapshot.data!.get("products");
                    products.forEach((key, value) => joiner.addAll(value));
                    return ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: joiner.length,
                      separatorBuilder: (context, index) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 5.0),
                          child: Divider(),
                        );
                      },
                      itemBuilder: (context, index) {
                        return Item(product: joiner[index]);
                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        color: tulip,
                      ),
                    );
                  }
                }),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Divider(),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                textWriter("Delivery / Shipping", 14, tulip,
                    fontWeight: FontWeight.bold),
                textWriter("7 DT (Express)", 14, white.withOpacity(.8),
                    fontWeight: FontWeight.bold),
              ],
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Divider(),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                textWriter("Total", 30, tulip, fontWeight: FontWeight.bold),
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List joiner = [];
                      LinkedHashMap products = snapshot.data!.get("products");
                      products.forEach((key, value) => joiner.addAll(value));
                      double sum = 0;
                      joiner.forEach(
                        (element) {
                          sum += double.parse(element["final_price"]) *
                              element["nb"];
                        },
                      );
                      return textWriter(
                          "${(sum == 0 ? 0 : 7 + sum).toStringAsFixed(2)} DT",
                          30,
                          white.withOpacity(.8),
                          fontWeight: FontWeight.bold);
                    } else {
                      return textWriter("0 DT", 30, white.withOpacity(.8),
                          fontWeight: FontWeight.bold);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Item extends StatelessWidget {
  const Item({super.key, required this.product});
  final Map product;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 120,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(product["img_path"]),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 150,
                  child: Wrap(
                    children: (product["name"] as String)
                        .split(" ")
                        .map((text) => Container(
                              child: textWriter("$text ", 20, white,
                                  fontWeight: FontWeight.bold),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    textWriter("Size ", 18, white, fontWeight: FontWeight.bold),
                    const SizedBox(width: 5),
                    textWriter("${product['size']} ", 18, tulip,
                        fontWeight: FontWeight.bold),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    textWriter("Color ", 18, white,
                        fontWeight: FontWeight.bold),
                    const SizedBox(width: 5),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color.fromARGB(255, product["color"]["r"],
                            product["color"]["g"], product["color"]["b"]),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    textWriter("${product['final_price']} DT", 18, white,
                        fontWeight: FontWeight.bold),
                    const SizedBox(width: 40),
                    textWriter("(x${product['nb']})", 20, tulip,
                        fontWeight: FontWeight.bold),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Activity extends StatefulWidget {
  const Activity({super.key});

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  TextEditingController firstNameController = TextEditingController(text: "");
  TextEditingController lastNameController = TextEditingController(text: "");
  TextEditingController addressController = TextEditingController(text: "");
  TextEditingController aptSuiteController = TextEditingController(text: "");
  TextEditingController postalCodeController = TextEditingController(text: "");
  GlobalKey<FormState> paymentIdentityKey = GlobalKey<FormState>();
  TextEditingController cardNumberController = TextEditingController(text: "");
  TextEditingController expiryDateController = TextEditingController(text: "");
  TextEditingController cvvController = TextEditingController(text: "");
  TextEditingController nameController = TextEditingController(text: "");
  String groupValue = "Home";
  String paymentValue = "In-Place";
  String paymentOption = "Visa";
  String stateValue = "Tunis";
  bool paymentVisibility = false;
  GlobalKey paymentKey = GlobalKey();
  bool saveState = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    addressController.dispose();
    aptSuiteController.dispose();
    postalCodeController.dispose();
    cardNumberController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Row(
                children: [
                  decoratorContainer(
                    "First Name *",
                    firstNameController,
                    dynamicView(context)[0] * .12,
                    pattern: r"[a-zA-Z ]+",
                    validator: (p0) {
                      return inputValidator("first name", p0, r"[a-zA-Z ]+",
                          "first name should contains alphabetics only.");
                    },
                  ),
                  const SizedBox(width: 20),
                  decoratorContainer(
                    "Last Name *",
                    lastNameController,
                    dynamicView(context)[0] * .12,
                    pattern: r"[a-zA-Z ]+",
                    validator: (p0) {
                      return inputValidator("last name", p0, r"[a-zA-Z ]+",
                          "last name should contains alphabetics only.");
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  decoratorContainer(
                    "Address *",
                    addressController,
                    dynamicView(context)[0] * .16,
                    pattern: r"[a-zA-Z ]+",
                    validator: (p0) {
                      return inputValidator("address", p0, r"[a-zA-Z ]+",
                          "address should contains alphabetics and whitespace only.");
                    },
                  ),
                  const SizedBox(width: 20),
                  decoratorContainer("Apt, Suite *", aptSuiteController,
                      dynamicView(context)[0] * .05,
                      pattern: r"\d+", maxLength: 2),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    width: dynamicView(context)[0] * .1,
                    decoration: BoxDecoration(
                      color: white.withOpacity(.3),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: StatefulBuilder(builder: (context, setStated) {
                        return InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Center(
                                    child: InteractiveViewer(
                                      scaleEnabled: true,
                                      panEnabled: true,
                                      constrained: true,
                                      child: CityPickerMap(
                                          actAsToggle: false,
                                          dotColor: tulip,
                                          selectedColor: white.withOpacity(.5),
                                          strokeColor: Colors.lightGreenAccent
                                              .withOpacity(.8),
                                          width: dynamicView(context)[0] * .6,
                                          height: dynamicView(context)[1] * .8,
                                          map: Maps.TUNISIA,
                                          onChanged: (city) {
                                            Navigator.pop(context);
                                            setStated(
                                              () {
                                                stateValue = city!.title;
                                              },
                                            );
                                          }),
                                    ),
                                  );
                                },
                              );
                            },
                            child: textWriter(stateValue, 18, white,
                                fontWeight: FontWeight.bold));
                      }),
                    ),
                  ),
                  const SizedBox(width: 20),
                  decoratorContainer(
                    "",
                    null,
                    dynamicView(context)[0] * .1,
                    readOnly: true,
                    labelValue: "Tunisia",
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: decoratorContainer(
                  "Postal Code *",
                  postalCodeController,
                  dynamicView(context)[0] * .05,
                  maxLength: 4,
                  pattern: r"\d+",
                  validator: (p0) {
                    return inputValidator("postal code", p0, r"\d{4}",
                        "postal code should be only 4 digits.");
                  },
                ),
              ),
              const SizedBox(height: 20),
              Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: textWriter("Address Type", 18, tulip,
                      fontWeight: FontWeight.bold)),
              StatefulBuilder(
                builder: (context, setStated) {
                  return Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: [
                        Container(
                          width: 180,
                          child: Row(
                            children: [
                              Radio<String>(
                                value: "Home",
                                groupValue: groupValue,
                                onChanged: (value) {
                                  setStated(
                                    () {
                                      groupValue = value!;
                                    },
                                  );
                                },
                              ),
                              textWriter("Home (All Day Delivery)", 16, white,
                                  fontWeight: FontWeight.bold)
                            ],
                          ),
                        ),
                        Container(
                          width: 280,
                          child: Row(
                            children: [
                              Radio<String>(
                                value: "Office",
                                groupValue: groupValue,
                                onChanged: (value) {
                                  setStated(
                                    () {
                                      groupValue = value!;
                                    },
                                  );
                                },
                              ),
                              textWriter(
                                  "Office (Delivery Between 10 AM - 5 PM)",
                                  16,
                                  white,
                                  fontWeight: FontWeight.bold)
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: textWriter("Payment Method", 18, tulip,
                      fontWeight: FontWeight.bold)),
              StatefulBuilder(
                builder: (context, setStated) {
                  return Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: [
                        Container(
                          width: 100,
                          child: Row(
                            children: [
                              Radio<String>(
                                value: "In-Place",
                                groupValue: paymentValue,
                                onChanged: (value) {
                                  setStated(() {
                                    paymentValue = value!;
                                  });
                                  paymentKey.currentState!.setState(() {
                                    paymentVisibility = false;
                                  });
                                },
                              ),
                              textWriter("In-Place", 16, white,
                                  fontWeight: FontWeight.bold)
                            ],
                          ),
                        ),
                        Container(
                          width: 100,
                          child: Row(
                            children: [
                              Radio<String>(
                                value: "Credit Card",
                                groupValue: paymentValue,
                                onChanged: (value) {
                                  setStated(() {
                                    paymentValue = value!;
                                  });
                                  paymentKey.currentState!.setState(() {
                                    paymentVisibility = true;
                                  });
                                },
                              ),
                              textWriter("Credit Card", 16, white,
                                  fontWeight: FontWeight.bold)
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              StatefulBuilder(
                  key: paymentKey,
                  builder: (context, setStated) {
                    return Visibility(
                      visible: paymentVisibility ? true : false,
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Form(
                          key: paymentIdentityKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              Container(
                                width: 120,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio<String>(
                                      value: "Visa",
                                      groupValue: paymentOption,
                                      onChanged: (value) {
                                        setStated(() {
                                          paymentOption = value!;
                                        });
                                        paymentKey.currentState!.setState(() {
                                          paymentVisibility = true;
                                        });
                                      },
                                    ),
                                    textWriter("Visa Card", 16, white,
                                        fontWeight: FontWeight.bold)
                                  ],
                                ),
                              ),
                              Container(
                                width: 120,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio<String>(
                                      value: "Other Cards",
                                      groupValue: paymentOption,
                                      onChanged: (value) {
                                        setStated(() {
                                          paymentOption = value!;
                                        });
                                        paymentKey.currentState!.setState(() {
                                          paymentVisibility = true;
                                        });
                                      },
                                    ),
                                    textWriter("Other Cards", 16, white,
                                        fontWeight: FontWeight.bold)
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              textWriter("Payment Cards", 18, tulip,
                                  fontWeight: FontWeight.bold),
                              const SizedBox(height: 10),
                              decoratorContainer(
                                  "Card Number",
                                  cardNumberController,
                                  dynamicView(context)[0] * .2,
                                  pattern: r"\d+",
                                  maxLength: 14),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  decoratorContainer(
                                      "Expiry Date",
                                      expiryDateController,
                                      dynamicView(context)[0] * .15,
                                      pattern: r"[\d/]+",
                                      maxLength: 10),
                                  const SizedBox(width: 20),
                                  decoratorContainer("CVV", cvvController,
                                      dynamicView(context)[0] * .15,
                                      pattern: r"\d+", maxLength: 4),
                                ],
                              ),
                              const SizedBox(height: 10),
                              decoratorContainer("Name", nameController,
                                  dynamicView(context)[0] * .2),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Checkbox(
                                    side: BorderSide(
                                        color: tulip,
                                        width: 1,
                                        style: BorderStyle.solid),
                                    value: saveState,
                                    onChanged: (value) {
                                      setStated(() {
                                        saveState = value!;
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 5),
                                  textWriter("Save Info", 18, white,
                                      fontWeight: FontWeight.bold)
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
              const SizedBox(height: 20),
              Row(
                children: [
                  MaterialButton(
                    splashColor: transparent,
                    focusColor: transparent,
                    highlightColor: transparent,
                    hoverColor: transparent,
                    color: black,
                    animationDuration: const Duration(milliseconds: 700),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        if (paymentValue == "Credit Card") {
                          if (paymentIdentityKey.currentState!.validate()) {
                            FirebaseFirestore.instance
                                .collection("users")
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .update({"products": {}, "product_in_cart": 0});
                            toast("Verifying Identity");
                            toast(
                                "Purchasing is done, wait couple of minutes until the deliverer calls you");
                            toast("Thanks for trusting us");
                            Navigator.pop(context);
                          }
                        } else {
                          FirebaseFirestore.instance
                              .collection("users")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .update({"products": {}, "product_in_cart": 0});
                          toast("Verifying Identity");
                          toast(
                              "Purchasing is done, wait couple of minutes until the deliverer calls you");
                          toast("Thanks for trusting us");
                          Navigator.pop(context);
                        }
                      } else {
                        toast("Wrong Info Formats");
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      child: textWriter(
                          "Save And Deliver Here", 18, white.withOpacity(.8)),
                    ),
                  ),
                  const SizedBox(width: 20),
                  InkWell(
                    splashColor: transparent,
                    focusColor: transparent,
                    highlightColor: transparent,
                    hoverColor: transparent,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: textWriter("Cancel", 18, white.withOpacity(.8)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
