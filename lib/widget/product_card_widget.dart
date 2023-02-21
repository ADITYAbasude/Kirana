import 'package:flutter/material.dart';
import 'package:grocery_app/screens/home/product_detailed_screen.dart';

class ProductCardWidget extends StatefulWidget {
  ProductCardWidget(this.productData);
  var productData;

  @override
  _ProductCardWidgetState createState() => _ProductCardWidgetState();
}

class _ProductCardWidgetState extends State<ProductCardWidget> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        width: MediaQuery.of(context).size.width / 2.2,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                  blurRadius: 10,
                  spreadRadius: 0,
                  color: Color.fromARGB(78, 0, 0, 0),
                  offset: Offset(0, 0))
            ]),
        // padding: EdgeInsets.symmetric(horizontal: 5),
        duration: const Duration(seconds: 1),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: InkWell(
            onTap: () {
              Navigator.push(
                  context, _productRouteTranslation(widget.productData));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
                  decoration: BoxDecoration(
                    // color: Color.fromARGB(48, 238, 238, 238),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      widget.productData['product_image'],
                      fit: BoxFit.cover,
                      width: 150,
                      height: 120,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10, left: 5),
                  child: Text(
                    widget.productData['product_name'],
                    maxLines: 1,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: Row(
                        children: [
                          const Icon(Icons.currency_rupee_rounded),
                          Container(
                            child: Text(
                                widget.productData['product_price'] + " ",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600)),
                          ),
                          Text(
                            widget.productData['product_unit'],
                            style: const TextStyle(fontSize: 12),
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          // floatingActionButton: FloatingActionButton.small(
          //   heroTag: "btn1",
          //   onPressed: () {},
          //   child: Icon(Icons.add_rounded),
          // ),
          // floatingActionButtonLocation:
          //     FloatingActionButtonLocation.miniEndFloat,
        ));
  }

  Route _productRouteTranslation(var productData) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ProductDetailedScreen(productData),
        transitionsBuilder: ((context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset(0.0, 0.0);
          const curve = Curves.fastOutSlowIn;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        }));
  }
}
