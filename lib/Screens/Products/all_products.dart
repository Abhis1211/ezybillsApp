import 'package:flutter/material.dart';
import 'package:mobile_pos/constant.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:mobile_pos/GlobalComponents/button_global.dart';

class AllProducts extends StatefulWidget {
  const AllProducts({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AllProductsState createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          lang.S.of(context).productList,
          style: GoogleFonts.inter(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ButtonGlobal(
            iconWidget: Icons.arrow_forward,
            buttontext: lang.S.of(context).addNewProduct,
            iconColor: Colors.white,
            buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
            onPressed: () {
              Navigator.pushNamed(context, '/addProducts');
            },
          ),
        ],
      ),
    );
  }
}
