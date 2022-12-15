import 'dart:ui';
import 'package:badges/badges.dart';
import 'package:blue_diamond/methods_and_variables/classes.dart';
import 'package:blue_diamond/methods_and_variables/methods.dart';
import 'package:blue_diamond/methods_and_variables/variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProductsView extends StatefulWidget {
  const ProductsView({super.key, required this.products});
  final List<Product> products;

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  TextEditingController searchController = TextEditingController(text: "");
  late List<Product> products = widget.products;
  GlobalKey productsKey = GlobalKey();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void filterEngine() {
    products = widget.products
        .where((Product product) => product.productName
            .toLowerCase()
            .contains(searchController.text.trim().toLowerCase()))
        .toList();
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
          Padding(
            padding:
                const EdgeInsets.only(top: 75, bottom: 16, right: 2, left: 2),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    StatefulBuilder(
                      key: productsKey,
                      builder: (context, s) {
                        return Wrap(
                          spacing: 30,
                          runSpacing: 30,
                          children: products.isEmpty
                              ? [
                                  Center(
                                    child: textWriter(
                                        "No Products With This Description",
                                        50,
                                        tulip),
                                  )
                                ]
                              : products
                                  .map((product) => productCard(product))
                                  .toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: textFieldWidget(
                    searchController,
                    "Type",
                    prefixIcon: Icons.search,
                    onChange: (p0) {
                      productsKey.currentState!.setState(() {
                        filterEngine();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 20),
                Container(
                  height: 50,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: white.withOpacity(.4),
                  ),
                  child: Badge(
                    position: BadgePosition.bottomEnd(),
                    animationDuration: const Duration(milliseconds: 300),
                    animationType: BadgeAnimationType.slide,
                    elevation: 8,
                    showBadge: true,
                    toAnimate: true,
                    badgeColor: tulip,
                    badgeContent:
                        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                            stream: FirebaseFirestore.instance
                                .collection("users")
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              DocumentSnapshot<Map<String, dynamic>>? data =
                                  snapshot.data;
                              return textWriter(
                                  data != null
                                      ? data.get("product_in_cart").toString()
                                      : "0",
                                  12,
                                  white);
                            }),
                    child: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                            child: AlertDialog(
                              backgroundColor: transparent,
                              content: const ShoppingCart(),
                            ),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.shopping_cart_sharp,
                        color: white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
