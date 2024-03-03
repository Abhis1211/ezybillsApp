import 'package:flutter/material.dart';
import '../model/add_to_cart_model.dart';
import 'package:mobile_pos/model/product_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

final cartNotifier = ChangeNotifierProvider((ref) => CartNotifier());

class CartNotifier extends ChangeNotifier {
  List<AddToCartModel> cartItemList = [];
  double discount = 0;
  String discountType = 'USD';
  var totalgst = 0.0;
  final List<ProductModel> productList = [];

  void addProductsInSales(ProductModel products, [cntx]) {
    productList.add(products);
    if (cntx != null)
      EasyLoading.showSuccess('Add product to cart',
          duration: Duration(milliseconds: 100));
    // ScaffoldMessenger.of(cntx).showSnackBar(
    //   const SnackBar(
    //     content: Text('Add product to cart'),
    //     duration: Duration(milliseconds: 500),
    //   ),
    // );
    notifyListeners();
  }

  void removeProductsInSales(ProductModel products) {
    productList.remove(products);
    notifyListeners();
  }

  double getTotalAmount() {
    double totalAmountOfCart = 0;
    for (var element in cartItemList) {
      totalAmountOfCart = totalAmountOfCart +
          (double.parse(element.subTotal.toString()) *
              double.parse(element.quantity.toString()));
    }

    if (discount >= 0) {
      if (discountType == 'USD') {
        return totalAmountOfCart - discount;
      } else {
        return totalAmountOfCart - ((totalAmountOfCart * discount) / 100);
      }
    }
    return totalAmountOfCart;
  }

  totalamount() {
    return (totalgst / 100) * getTotalAmount().toDouble();
  }

  double calculateSubtotal({required double discountAmount}) {
    return getTotalAmount() + totalamount() - discountAmount;
  }

  quantityIncrease(int index) {
    if (cartItemList[index].stock! > cartItemList[index].quantity) {
      cartItemList[index].quantity++;
      notifyListeners();
    } else {
      EasyLoading.showError('Stock Overflow');
    }
  }

  quantityDecrease(int index) {
    if (cartItemList[index].quantity > 1) {
      cartItemList[index].quantity--;
    }
    notifyListeners();
  }

  addToCartRiverPod(AddToCartModel cartItem) {
    bool isNotInList = true;
    for (var element in cartItemList) {
      if (element.productId == cartItem.productId) {
        element.quantity++;
        isNotInList = false;
        return;
      } else {
        isNotInList = true;
      }
    }
    if (isNotInList) {
      cartItemList.add(cartItem);
    }
    totalgst = totalgst + double.parse(cartItem.productgst.toString());
    print(totalgst);
    notifyListeners();
  }

  addToCartRiverPodForEdit(List<AddToCartModel> cartItem) {
    cartItemList = cartItem;
  }

  deleteToCart(int index, gst) {
    totalgst = totalgst - double.parse(gst.toString());
    cartItemList.removeAt(index);
    notifyListeners();
  }

  clearCart() {
    cartItemList.clear();
    clearDiscount();
    notifyListeners();
  }

  addDiscount(String type, double dis) {
    discount = dis;
    discountType = type;
    notifyListeners();
  }

  clearDiscount() {
    discount = 0;
    discountType = 'USD';
    notifyListeners();
  }
}
