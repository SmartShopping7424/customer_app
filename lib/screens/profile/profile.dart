import 'dart:convert';
import 'package:customer_app/services/customer/customerapi.dart';
import 'package:customer_app/utils/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:customer_app/provider/rootprovider.dart';
import 'package:customer_app/config/colors.dart';
import 'package:customer_app/utils/helper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../utils/localstorage.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  RootModel? readProvider;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  var nameFocusNode = FocusNode();
  var emailFocusNode = FocusNode();
  var gender = '';
  var nameError = '';
  var emailError = '';
  var genderError = '';
  var mobile = '';
  var isLoading = false;
  var hasFoucs = '';

  // check data
  checkData() {
    var foundErr = false;
    RegExp regExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    // check name
    if (nameController.text == '') {
      foundErr = true;
      setState(() {
        nameError = "Invalid name";
      });
    }

    // check email
    if (!regExp.hasMatch(emailController.text)) {
      foundErr = true;
      setState(() {
        emailError = "Invalid email";
      });
    }

    // check gender
    if (!(gender == 'male' || gender == 'female')) {
      foundErr = true;
      setState(() {
        genderError = 'Invalid gender';
      });
    }

    //  if no error found
    if (!foundErr) {
      setState(() {
        isLoading = true;
      });
      saveUserData();
    }
  }

  // save user data
  saveUserData() async {
    // initilize payload
    var payload = {
      'mobile': mobile,
      'name': nameController.text,
      'email': emailController.text,
      'gender': gender
    };

    // call the api
    var res = await CustomerAPI.updateData(payload);
    await Delay(1000);
    if (res['code'] == 200) {
      var updatedData = {
        'mobile': mobile,
        'name': nameController.text,
        'email': emailController.text,
        'gender': gender
      };
      await LocalStorage.setLocalStorage('customer', jsonEncode(updatedData));
      await readProvider!.customerProviderRead.updateCustomerData();
      Toaster.toastMessage("Profile updated.", context);
      Navigator.pop(context);
    } else {
      Toaster.toastMessage(
          "Something went wrong, Please try again later.", context);
      setState(() {
        isLoading = false;
      });
    }
  }

  // fetch user data
  fetchData() async {
    nameController.text = readProvider!.customerProviderRead.customerdata.name!;
    emailController.text =
        readProvider!.customerProviderRead.customerdata.email!;
    setState(() {
      gender = readProvider!.customerProviderRead.customerdata.gender!;
      mobile = readProvider!.customerProviderRead.customerdata.mobile!;
    });
    nameFocusNode.addListener(() {
      if (nameFocusNode.hasFocus) {
        setState(() {
          hasFoucs = "name";
        });
      } else if (!nameFocusNode.hasFocus && !emailFocusNode.hasFocus) {
        setState(() {
          hasFoucs = "";
        });
      }
    });
    emailFocusNode.addListener(() {
      if (emailFocusNode.hasFocus) {
        setState(() {
          hasFoucs = "email";
        });
      } else if (!nameFocusNode.hasFocus && !emailFocusNode.hasFocus) {
        setState(() {
          hasFoucs = "";
        });
      }
    });
  }

  @override
  void initState() {
    setState(() {
      readProvider = ref.read(rootProvider).AllProvider();
    });
    fetchData();
    super.initState();
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var widthsize = MediaQuery.of(context).size.width;
    var heightsize = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () => {nameFocusNode.unfocus(), emailFocusNode.unfocus()},
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              //  header
              Helper.headerWithLeftIcon(
                  widthsize, heightsize, context, "Update Profile"),
              // rest container
              Container(
                width: widthsize,
                child: Column(
                  children: [
                    // name input box
                    InputBox(heightsize, widthsize, "name"),

                    // email input box
                    InputBox(heightsize, widthsize, "email"),

                    // gender button
                    Container(
                      margin: EdgeInsets.only(top: heightsize * 4 / 100),
                      padding: EdgeInsets.only(left: widthsize * 5 / 100),
                      child: Row(
                        children: [
                          // male button
                          Container(
                            margin: EdgeInsets.only(right: widthsize * 3 / 100),
                            decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(1, 1),
                                    blurRadius: 4,
                                    color: AppColors.shadow,
                                  ),
                                ]),
                            child: Row(
                              children: [
                                // male gender button
                                GenderContainer(
                                  widthsize,
                                  heightsize,
                                  "Male",
                                ),
                                // male gender check icon
                                gender == 'male'
                                    ? Container(
                                        margin: EdgeInsets.only(
                                            right: widthsize * 3 / 100),
                                        child: Icon(
                                          Icons.check_circle,
                                          color: AppColors.green,
                                          size: widthsize * 5 / 100,
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                          ),

                          // female button
                          Container(
                            decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(1, 1),
                                    blurRadius: 4,
                                    color: AppColors.shadow,
                                  ),
                                ]),
                            child: Row(
                              children: [
                                // female gender button
                                GenderContainer(
                                  widthsize,
                                  heightsize,
                                  "Female",
                                ),
                                // female gender check icon
                                gender == 'female'
                                    ? Container(
                                        margin: EdgeInsets.only(
                                            right: widthsize * 3 / 100),
                                        child: Icon(
                                          Icons.check_circle,
                                          color: AppColors.green,
                                          size: widthsize * 5 / 100,
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // gender error
                    genderError.length > 0
                        ? Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(top: heightsize * 1 / 100),
                            padding: EdgeInsets.only(
                              left: widthsize * 8 / 100,
                            ),
                            child: Text(
                              genderError,
                              style: TextStyle(
                                  fontSize: widthsize * 3 / 100,
                                  color: AppColors.error),
                            ),
                          )
                        : Container(),

                    // submit button
                    Button(widthsize, heightsize)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // input box
  Container InputBox(double heightsize, double widthsize, String type) {
    return Container(
      margin: EdgeInsets.only(top: heightsize * 3 / 100),
      padding: EdgeInsets.only(
          left: widthsize * 5 / 100, right: widthsize * 5 / 100),
      child: TextField(
        enabled: !isLoading,
        onChanged: (text) {
          setState(() {
            if (type == 'name') {
              nameError = '';
            } else if (type == 'email') {
              emailError = '';
            }
          });
        },
        focusNode: type == 'name'
            ? nameFocusNode
            : type == 'email'
                ? emailFocusNode
                : null,
        controller: type == 'name'
            ? nameController
            : type == 'email'
                ? emailController
                : null,
        keyboardType: type == 'name'
            ? TextInputType.text
            : type == 'email'
                ? TextInputType.emailAddress
                : TextInputType.text,
        cursorColor: AppColors.blue,
        style: TextStyle(
            fontSize: widthsize * 4 / 100, color: AppColors.black_text),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.all(widthsize * 3 / 100),
          floatingLabelStyle: TextStyle(
            color: type == 'name'
                ? (nameError.length > 0
                    ? AppColors.error
                    : hasFoucs == 'name' && !isLoading
                        ? AppColors.blue
                        : AppColors.disable)
                : type == 'email'
                    ? (emailError.length > 0
                        ? AppColors.error
                        : hasFoucs == 'email' && !isLoading
                            ? AppColors.blue
                            : AppColors.disable)
                    : AppColors.disable,
          ),
          labelStyle: TextStyle(
              color: type == 'name'
                  ? (nameError.length > 0 ? AppColors.error : AppColors.disable)
                  : type == 'email'
                      ? (emailError.length > 0
                          ? AppColors.error
                          : AppColors.disable)
                      : AppColors.disable),
          labelText: type == 'name'
              ? 'Name'
              : type == 'email'
                  ? "Email"
                  : "",
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.disable)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: AppColors.blue)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.error)),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.error)),
          errorStyle:
              TextStyle(fontSize: widthsize * 3 / 100, color: AppColors.error),
          errorText: type == 'name'
              ? (nameError.length > 0 ? nameError : null)
              : type == 'email'
                  ? (emailError.length > 0 ? emailError : null)
                  : null,
        ),
      ),
    );
  }

  // gender container button
  Container GenderContainer(
    double widthsize,
    double heightsize,
    String title,
  ) {
    return Container(
      child: MaterialButton(
        elevation: 0,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: () => {
          setState(() {
            if (!isLoading) {
              gender = title.toLowerCase();
              genderError = '';
            }
          })
        },
        child: Row(
          children: [
            Container(
              child: Text(
                title,
                style: TextStyle(
                    fontSize: widthsize * 4 / 100, color: AppColors.black_text),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // submit button
  Container Button(double widthsize, double heightsize) {
    return Container(
      width: widthsize,
      height: heightsize * 5 / 100,
      margin: EdgeInsets.only(top: heightsize * 3 / 100),
      padding: EdgeInsets.only(
          left: widthsize * 5 / 100, right: widthsize * 5 / 100),
      child: MaterialButton(
        elevation: 0,
        color: AppColors.blue,
        onPressed: () {
          checkData();
        },
        child: isLoading
            ? Container(
                child: SpinKitRing(
                  color: Colors.white,
                  size: widthsize * 5 / 100,
                  lineWidth: 2,
                  duration: Duration(milliseconds: 1000),
                ),
              )
            : Text(
                "Update",
                style: TextStyle(
                    fontSize: widthsize * 4 / 100, color: AppColors.white_text),
              ),
      ),
    );
  }
}
