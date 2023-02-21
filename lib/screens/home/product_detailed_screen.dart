// ignore_for_file: prefer_typing_uninitialized_variables, use_key_in_widget_constructors

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:grocery_app/constants/ConstantValue.dart';
import 'package:grocery_app/constants/SystemColors.dart';
import 'package:grocery_app/tools/SnackBar.dart';
import 'package:grocery_app/widget/add_review_widget.dart';
import 'package:grocery_app/widget/review_card_widget.dart';

import '../../constants/get_info.dart';

class ProductDetailedScreen extends StatefulWidget {
  ProductDetailedScreen(this.productData);
  final productData;
  static List allReviews = [];
  @override
  _ProductDetailedScreenState createState() => _ProductDetailedScreenState();
}

double _rating = 0;
ScrollController? _controller;

// check that, this product is already in user cart or not 🙄
bool productInCart = false;

class _ProductDetailedScreenState extends State<ProductDetailedScreen>
    with SingleTickerProviderStateMixin {
  //tab controller
  TabController? _tabController;

  // check that a particular product is in stock or not
  bool inStock = true;

  // product stock
  double productStock = 0;
  // product unit
  String unit = '';

  bool isFavorite = false;
  reviewCallBack(var review) {
    setState(() {
      ProductDetailedScreen.allReviews.add(review);
      _rating = widget.productData['rating'] /
          ProductDetailedScreen.allReviews.length;
    });
  }

  @override
  void initState() {
    _getNumbersOfReviews(widget.productData);
    productStock = double.parse(widget.productData['product_stock']);
    unit = widget.productData['product_unit'] == '/ 1 pc' ? 'pc' : 'g';
    if (unit == 'pc' && productStock > 0) {
      setState(() {
        inStock = true;
      });
    } else if (unit == 'g' && productStock > 500) {
      setState(() {
        inStock = true;
      });
    } else {
      setState(() {
        inStock = false;
      });
    }
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
      ),
      body: Container(
        height: getScreenSize(context).height,
        child: ListView(children: [
          Image.network(
            widget.productData['product_image'],
            fit: BoxFit.cover,
          ),
          // Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: getScreenSize(context).width - 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // product name
                          SizedBox(
                            width: getScreenSize(context).width - 70,
                            child: Text(
                              widget.productData['product_name'],
                              softWrap: true,
                              maxLines: 2,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                          ),
                          // add your favorite product
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isFavorite = !isFavorite;
                                });
                              },
                              child: isFavorite
                                  ? Icon(
                                      Icons.favorite_rounded,
                                      color: mainColor,
                                    )
                                  : const Icon(
                                      Icons.favorite_border_rounded,
                                      color: Color.fromARGB(174, 0, 0, 0),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // price widget
                    SizedBox(
                      width: getScreenSize(context).width - 30,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.currency_rupee_rounded,
                                  size: 20,
                                ),
                                Text(
                                  widget.productData['product_price'],
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Text(
                                inStock ? "" : "SOLD OUT",
                                style: TextStyle(
                                    color: inStock
                                        ? Colors.green
                                        : Colors.red[400],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17),
                              ),
                            )
                          ]),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // product review
          Container(
            margin: const EdgeInsets.only(left: 15, bottom: 10),
            child: Row(
              children: [
                RatingBarIndicator(
                    unratedColor: Colors.grey[400],
                    rating: _rating,
                    itemSize: 20,
                    itemBuilder: (context, index) => Icon(
                          Icons.star_rounded,
                          color: Colors.yellow[800],
                        )),
                Text(
                  ' (${ProductDetailedScreen.allReviews.length} reviews)',
                  style: TextStyle(color: Colors.black.withOpacity(0.5)),
                ),
              ],
            ),
          ),
          // buy and add to cart button

          //Tab

          // TabBarView
          DefaultTabController(
            length: _tabController!.length,
            child: Column(
              children: [
                Container(
                  height: 40,
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20)),
                  child: TabBar(
                      controller: _tabController,
                      splashBorderRadius: BorderRadius.circular(30),
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: mainColor),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      labelStyle: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 18),
                      tabs: const [
                        Tab(
                          text: 'Product Info',
                        ),
                        Tab(
                          text: 'Reviews',
                        )
                      ]),
                ),
                SizedBox(
                  height: getScreenSize(context).height,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      ProductInfoWidget(widget.productData),
                      Expanded(
                          child: ReviewTabViewWidget(
                              widget.productData, reviewCallBack))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: getScreenSize(context).width,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                child: IconButton(
                    padding: const EdgeInsets.all(10),
                    style: IconButton.styleFrom(
                      side: BorderSide(color: mainColor, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      _addToCart(widget.productData);
                    },
                    icon: const Icon(
                      Icons.add_shopping_cart_rounded,
                      color: Colors.green,
                    ))),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      "Buy",
                      style: TextStyle(color: textColor, fontSize: 16),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

// get number of users that given a reviews
  void _getNumbersOfReviews(var productData) async {
    ProductDetailedScreen.allReviews.clear();
    await FirebaseDatabase.instance
        .ref('sellers/${uid}/products/${productData['product_id']}/reviews')
        .get()
        .then((value) {
      for (var review in value.children) {
        setState(() {
          ProductDetailedScreen.allReviews.add(review.value);
        });
      }
      if (ProductDetailedScreen.allReviews.isNotEmpty) {
        setState(() {
          ProductDetailedScreen.allReviews.reversed;
          _rating = widget.productData['rating'] /
              ProductDetailedScreen.allReviews.length;
        });
      }
    });
  }

  // add product in your cart
  void _addToCart(var productData) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('users/${uid}/cart');
    await ref.get().then((value) {
      if (value.exists && value.hasChild(productData['product_id'])) {
        setState(() {
          productInCart = true;
        });
        showSnackBar(context, "Product already in our cart");
      }
    });

    Map<String, dynamic> addCartModel = {
      'product_id': productData['product_id'],
      'product_quantity': 1,
      'seller_id': productData['seller_id']
    };
    if (!productInCart) {
      await ref
          .child('${productData['product_id']}')
          .set(addCartModel)
          .whenComplete(() {
        showSnackBar(context, "Product successfully added in you cart");
      });
    }
  }
}

