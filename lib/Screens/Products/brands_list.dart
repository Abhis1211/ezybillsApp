import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mobile_pos/constant.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../GlobalComponents/button_global.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:firebase_database/firebase_database.dart';
import 'package:mobile_pos/Screens/Products/add_brans.dart';
import 'package:mobile_pos/Provider/category,brans,units_provide.dart';

// ignore: must_be_immutable
class BrandsList extends StatefulWidget {
  const BrandsList({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BrandsListState createState() => _BrandsListState();
}

class _BrandsListState extends State<BrandsList> {
  String search = '';
  void deleteBrand({required WidgetRef wRef, key}) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          lang.S.of(context).brands,
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
          padding: const EdgeInsets.all(10.0),
          child: Consumer(builder: (context, ref, __) {
            final brandData = ref.watch(brandsProvider);
            // ref.refresh(brandsProvider);
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: AppTextField(
                        textFieldType: TextFieldType.NAME,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: lang.S.of(context).search,
                          prefixIcon: Icon(
                            Icons.search,
                            color: kGreyTextColor.withOpacity(0.5),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            search = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          AddBrands().launch(context);
                        },
                        child: Container(
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          height: 60.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(color: kGreyTextColor),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: kGreyTextColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                  ],
                ),
                brandData.when(data: (data) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, i) {
                        return data[i].brandName.contains(search)
                            ? GestureDetector(
                                onTap: () {
                                  AddBrands(brandmodel: data[i])
                                      .launch(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0,
                                      right: 10.0,
                                      bottom: 10,
                                      top: 10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data[i].brandName,
                                              style: GoogleFonts.inter(
                                                fontSize: 18.0,
                                                color: Colors.black,
                                              ),
                                            ),
                                            // SizedBox(
                                            //   height: 20,
                                            //   width: context.width(),
                                            //   child: ListView.builder(
                                            //       shrinkWrap: true,
                                            //       physics: const NeverScrollableScrollPhysics(),
                                            //       scrollDirection: Axis.horizontal,
                                            //       itemCount: data[i]..length,
                                            //       itemBuilder: (context, index) {
                                            //         return Text(
                                            //           '${variations[index]}, ',
                                            //           style: GoogleFonts.inter(
                                            //             fontSize: 14.0,
                                            //             color: Colors.grey,
                                            //           ),
                                            //         );
                                            //       }),
                                            // ),
                                          ],
                                        ),
                                      ),
                                      TextIcon(
                                        text: 'Select',
                                        // buttonDecoration: kButtonDecoration
                                        //     .copyWith(color: kDarkWhite),
                                        onTap: () {
                                          Navigator.pop(
                                              context, data[i].brandName);
                                        },
                                        // buttonTextColor: Colors.black,
                                      ),
                                      SizedBox(width: 5),
                                      GestureDetector(
                                          onTap: () {
                                            
                                          },
                                          child: Icon(Icons.edit)),
                                      SizedBox(width: 10),
                                      GestureDetector(
                                          onTap: () {
                                            List brandList = [];
                                            var brandkey = "";
                                            final sref = FirebaseDatabase
                                                .instance
                                                .ref(constUserId)
                                                .child('Brands');
                                            sref.keepSynced(true);
                                            sref
                                                .orderByKey()
                                                .get()
                                                .then((value) {
                                              for (var element
                                                  in value.children) {
                                                var sdata = jsonDecode(
                                                    jsonEncode(element.value));
                                                if (sdata['brandName']
                                                        .toString() ==
                                                    data[i]
                                                        .brandName
                                                        .toString()) {
                                                  brandkey =
                                                      element.key.toString();
                                                }
                                              }
                                            });
                                            DatabaseReference wref =
                                                FirebaseDatabase.instance.ref(
                                                    "$constUserId/Brands/$brandkey");
                                            wref.keepSynced(true);
                                            wref.remove();
                                            ref.refresh(brandsProvider);
                                          },
                                          child: Icon(Icons.delete)),
                                    ],
                                  ),
                                ),
                              )
                            : Container();
                      });
                }, error: (_, __) {
                  return Container();
                }, loading: () {
                  return const CircularProgressIndicator();
                }),
              ],
            );
          }),
        ),
      ),
    );
  }
}
