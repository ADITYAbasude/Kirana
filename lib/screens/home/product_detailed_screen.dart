import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:grocery_app/constants/ConstantValue.dart';
import 'package:grocery_app/constants/SystemColors.dart';
import 'package:grocery_app/widget/add_review_widget.dart';

class ProductDetailedScreen extends StatefulWidget {
  ProductDetailedScreen(this.productData);
  final productData;

  @override
  _ProductDetailedScreenState createState() => _ProductDetailedScreenState();
}

class _ProductDetailedScreenState extends State<ProductDetailedScreen>
    with SingleTickerProviderStateMixin {
  //tab controller
  TabController? _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
      ),
      body: ListView(children: [
        Image.network(
          widget.productData['product_image'],
          width: getScreenSize(context).width,
          height: getScreenSize(context).height / 2.8,
          fit: BoxFit.cover,
        ),
        Container(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.productData['product_name'],
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      Row(children: [
                        const Icon(
                          Icons.currency_rupee_rounded,
                          size: 20,
                        ),
                        Text(
                          widget.productData['product_price'],
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        )
                      ])
                    ],
                  ),

                  // check that product is on a stock or not
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          "In Stock",
                          style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                      ),

                      // add your favorite product
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {},
                          child: const Icon(
                            Icons.favorite_border_rounded,
                            color: Color.fromARGB(174, 0, 0, 0),
                          ),
                        ),
                      ),
                    ],
                  )
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
                      rating: 2.5,
                      itemSize: 20,
                      itemBuilder: (context, index) => Icon(
                            Icons.star_rounded,
                            color: Colors.yellow[800],
                          )),
                  Text(
                    " (68 reviews)",
                    style: TextStyle(color: Colors.black.withOpacity(0.5)),
                  ),
                ],
              ),
            ),

            //Tab
            Container(
              height: 40,
              margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20)),
              child: TabBar(
                  controller: _tabController,
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
            // TabBarView
            Container(
              height: 500,
              child: TabBarView(controller: _tabController, children: [
                ProductInfoWidget(widget.productData),
                ReviewTabViewWidget(widget.productData)
              ]),
            ),
          ]),
        )
      ]),
    );
  }
}

// product info widget
class ProductInfoWidget extends StatelessWidget {
  const ProductInfoWidget(this.productInfo);
  final productInfo;

  @override
  Widget build(BuildContext context) {
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
                Text(
                  "Ambika General Store",
                  style: TextStyle(
                      color: linkColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
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
  ReviewTabViewWidget(this.productData);
  final productData;

  @override
  State<ReviewTabViewWidget> createState() => _ReviewTabViewWidgetState();
}

class _ReviewTabViewWidgetState extends State<ReviewTabViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: ListView(
        physics: ScrollPhysics(),
        children: [
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: mainColor),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(child: AddReviewWidget(widget.productData));
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
        ],
      ),
    );
  }
}
