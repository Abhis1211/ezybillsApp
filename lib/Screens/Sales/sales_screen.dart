import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Provider/product_provider.dart';
import 'package:mobile_pos/Screens/Customers/Model/customer_model.dart';
import 'package:mobile_pos/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/add_to_cart.dart';
import '../../Provider/category,brans,units_provide.dart';
import '../../currency.dart';
import '../../model/add_to_cart_model.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

// ignore: must_be_immutable
class SaleProducts extends StatefulWidget {
  SaleProducts({Key? key, @required this.catName, this.customerModel})
      : super(key: key);

  // ignore: prefer_typing_uninitialized_variables
  var catName;
  CustomerModel? customerModel;

  @override
  // ignore: library_private_types_in_public_api
  _SaleProductsState createState() => _SaleProductsState();
}

class _SaleProductsState extends State<SaleProducts> {
  String dropdownValue = '';
  String productCode = '0000';

  var salesCart = FlutterCart();
  String productPrice = '0';
  String sentProductPrice = '';
  String currentproductcategory = '';
  int currentselectioncategory = -1;

  @override
  void initState() {
    widget.catName == null
        ? dropdownValue = 'Fashion'
        : dropdownValue = widget.catName;
    super.initState();
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      productCode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      final providerData = ref.watch(cartNotifier);
      final productList = ref.watch(productProvider);
      final categoryList = ref.watch(categoryProvider);

      return Scaffold(
        appBar: AppBar(
          title: Text(
            lang.S.of(context).addItems,
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 20.0,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
          // actions: [
          //   PopupMenuButton(
          //     itemBuilder: (BuildContext bc) => [
          //       const PopupMenuItem(value: "/addPromoCode", child: Text('Add Promo Code')),
          //       const PopupMenuItem(value: "clear", child: Text('Cancel All Product')),
          //       const PopupMenuItem(value: "/settings", child: Text('Vat Doesn\'t Apply')),
          //     ],
          //     onSelected: (value) {
          //       value == 'clear'
          //           ? {
          //               providerData.clearCart(),
          //               providerData.clearDiscount(),
          //               const HomeScreen().launch(context, isNewTask: true)
          //             }
          //           : Navigator.pushNamed(context, '$value');
          //     },
          //   ),
          // ],
        ),
        body: Column(
          children: [
            // Container(
            //   height: 60.0,
            //   width: MediaQuery.of(context).size.width,
            //   decoration: BoxDecoration(
            //     color: kMainColor,
            //     borderRadius: BorderRadius.circular(10.0),
            //   ),
            //   child: GestureDetector(
            //     onTap: () {
            //       // ignore: missing_required_param
            //       providerData.getTotalAmount() <= 0
            //           ? EasyLoading.showError('Cart Is Empty')
            //           : SalesDetails(
            //               customerName: widget.customerModel!.customerName,
            //             ).launch(context);
            //     },
            //     child: Row(
            //       children: [
            //         Expanded(
            //           flex: 1,
            //           child: Stack(
            //             alignment: Alignment.center,
            //             children: [
            //               const Image(
            //                 image: AssetImage('images/selected.png'),
            //               ),
            //               Text(
            //                 items.toString(),
            //                 style: GoogleFonts.poppins(
            //                   fontSize: 15.0,
            //                   color: Colors.white,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //         Expanded(
            //           flex: 2,
            //           child: Center(
            //             child: Text(
            //               providerData.getTotalAmount() <= 0
            //                   ? 'Cart is empty'
            //                   : 'Total: $currency${providerData.getTotalAmount().toString()}',
            //               style: GoogleFonts.poppins(
            //                 color: Colors.white,
            //                 fontSize: 16.0,
            //               ),
            //             ),
            //           ),
            //         ),
            //         const Expanded(
            //           flex: 1,
            //           child: Icon(
            //             Icons.arrow_forward,
            //             color: Colors.white,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            // const SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: AppTextField(
                      textFieldType: TextFieldType.NAME,
                      onChanged: (value) {
                        setState(() {
                          productCode = value;
                        });
                      },
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: lang.S.of(context).productCode,
                        hintText: productCode == '0000' || productCode == '-1'
                            ? 'Scan product QR code'
                            : productCode,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: () => scanBarcodeNormal(),
                      child: Container(
                        height: 60.0,
                        width: 100.0,
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: kGreyTextColor),
                        ),
                        child: const Image(
                          image: AssetImage('images/barcode.png'),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 90,
                    height: MediaQuery.of(context).size.height * 1.0,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 193, 192, 192),
                        borderRadius:
                            BorderRadius.only(topRight: Radius.circular(20))),
                    padding: EdgeInsets.only(right: 2, left: 2, top: 5),
                    child: Column(
                      children: [
                        Expanded(
                          child: categoryList.when(data: (category) {
                            return ListView.builder(
                                // shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount: category.length,
                                itemBuilder: (_, i) {
                                  return GestureDetector(
                                    onTap: (() {
                                      setState(() {
                                        currentproductcategory =
                                            category[i].categoryName;
                                        currentselectioncategory = i;
                                      });
                                    }),
                                    child: Container(
                                      // padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                      child: Card(
                                        color: currentselectioncategory == i
                                            ? kMainColor
                                            : Colors.white,
                                        // height: 50,
                                        // alignment: Alignment.center,
                                        child: Center(
                                            child: Text(
                                          category[i].categoryName.toString(),
                                          style: GoogleFonts.jost(
                                            fontSize: 16.0,
                                            color: Colors.black,
                                          ),
                                        ).paddingSymmetric(
                                                vertical: 15, horizontal: 2)),
                                      ).paddingOnly(bottom: 10),
                                    ),
                                  );
                                });
                          }, error: (e, stack) {
                            return Text(e.toString());
                          }, loading: () {
                            return const Center(
                                child: CircularProgressIndicator());
                          }),
                        ),
                        GestureDetector(
                          onTap: (() {
                            setState(() {
                              currentproductcategory = "";
                              currentselectioncategory = -1;
                            });
                          }),
                          child: Container(
                            // padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                            child: Card(
                              color: Colors.red,
                              // height: 50,
                              // alignment: Alignment.center,
                              child: Center(
                                  child: Text(
                                "Reset",
                                style: GoogleFonts.jost(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                              ).paddingSymmetric(horizontal: 2, vertical: 10)),
                            ).paddingOnly(bottom: 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: productList.when(data: (products) {
                      var filterlist = products
                          .where((element) =>
                              element.productCategory == currentproductcategory)
                          .toList();
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, // number of items in each row
                            mainAxisSpacing: 10.0, // spacing between rows
                            crossAxisSpacing: 10.0,
                            childAspectRatio: 0.4 // spacing between columns
                            ),
                        // shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: currentproductcategory == ""
                            ? products.length
                            : filterlist.length,
                        itemBuilder: (_, i) {
                          if (widget.customerModel!.type.contains('Retailer')) {
                            productPrice = currentproductcategory == ""
                                ? products[i].productSalePrice
                                : filterlist[i].productSalePrice;
                          } else if (widget.customerModel!.type
                              .contains('Dealer')) {
                            productPrice = currentproductcategory == ""
                                ? products[i].productDealerPrice
                                : filterlist[i].productDealerPrice;
                          } else if (widget.customerModel!.type
                              .contains('Wholesaler')) {
                            productPrice = currentproductcategory == ""
                                ? products[i].productWholeSalePrice
                                : filterlist[i].productWholeSalePrice;
                          } else if (widget.customerModel!.type
                              .contains('Supplier')) {
                            productPrice = currentproductcategory == ""
                                ? products[i].productPurchasePrice
                                : filterlist[i].productPurchasePrice;
                          } else if (widget.customerModel!.type
                              .contains('Guest')) {
                            productPrice = currentproductcategory == ""
                                ? products[i].productSalePrice
                                : filterlist[i].productSalePrice;
                          }
                          return GestureDetector(
                            onTap: () async {
                              if (products[i].productStock.toInt() <= 0) {
                                EasyLoading.showError('Out of stock');
                              } else {
                                if (widget.customerModel!.type
                                    .contains('Retailer')) {
                                  sentProductPrice =
                                      currentproductcategory == ""
                                          ? products[i].productSalePrice
                                          : filterlist[i].productSalePrice;
                                } else if (widget.customerModel!.type
                                    .contains('Dealer')) {
                                  sentProductPrice =
                                      currentproductcategory == ""
                                          ? products[i].productDealerPrice
                                          : filterlist[i].productDealerPrice;
                                } else if (widget.customerModel!.type
                                    .contains('Wholesaler')) {
                                  sentProductPrice =
                                      currentproductcategory == ""
                                          ? products[i].productWholeSalePrice
                                          : filterlist[i].productWholeSalePrice;
                                } else if (widget.customerModel!.type
                                    .contains('Supplier')) {
                                  sentProductPrice =
                                      currentproductcategory == ""
                                          ? products[i].productPurchasePrice
                                          : filterlist[i].productPurchasePrice;
                                } else if (widget.customerModel!.type
                                    .contains('Guest')) {
                                  sentProductPrice =
                                      currentproductcategory == ""
                                          ? products[i].productSalePrice
                                          : filterlist[i].productSalePrice;
                                }

                                AddToCartModel cartItem = AddToCartModel(
                                  productName: currentproductcategory == ""
                                      ? products[i].productName
                                      : filterlist[i].productName,
                                  subTotal: sentProductPrice,
                                  productId: currentproductcategory == ""
                                      ? products[i].productCode
                                      : filterlist[i].productCode,
                                  productBrandName: currentproductcategory == ""
                                      ? products[i].brandName
                                      : filterlist[i].brandName,
                                  productPurchasePrice:
                                      currentproductcategory == ""
                                          ? products[i].productPurchasePrice
                                          : filterlist[i].productPurchasePrice,
                                  stock: int.parse(products[i].productStock),
                                  uuid: currentproductcategory == ""
                                      ? products[i].productCode
                                      : filterlist[i].productCode,
                                );
                                providerData.addToCartRiverPod(cartItem);
                                providerData.addProductsInSales(
                                    currentproductcategory == ""
                                        ? products[i]
                                        : filterlist[i],
                                    context);
                                // Navigator.pop(context);
                              }
                            },
                            child: ProductCard(
                              productTitle: currentproductcategory == ""
                                  ? products[i].productName
                                  : filterlist[i].productName,
                              productDescription: currentproductcategory == ""
                                  ? products[i].brandName
                                  : filterlist[i].brandName,
                              productPrice: productPrice,
                              productImage: currentproductcategory == ""
                                  ? products[i].productPicture
                                  : filterlist[i].productPicture,
                            ).visible(((currentproductcategory == ""
                                            ? products[i].productCode
                                            : filterlist[i].productCode) ==
                                        productCode ||
                                    productCode == '0000' ||
                                    productCode == '-1') &&
                                productPrice != '0'),
                          );
                        },
                      );
                    }, error: (e, stack) {
                      return Text(e.toString());
                    }, loading: () {
                      return const Center(child: CircularProgressIndicator());
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        //   child: Text(
        //     "Add".toString(),
        //     style: GoogleFonts.jost(
        //       fontSize: 14.0,
        //       color: Colors.black,
        //     ),
        //   ).paddingSymmetric(horizontal: 2, vertical: 10),
        // ),
        // bottomNavigationBar: ButtonGlobal(
        //   iconWidget: Icons.arrow_forward,
        //   buttontext: 'Sales List',
        //   iconColor: Colors.white,
        //   buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
        //   onPressed: () {
        //     // ignore: missing_required_param
        //     providerData.getTotalAmount() <= 0
        //         ? EasyLoading.showError('Cart Is Empty')
        //         : SalesDetails(
        //             customerName: widget.customerModel!.customerName,
        //           ).launch(context);
        //   },
        // ),
      );
    });
  }
}

// ignore: must_be_immutable
class ProductCard extends StatefulWidget {
  ProductCard(
      {Key? key,
      required this.productTitle,
      required this.productDescription,
      required this.productPrice,
      required this.productImage})
      : super(key: key);

  // final Product product;
  String productImage, productTitle, productDescription, productPrice;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      final providerData = ref.watch(cartNotifier);
      for (var element in providerData.cartItemList) {
        if (element.productName == widget.productTitle) {
          quantity = element.quantity;
        }
      }
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(widget.productImage),
                      fit: BoxFit.cover),
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  widget.productTitle,
                  style: GoogleFonts.jost(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                ),
                // const SizedBox(width: 5),
                // Text(
                //   ' X $quantity',
                //   style: GoogleFonts.jost(
                //     fontSize: 14.0,
                //     color: Colors.grey.shade500,
                //   ),
                // ).visible(quantity != 0),
              ],
            ),
            Text(
              widget.productDescription,
              style: GoogleFonts.jost(
                fontSize: 15.0,
                color: kGreyTextColor,
              ),
            ),
            Text('$currency${widget.productPrice}',
                style: GoogleFonts.jost(
                  fontSize: 20.0,
                  color: Colors.black,
                )),
            // Padding(
            //   padding: const EdgeInsets.only(left: 10.0),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       Row(
            //         children: [
            //           Text(
            //             widget.productTitle,
            //             style: GoogleFonts.jost(
            //               fontSize: 20.0,
            //               color: Colors.black,
            //             ),
            //           ),
            //           // const SizedBox(width: 5),
            //           // Text(
            //           //   ' X $quantity',
            //           //   style: GoogleFonts.jost(
            //           //     fontSize: 14.0,
            //           //     color: Colors.grey.shade500,
            //           //   ),
            //           // ).visible(quantity != 0),
            //         ],
            //       ),
            //       Text(
            //         widget.productDescription,
            //         style: GoogleFonts.jost(
            //           fontSize: 15.0,
            //           color: kGreyTextColor,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // const Spacer(),
            // Text(
            //   '$currency${widget.productPrice}',
            //   style: GoogleFonts.jost(
            //     fontSize: 20.0,
            //     color: Colors.black,
            //   ),
            // ),
          ],
        ),
      );
    });
  }
}