// product info widget
class ProductInfoWidget extends StatelessWidget {
  const ProductInfoWidget(this.productInfo);
  final productInfo;

  @override
  Widget build(BuildContext context) {
    Future<dynamic> sellerName = UserData.getSellerName(uid);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {},
            child: Text(
              productInfo['product_description'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 25),
            child: Row(
              children: [
                const Text(
                  "Sold by ",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                FutureBuilder(
                  future: sellerName,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        snapshot.data.toString(),
                        style: TextStyle(
                            color: linkColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      );
                    } else {
                      return Text(
                        "",
                        style: TextStyle(
                            color: linkColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 16
                            // fontWeight: FontWeight.w500,
                            ),
                      );
                    }
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

// product reviews
class ReviewTabViewWidget extends StatefulWidget {
  final productData;
  final Function reviewCallBack;
  ReviewTabViewWidget(this.productData, this.reviewCallBack);

  @override
  State<ReviewTabViewWidget> createState() => _ReviewTabViewWidgetState();
}

class _ReviewTabViewWidgetState extends State<ReviewTabViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: mainColor),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                          child: AddReviewWidget(
                              widget.productData, widget.reviewCallBack));
                    });
              },
              icon: const Icon(
                Icons.rate_review_rounded,
                color: Colors.white,
              ),
              label: Text(
                'Write Review',
                style: TextStyle(color: textColor),
              )),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            height: 500,
            child: ListView.builder(
                controller: _controller,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: ProductDetailedScreen.allReviews.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ReviewCardWidget(
                      ProductDetailedScreen.allReviews[index]);
                }),
          )
        ],
      ),
    );
  }
}
