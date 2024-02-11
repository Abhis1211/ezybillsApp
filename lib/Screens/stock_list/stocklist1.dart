import 'dart:convert';
import '../../constant.dart';
import '../../currency.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../model/product_model.dart';
import '../../Provider/product_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:firebase_database/firebase_database.dart';

class StockList extends StatefulWidget {
  const StockList({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _StockListState createState() => _StockListState();
}

class _StockListState extends State<StockList> {
  int totalStock = 0;
  double totalSalePrice = 0;
  double totalParPrice = 0;

  @override
  void initState() {
    getAllTotal();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          lang.S.of(context).stockList,
          style: GoogleFonts.inter(
              color: Colors.black, fontSize: 22.0, fontWeight: FontWeight.w500),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Consumer(builder: (context, ref, __) {
        final providerData = ref.watch(productProvider);

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                border: TableBorder.all(
                  width: 0.5,
                  color: textPrimaryColor,
                  // dividerThickness: 5,
                ),
                horizontalMargin: 40.0,
                columnSpacing: 50.0,
                headingRowColor: MaterialStateColor.resolveWith(
                    (states) => kMainColor.withOpacity(0.2)),
                columns: <DataColumn>[
                  DataColumn(
                    label: Text(
                      'Category',
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Product',
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Purchase',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Sale',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'QTY',
                    ),
                  ),
                ],
                rows: providerData.when(data: (product) {
                  return product
                      .map((e) => DataRow(
                            cells: [
                              DataCell(
                                Center(
                                  child: Text(
                                    e.productCategory,
                                    style: GoogleFonts.inter(
                                      color: e.productStock.toInt() < 20
                                          ? Colors.red
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      e.productName,
                                      textAlign: TextAlign.start,
                                      style: GoogleFonts.inter(
                                        color: e.productStock.toInt() < 20
                                            ? Colors.red
                                            : Colors.black,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    Text(
                                      e.brandName,
                                      textAlign: TextAlign.start,
                                      style: GoogleFonts.inter(
                                        color: e.productStock.toInt() < 20
                                            ? Colors.red
                                            : kGreyTextColor,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: Text(
                                    '$currency${e.productPurchasePrice}',
                                    style: GoogleFonts.inter(
                                      color: e.productStock.toInt() < 20
                                          ? Colors.red
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: Text(
                                    '$currency${e.productSalePrice}',
                                    style: GoogleFonts.inter(
                                      color: e.productStock.toInt() < 20
                                          ? Colors.red
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: Text(
                                    e.productStock,
                                    style: GoogleFonts.inter(
                                      color: e.productStock.toInt() < 20
                                          ? Colors.red
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ))
                      .toList();
                  // return Column(
                  //   children: [
                  //     Row(
                  //       children: [
                  //         Expanded(
                  //           flex: 2,
                  //           child: Center(
                  //             child: Text(
                  //               e.productCategory,
                  //               style: GoogleFonts.inter(
                  //                 color: product[index]
                  //                             .productStock
                  //                             .toInt() <
                  //                         20
                  //                     ? Colors.red
                  //                     : Colors.black,
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //         Expanded(
                  //           flex: 2,
                  //           child: Column(
                  //             mainAxisAlignment:
                  //                 MainAxisAlignment.start,
                  //             crossAxisAlignment:
                  //                 CrossAxisAlignment.start,
                  //             children: [
                  //               Text(
                  //                 product[index].productName,
                  //                 textAlign: TextAlign.start,
                  //                 style: GoogleFonts.inter(
                  //                   color: product[index]
                  //                               .productStock
                  //                               .toInt() <
                  //                           20
                  //                       ? Colors.red
                  //                       : Colors.black,
                  //                   fontSize: 16.0,
                  //                 ),
                  //               ),
                  //               Text(
                  //                 product[index].brandName,
                  //                 textAlign: TextAlign.start,
                  //                 style: GoogleFonts.inter(
                  //                   color: product[index]
                  //                               .productStock
                  //                               .toInt() <
                  //                           20
                  //                       ? Colors.red
                  //                       : kGreyTextColor,
                  //                   fontSize: 12.0,
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //         Expanded(
                  //             flex: 2,
                  //             child: Center(
                  //               child: Text(
                  //                 '$currency${product[index].productPurchasePrice}',
                  //                 style: GoogleFonts.inter(
                  //                   color: product[index]
                  //                               .productStock
                  //                               .toInt() <
                  //                           20
                  //                       ? Colors.red
                  //                       : Colors.black,
                  //                 ),
                  //               ),
                  //             )),
                  //         Expanded(
                  //           child: Center(
                  //             child: Text(
                  //               '$currency${product[index].productSalePrice}',
                  //               style: GoogleFonts.inter(
                  //                 color: product[index]
                  //                             .productStock
                  //                             .toInt() <
                  //                         20
                  //                     ? Colors.red
                  //                     : Colors.black,
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //         Expanded(
                  //           flex: 2,
                  //           child: Center(
                  //             child: Text(
                  //               product[index].productStock,
                  //               style: GoogleFonts.inter(
                  //                 color: product[index]
                  //                             .productStock
                  //                             .toInt() <
                  //                         20
                  //                     ? Colors.red
                  //                     : Colors.black,
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //     Divider(
                  //       color: Colors.black,
                  //       thickness: 0.5,
                  //     )
                  //   ],
                  // );
                }, error: (e, stack) {
                  return [];
                  // return Text(e.toString());
                }, loading: () {
                  return [];
                  // return Center(child: CircularProgressIndicator());
                }),
              ).visible(true),
            ),
          ),
        );
      }),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20),
        color: kMainColor.withOpacity(0.2),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lang.S.of(context).total,
                textAlign: TextAlign.start,
                style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500),
              ).paddingSymmetric(horizontal: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Total stock',
                    style: GoogleFonts.inter(
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    totalStock.toString(),
                    style: GoogleFonts.inter(
                      color: Colors.black,
                    ),
                  ),
                ],
              ).paddingSymmetric(horizontal: 20),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Total purchase',
                    style: GoogleFonts.inter(
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '$currency${totalParPrice.toInt().toString()}',
                    style: GoogleFonts.inter(
                      color: Colors.black,
                    ),
                  ),
                ],
              ).paddingSymmetric(horizontal: 20),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Total sales',
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '$currency${totalSalePrice.toInt().toString()}',
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: Colors.black,
                    ),
                  ),
                ],
              ).paddingSymmetric(horizontal: 20),
            ],
          ),
        ),
      ),
    );
  }

  void getAllTotal() async {
    // ignore: unused_local_variable
    List<ProductModel> productList = [];
    await FirebaseDatabase.instance
        .ref(constUserId)
        .child('Products')
        .orderByKey()
        .get()
        .then((value) {
      for (var element in value.children) {
        var data = jsonDecode(jsonEncode(element.value));
        setState(() {
          totalStock = totalStock + int.parse(data['productStock']);
          totalSalePrice = totalSalePrice +
              (int.parse(data['productSalePrice']) *
                  int.parse(data['productStock']));
          totalParPrice = totalParPrice +
              (data['productPurchasePrice'] == null ||
                          data['productPurchasePrice'] == ""
                      ? int.parse("0")
                      : int.parse(data['productPurchasePrice'])) *
                  int.parse(data['productStock']);
        });

        print("salesprice" + totalSalePrice.toString());
        // productList.add(ProductModel.fromJson(jsonDecode(jsonEncode(element.value))));
      }
    });
  }
}
