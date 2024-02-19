import 'dart:convert';
import '../constant.dart';
import '../model/product_model.dart';
import 'package:firebase_database/firebase_database.dart';

class ProductRepo {
  Future<List<ProductModel>> getAllProduct() async {
    List<ProductModel> productList = [];
    final ref = FirebaseDatabase.instance.ref(constUserId).child('Products');

    await ref.orderByKey().get().then((value) {
      for (var element in value.children) {
        productList
            .add(ProductModel.fromJson(jsonDecode(jsonEncode(element.value)))); 
      }
    });

    ref.keepSynced(true);

    return productList;
  }
}
