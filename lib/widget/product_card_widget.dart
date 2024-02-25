import 'package:Kirana/constants/SystemColors.dart';
import 'package:Kirana/utils/screen_route_translation.dart';
import 'package:flutter/material.dart';
import 'package:Kirana/screens/home/product_detail_screen.dart';

class ProductCardWidget extends StatefulWidget {
  ProductCardWidget(this.productData);
  var productData;

  @override
  _ProductCardWidgetState createState() => _ProductCardWidgetState();
}

class _ProductCardWidgetState extends State<ProductCardWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            screenRouteTranslation(ProductDetailScreen(widget.productData)));
      },
      child: AnimatedContainer(
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 10),
          width: MediaQuery.of(context).size.width / 2.2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: mainColor.withOpacity(0.1),
          ),
          // padding: EdgeInsets.symmetric(horizontal: 5),
          duration: const Duration(seconds: 1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
                decoration: BoxDecoration(
                  // color: Color.fromARGB(48, 238, 238, 238),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.productData['product_image'],
                    filterQuality: FilterQuality.none,
                    fit: BoxFit.cover,
                    width: 150,
                    height: 120,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 4, left: 2),
                child: Text(
                  widget.productData['product_name'],
                  maxLines: 1,
                  style: const TextStyle(
                      fontSize: 16,
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
                          child: Text("${widget.productData['product_price']} ",
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              )),
                        ),
                        Text(
                          widget.productData['product_unit'],
                          maxLines: 1,
                          style: const TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          )),
    );
  }
}
