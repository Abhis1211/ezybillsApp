import '../../constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../Provider/profile_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../model/personal_information_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Screens/Profile%20Screen/edit_profile.dart';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({Key? key}) : super(key: key);
  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

@override
class _ProfileDetailsState extends State<ProfileDetails> {
  var isloading = false;
  @override
  void initState() {
    // () async {
    //   setState(() {
    //     isloading = true;
    //   });
    //   // await profileRepo.getDetails();
    //   setState(() {
    //     isloading = false;
    //   });
    // }();

    super.initState();
  }

  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, __) {
      AsyncValue<PersonalInformationModel> userProfileDetails =
          ref.watch(profileDetailsProvider);
      return userProfileDetails.when(data: (details) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              lang.S.of(context).profile,
              style: GoogleFonts.inter(
                color: Colors.black,
                fontSize: 20.0,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: GestureDetector(
                  onTap: () async {
                    await ref.refresh(profileDetailsProvider);
                    Future.delayed(const Duration(milliseconds: 500), () {
                      EditProfile(
                        profile: details,
                      ).launch(context);
                    });
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.edit,
                        color: kMainColor,
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        lang.S.of(context).edit,
                        style: GoogleFonts.inter(
                          color: kMainColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            iconTheme: const IconThemeData(color: Colors.black),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0.0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Container(
                      height: 100.0,
                      width: 100.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(details.pictureUrl ?? ''),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: AppTextField(
                      readOnly: true,
                      cursorColor: kGreyTextColor,
                      controller: TextEditingController(
                        text: details.companyName,
                      ),
                      decoration: InputDecoration(
                          labelText: lang.S.of(context).name,
                          hintText: lang.S.of(context).name,
                          border: const OutlineInputBorder().copyWith(
                              borderSide:
                                  const BorderSide(color: kGreyTextColor)),
                          hoverColor: kGreyTextColor,
                          fillColor: kGreyTextColor),
                      textFieldType: TextFieldType.NAME,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: AppTextField(
                      onTap: () {
                        print("object=>>>>>>>>> " + details.email.toString());
                      },
                      readOnly: true,
                      cursorColor: kGreyTextColor,
                      controller: TextEditingController(
                        text: details.email,
                      ),
                      decoration: InputDecoration(
                          labelText: lang.S.of(context).emailText,
                          border: const OutlineInputBorder().copyWith(
                              borderSide:
                                  const BorderSide(color: kGreyTextColor)),
                          hoverColor: kGreyTextColor,
                          fillColor: kGreyTextColor),
                      textFieldType: TextFieldType.NAME,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: AppTextField(
                      onTap: () {
                        print("object=>>>>>>>>> " +
                            details.phoneNumber.toString());
                      },
                      readOnly: true,
                      cursorColor: kGreyTextColor,
                      controller: TextEditingController(
                        text: details.phoneNumber,
                      ),
                      decoration: InputDecoration(
                          labelText: lang.S.of(context).phone,
                          border: const OutlineInputBorder().copyWith(
                              borderSide:
                                  const BorderSide(color: kGreyTextColor)),
                          hoverColor: kGreyTextColor,
                          fillColor: kGreyTextColor),
                      textFieldType: TextFieldType.NAME,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: AppTextField(
                      onTap: () {
                        print("object=>>>>>>>>> " +
                            details.altphoneNumber.toString());
                      },
                      readOnly: true,
                      cursorColor: kGreyTextColor,
                      controller: TextEditingController(
                        text: details.altphoneNumber,
                      ),
                      decoration: InputDecoration(
                          labelText: "Alternate phone number ",
                          border: const OutlineInputBorder().copyWith(
                              borderSide:
                                  const BorderSide(color: kGreyTextColor)),
                          hoverColor: kGreyTextColor,
                          fillColor: kGreyTextColor),
                      textFieldType: TextFieldType.NAME,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: AppTextField(
                      readOnly: true,
                      cursorColor: kGreyTextColor,
                      controller: TextEditingController(
                        text: details.businessCategory,
                      ),
                      decoration: InputDecoration(
                        labelText: lang.S.of(context).businessCat,
                        border: const OutlineInputBorder().copyWith(
                            borderSide:
                                const BorderSide(color: kGreyTextColor)),
                        hoverColor: kGreyTextColor,
                        fillColor: kGreyTextColor,
                      ),
                      textFieldType: TextFieldType.NAME,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: AppTextField(
                      readOnly: true,
                      cursorColor: kGreyTextColor,
                      controller: TextEditingController(
                        text: details.countryName,
                      ),
                      decoration: InputDecoration(
                          labelText: lang.S.of(context).address,
                          border: const OutlineInputBorder().copyWith(
                              borderSide:
                                  const BorderSide(color: kGreyTextColor)),
                          hoverColor: kGreyTextColor,
                          fillColor: kGreyTextColor),
                      textFieldType: TextFieldType.NAME,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: AppTextField(
                      readOnly: true,
                      cursorColor: kGreyTextColor,
                      maxLines: 100,
                      keyboardType: TextInputType.multiline,
                      controller: TextEditingController(
                        text: details.note,
                      ),
                      decoration: InputDecoration(
                          labelText: "Invoice Note",
                          border: const OutlineInputBorder().copyWith(
                              borderSide:
                                  const BorderSide(color: kGreyTextColor)),
                          hoverColor: kGreyTextColor,
                          fillColor: kGreyTextColor),
                      textFieldType: TextFieldType.NAME,
                    ),
                  ),
                  if (details.gstenable == true)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: AppTextField(
                        readOnly: true,
                        cursorColor: kGreyTextColor,
                        controller: TextEditingController(
                          text: details.gstnumber,
                        ),
                        decoration: InputDecoration(
                            labelText: "GST number",
                            border: const OutlineInputBorder().copyWith(
                                borderSide:
                                    const BorderSide(color: kGreyTextColor)),
                            hoverColor: kGreyTextColor,
                            fillColor: kGreyTextColor),
                        textFieldType: TextFieldType.NAME,
                      ),
                    ),
                  ButtonGlobal(
                    iconWidget: Icons.arrow_forward,
                    buttontext: lang.S.of(context).changePassword,
                    iconColor: Colors.white,
                    buttonDecoration:
                        kButtonDecoration.copyWith(color: kMainColor),
                    onPressed: () async {
                      try {
                        EasyLoading.show(
                            status: 'Sending Email', dismissOnTap: false);
                        await FirebaseAuth.instance.sendPasswordResetEmail(
                          email: FirebaseAuth.instance.currentUser!.email
                              .toString(),
                        );
                        EasyLoading.showSuccess('Email Sent! Check your Inbox');
                        // ignore: use_build_context_synchronously
                        // const LoginForm(
                        //   isEmailLogin: true,
                        // ).launch(context);
                        // FirebaseAuth.instance.signOut();
                      } catch (e) {
                        EasyLoading.showError(e.toString());
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }, error: (e, stack) {
        return Text(e.toString());
      }, loading: () {
        return const CircularProgressIndicator();
      });
    });
  }
}
