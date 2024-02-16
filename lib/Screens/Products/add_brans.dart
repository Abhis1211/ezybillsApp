import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mobile_pos/constant.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Screens/Products/Model/brands_model.dart';
import 'package:mobile_pos/Provider/category,brans,units_provide.dart';

// ignore_for_file: unused_result

class AddBrands extends StatefulWidget {
  final type;
  AddBrands({Key? key, this.brandmodel, this.type = 0}) : super(key: key);
  BrandsModel? brandmodel;
  @override
  // ignore: library_private_types_in_public_api
  _AddBrandsState createState() => _AddBrandsState();
}

class _AddBrandsState extends State<AddBrands> {
  bool showProgress = false;
  String brandName = "";
  @override
  void initState() {
    if (widget.brandmodel != null) {
      brandName = widget.brandmodel!.brandName;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      final allBrands = ref.watch(brandsProvider);
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Image(
                image: AssetImage('images/x.png'),
              )),
          title: Text(
            lang.S.of(context).addBrand,
            style: GoogleFonts.inter(
              color: Colors.black,
              fontSize: 20.0,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Visibility(
                  visible: showProgress,
                  child: const CircularProgressIndicator(
                    color: kMainColor,
                    strokeWidth: 5.0,
                  ),
                ),
                AppTextField(
                  textFieldType: TextFieldType.NAME,
                  initialValue: widget.brandmodel != null
                      ? widget.brandmodel!.brandName
                      : null,
                  onChanged: (value) {
                    setState(() {
                      brandName = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Apple',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: lang.S.of(context).brandName,
                  ),
                ),
                ButtonGlobalWithoutIcon(
                  buttontext: lang.S.of(context).save,
                  buttonDecoration:
                      kButtonDecoration.copyWith(color: kMainColor),
                  onPressed: () async {
                    if (brandName.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please enter brand")));
                      return;
                    }
                    bool isAlreadyAdded = false;
                    allBrands.value?.forEach((element) {
                      if (element.brandName
                              .toLowerCase()
                              .removeAllWhiteSpace() ==
                          brandName.toLowerCase().removeAllWhiteSpace()) {
                        isAlreadyAdded = true;
                      }
                    });
                    setState(() {
                      showProgress = true;
                    });
                    final DatabaseReference categoryInformationRef =
                        FirebaseDatabase.instance
                            .ref()
                            .child(constUserId)
                            .child('Brands');
                    categoryInformationRef.keepSynced(true);
                    BrandsModel brandModel = BrandsModel(brandName);
                    isAlreadyAdded
                        ? EasyLoading.showError('Already Added')
                        : widget.type == 1
                            ? await updatebrand()
                            : categoryInformationRef
                                .push()
                                .set(brandModel.toJson());
                    setState(() {
                      showProgress = false;
                      isAlreadyAdded
                          ? null
                          : ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Data Saved Successfully")));
                    });
                    await ref.refresh(brandsProvider);

                    // ignore: use_build_context_synchronously
                    isAlreadyAdded ? null : Navigator.pop(context, true);
                  },
                  buttonTextColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  updatebrand() async {
    var brandkey = "";
    final sref = FirebaseDatabase.instance.ref(constUserId).child('Brands');

    await sref.get().then((value) {
      for (var element in value.children) {
        var sdata = jsonDecode(jsonEncode(element.value));
        if (sdata['brandName'].toString() ==
            widget.brandmodel!.brandName.toString()) {
          print("cd" + element.key.toString());
          setState(() {
            brandkey = element.key.toString();
          });
        }
      }
    });
    print("sadsd" + brandkey.toString());
    final DatabaseReference shopCategoryRef = FirebaseDatabase.instance
        .ref()
        .child(constUserId)
        .child('Brands')
        .child(brandkey.toString());
    // .child('Admin Panel')
    // .child('Category');
    await shopCategoryRef.update({
      "brandName": brandName,
    });
  }
}
