import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mobile_pos/constant.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:mobile_pos/GlobalComponents/Model/category_model.dart';
import 'package:mobile_pos/Provider/category,brans,units_provide.dart';
// ignore_for_file: unused_result

class AddCategory extends StatefulWidget {
  final CategoryModel? model;
  final type;
  const AddCategory({Key? key, this.model, this.type = 0}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  bool showProgress = false;
  String categoryName = "";
  bool sizeCheckbox = false;
  bool colorCheckbox = false;
  bool weightCheckbox = false;
  bool capacityCheckbox = false;
  bool typeCheckbox = false;
  File imageFile = File('No File');
  final ImagePicker _picker = ImagePicker();
  XFile? pickedImage;
  String imagePath = 'No Data';
  String productPicture =
      'https://firebasestorage.googleapis.com/v0/b/maanpos.appspot.com/o/Customer%20Picture%2FNo_Image_Available.jpeg?alt=media&token=3de0d45e-0e4a-4a7b-b115-9d6722d5031f';

  Future<void> uploadFile(String filePath) async {
    File file = File(filePath);
    try {
      EasyLoading.show(
        status: 'Uploading... ',
        dismissOnTap: false,
      );
      var snapshot = await FirebaseStorage.instance
          .ref('Category Picture/${DateTime.now().millisecondsSinceEpoch}')
          .putFile(file);
      var url = await snapshot.ref.getDownloadURL();

      setState(() {
        productPicture = url.toString();
      });
      EasyLoading.dismiss();
    } on firebase_core.FirebaseException catch (e) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.code.toString())));
    }
  }

  @override
  void initState() {
    if (widget.model != null) {
      setState(() {
        categoryName = widget.model!.categoryName;
        productPicture = widget.model!.categoryimage;
        sizeCheckbox = widget.model!.size;
        colorCheckbox = widget.model!.color;
        typeCheckbox = widget.model!.type;
        capacityCheckbox = widget.model!.capacity;
        weightCheckbox = widget.model!.weight;
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      final allCategory = ref.watch(categoryProvider);
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
            'Add Category',
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
              mainAxisSize: MainAxisSize.min,
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
                  initialValue:
                      widget.model != null ? widget.model!.categoryName : null,
                  onChanged: (value) {
                    setState(() {
                      categoryName = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Fashion',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Category name',
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Select variations : '),
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text("Size"),
                        value: sizeCheckbox,
                        checkboxShape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        onChanged: (newValue) {
                          setState(() {
                            sizeCheckbox = newValue!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity
                            .leading, //  <-- leading Checkbox
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text("Color"),
                        value: colorCheckbox,
                        checkboxShape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        onChanged: (newValue) {
                          setState(() {
                            colorCheckbox = newValue!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity
                            .leading, //  <-- leading Checkbox
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text("Weight"),
                        checkboxShape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        value: weightCheckbox,
                        onChanged: (newValue) {
                          setState(() {
                            weightCheckbox = newValue!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity
                            .leading, //  <-- leading Checkbox
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text("Capacity"),
                        checkboxShape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        value: capacityCheckbox,
                        onChanged: (newValue) {
                          setState(() {
                            capacityCheckbox = newValue!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity
                            .leading, //  <-- leading Checkbox
                      ),
                    ),
                  ],
                ),
                CheckboxListTile(
                  title: const Text("Type"),
                  checkboxShape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  value: typeCheckbox,
                  onChanged: (newValue) {
                    setState(() {
                      typeCheckbox = newValue!;
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.leading, //  <-- leading Checkbox
                ),
                Column(
                  children: [
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                // ignore: sized_box_for_whitespace
                                child: Container(
                                  height: 200.0,
                                  width: MediaQuery.of(context).size.width - 80,
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            pickedImage =
                                                await _picker.pickImage(
                                                    source:
                                                        ImageSource.gallery);

                                            setState(() {
                                              imageFile =
                                                  File(pickedImage!.path);
                                              imagePath = pickedImage!.path;
                                            });

                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 100), () {
                                              Navigator.pop(context);
                                            });
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.photo_library_rounded,
                                                size: 60.0,
                                                color: kMainColor,
                                              ),
                                              Text(
                                                lang.S.of(context).gallery,
                                                style: GoogleFonts.inter(
                                                  fontSize: 20.0,
                                                  color: kMainColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 40.0,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            pickedImage =
                                                await _picker.pickImage(
                                                    source: ImageSource.camera);
                                            setState(() {
                                              imageFile =
                                                  File(pickedImage!.path);
                                              imagePath = pickedImage!.path;
                                            });
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 100), () {
                                              Navigator.pop(context);
                                            });
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.camera,
                                                size: 60.0,
                                                color: kGreyTextColor,
                                              ),
                                              Text(
                                                lang.S.of(context).camera,
                                                style: GoogleFonts.inter(
                                                  fontSize: 20.0,
                                                  color: kGreyTextColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                      child: Stack(
                        children: [
                          Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black54, width: 1),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(120)),
                              image: widget.type == 1
                                  ? DecorationImage(
                                      image: NetworkImage(
                                          widget.model!.categoryimage),
                                      fit: BoxFit.cover,
                                    )
                                  : imagePath == 'No Data'
                                      ? DecorationImage(
                                          image: NetworkImage(productPicture),
                                          fit: BoxFit.cover,
                                        )
                                      : DecorationImage(
                                          image: FileImage(imageFile),
                                          fit: BoxFit.cover,
                                        ),
                            ),
                          ),
                          Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black54, width: 1),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(120)),
                              image: DecorationImage(
                                image: FileImage(imageFile),
                                fit: BoxFit.cover,
                              ),
                            ),
                            // child: imageFile.path == 'No File' ? null : Image.file(imageFile),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 2),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(120)),
                                color: kMainColor,
                              ),
                              child: const Icon(
                                Icons.camera_alt_outlined,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
                ButtonGlobalWithoutIcon(
                  buttontext: 'Save',
                  buttonDecoration:
                      kButtonDecoration.copyWith(color: kMainColor),
                  onPressed: () async {
                    if (categoryName.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please enter category")));
                      return;
                    }
                    bool isAlreadyAdded = false;

                    allCategory.value?.forEach((element) {
                      if (element.categoryName
                          .toLowerCase()
                          .removeAllWhiteSpace()
                          .contains(
                            categoryName.toLowerCase().removeAllWhiteSpace(),
                          )) {
                        isAlreadyAdded = true;
                      }
                    });
                    setState(() {
                      showProgress = true;
                    });

                    imagePath == 'No Data' ? null : await uploadFile(imagePath);
                    // ignore: no_leading_underscores_for_local_identifiers
                    final DatabaseReference _categoryInformationRef =
                        FirebaseDatabase.instance
                            .ref()
                            .child(constUserId)
                            .child('Categories');
                    _categoryInformationRef.keepSynced(true);

                    CategoryModel categoryModel = CategoryModel(
                      categoryimage: productPicture,
                      categoryName: categoryName,
                      size: sizeCheckbox,
                      color: colorCheckbox,
                      capacity: capacityCheckbox,
                      type: typeCheckbox,
                      weight: weightCheckbox,
                    );

                    if (widget.type == 0) {
                      isAlreadyAdded
                          ? EasyLoading.showError('Already Added')
                          : _categoryInformationRef
                              .push()
                              .set(categoryModel.toJson());
                    } else {
                      await updatecate();
                    }
                    setState(() {
                      showProgress = false;
                      isAlreadyAdded
                          ? null
                          : ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Data Saved Successfully")));
                    });
                    ref.refresh(categoryProvider);

                    // ignore: use_build_context_synchronously

                    widget.type == 0
                        ? isAlreadyAdded
                            ? null
                            : Navigator.pop(context)
                        : Navigator.pop(context);
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

  updatecate() async {
    var brandkey = "";
    final sref = FirebaseDatabase.instance.ref(constUserId).child('Categories');

    await sref.get().then((value) {
      for (var element in value.children) {
        var sdata = jsonDecode(jsonEncode(element.value));
        if (sdata['categoryName'].toString() ==
            widget.model!.categoryName.toString()) {
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
        .child('Categories')
        .child(brandkey.toString());
    // .child('Admin Panel')
    // .child('Category');

    await shopCategoryRef.update({
      'categoryName': categoryName,
      'categoryImage': productPicture,
      'variationSize': sizeCheckbox,
      'variationColor': colorCheckbox,
      'variationCapacity': capacityCheckbox,
      'variationType': typeCheckbox,
      'variationWeight': weightCheckbox,
    });
  }
}
