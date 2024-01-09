import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Provider/product_provider.dart';
import 'package:mobile_pos/Screens/Products/update_product.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../GlobalComponents/button_global.dart';
import '../../constant.dart';
import '../../currency.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, __) {
        final providerData = ref.watch(productProvider);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            title: Text(
              lang.S.of(context).productList,
              style: GoogleFonts.poppins(
                color: Colors.black,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: providerData.when(data: (products) {
              return products.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      itemBuilder: (_, i) {
                        return ListTile(
                          onTap: () {
                            UpdateProduct(productModel: products[i]).launch(context);
                          },
                          leading: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(90)),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    products[i].productPicture,
                                  ),
                                  fit: BoxFit.cover,
                                )),
                            // child: CachedNetworkImage(
                            //   imageUrl: products[i].productPicture,
                            //   placeholder: (context, url) => const SizedBox(height: 50, width: 50, ),
                            //   errorWidget: (context, url, error) => const Icon(Icons.error),
                            //   fit: BoxFit.cover,
                            // ),
                          ),
                          title: Text(products[i].productName),
                          subtitle: Text("${lang.S.of(context).stock} : ${products[i].productStock}"),
                          trailing: Text(
                            "$currency ${products[i].productSalePrice}",
                            style: const TextStyle(fontSize: 18),
                          ),
                        );
                      })
                  : Center(
                      child: Text(
                        lang.S.of(context).addProduct,
                        maxLines: 2,
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                    );
            }, error: (e, stack) {
              return Text(e.toString());
            }, loading: () {
              return const Center(child: CircularProgressIndicator());
            }),
          ),
          bottomNavigationBar: ButtonGlobal(
            iconWidget: Icons.add,
            buttontext: lang.S.of(context).addNewProduct,
            iconColor: Colors.white,
            buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
            onPressed: () {
              Navigator.pushNamed(context, '/AddProducts');
            },
          ),
        );
      },
    );
  }
}
