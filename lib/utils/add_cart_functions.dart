// add product in your cart
import 'package:firebase_database/firebase_database.dart';
import 'package:grocery_app/utils/get_info.dart';

import '../tools/SnackBar.dart';

void addToCart(var productData, context, Function productInCartCallback) async {
  bool productInCart = false;
  DatabaseReference ref = FirebaseDatabase.instance.ref('users/${uid}/cart');
  await ref.get().then((value) {
    if (value.exists && value.hasChild(productData['product_id'])) {
      productInCartCallback(true);
      productInCart = true;
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
