import 'package:customer_app/config/colors.dart';
import 'package:customer_app/config/supportQuery.dart';
import 'package:customer_app/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../provider/rootprovider.dart';

class Support extends ConsumerStatefulWidget {
  const Support({Key? key}) : super(key: key);

  @override
  ConsumerState<Support> createState() => _SupportState();
}

class _SupportState extends ConsumerState<Support> {
  RootModel? readProvider;
  TextEditingController subjectController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  var subjectFocusNode = FocusNode();
  var messageFocusNode = FocusNode();
  var dropdownError = "";
  var subjectError = "";
  var messageError = "";
  var subject = "";
  var message = "";
  var dropdownValue = "";
  var isLoading = false;

  checkData() {
    var foundErr = false;

    // check dropdown subject
    if (dropdownValue == "") {
      foundErr = true;
      setState(() {
        dropdownError = "Invalid subject";
      });
    }

    // check subject
    if (dropdownValue == "Other") {
      if (subjectController.text == '') {
        foundErr = true;
        setState(() {
          subjectError = "Invalid subject";
        });
      }
    }

    // check message
    if (messageController.text == '') {
      foundErr = true;
      setState(() {
        messageError = "Invalid message";
      });
    }

    //  if no error found
    if (!foundErr) {
      setState(() {
        isLoading = true;
      });
      submitQuery();
    }
  }

  // submit query
  submitQuery() {
    // payload
    var payload = {
      'mobile': readProvider!.customerProviderRead.customerdata.mobile,
      'subject':
          dropdownValue == "Other" ? subjectController.text : dropdownValue,
      'message': messageController.text,
    };

    print(payload);

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    setState(() {
      readProvider = ref.read(rootProvider).AllProvider();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var widthsize = MediaQuery.of(context).size.width;
    var heightsize = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        child: Column(
          children: [
            //  header
            Helper.headerWithLeftIcon(
                widthsize, heightsize, context, "Support"),

            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: heightsize * 5 / 100),
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    // drop down input
                    Container(
                      width: widthsize * 90 / 100,
                      height: heightsize * 5.2 / 100,
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(top: heightsize * 3 / 100),
                      padding: EdgeInsets.only(
                          left: widthsize * 3 / 100,
                          right: widthsize * 3 / 100),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: dropdownError.length > 0
                                ? AppColors.error
                                : AppColors.disable,
                          ),
                          borderRadius: BorderRadius.all(
                              Radius.circular(widthsize * 1 / 100))),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: dropdownValue != "" ? dropdownValue : null,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          size: widthsize * 4.4 / 100,
                          color: AppColors.disable,
                        ),
                        elevation: 16,
                        style:
                            GoogleFonts.baloo2(fontSize: widthsize * 4 / 100),
                        hint: Text("Select subject",
                            style: GoogleFonts.baloo2(
                                fontSize: widthsize * 4 / 100)),
                        underline: Container(
                          height: 0,
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            dropdownError = "";
                            dropdownValue = value!;
                            subjectController.clear();
                          });
                        },
                        items: SupportQuery.data
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: GoogleFonts.baloo2(
                                  fontSize: widthsize * 4 / 100,
                                  color: AppColors.black_text),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    dropdownError.length > 0
                        ? Container(
                            width: widthsize * 90 / 100,
                            alignment: Alignment.centerLeft,
                            margin:
                                EdgeInsets.only(top: heightsize * 0.5 / 100),
                            padding: EdgeInsets.only(
                                left: widthsize * 3 / 100,
                                right: widthsize * 3 / 100),
                            child: Text(
                              dropdownError,
                              style: TextStyle(
                                  fontSize: widthsize * 3 / 100,
                                  color: AppColors.error),
                            ),
                          )
                        : Container(),

                    // subject
                    dropdownValue == "Other"
                        ? Container(
                            margin: EdgeInsets.only(top: heightsize * 3 / 100),
                            padding: EdgeInsets.only(
                                left: widthsize * 5 / 100,
                                right: widthsize * 5 / 100),
                            child: TextField(
                              enabled: !isLoading,
                              onChanged: (text) {
                                setState(() {
                                  subjectError = "";
                                });
                              },
                              focusNode: subjectFocusNode,
                              controller: subjectController,
                              keyboardType: TextInputType.text,
                              cursorColor: AppColors.blue,
                              style: TextStyle(
                                  fontSize: widthsize * 4 / 100,
                                  color: AppColors.black_text),
                              decoration: InputDecoration(
                                  hintText: "Enter subject",
                                  border: OutlineInputBorder(),
                                  contentPadding:
                                      EdgeInsets.all(widthsize * 3 / 100),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: AppColors.disable)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: AppColors.blue)),
                                  errorBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: AppColors.error)),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: AppColors.error)),
                                  errorStyle: TextStyle(
                                      fontSize: widthsize * 3 / 100,
                                      color: AppColors.error),
                                  errorText: (subjectError.length > 0
                                      ? subjectError
                                      : null)),
                            ),
                          )
                        : Container(),

                    //  message input box
                    Container(
                      margin: EdgeInsets.only(top: heightsize * 3 / 100),
                      padding: EdgeInsets.only(
                          left: widthsize * 5 / 100,
                          right: widthsize * 5 / 100),
                      child: TextField(
                        enabled: !isLoading,
                        onChanged: (text) {
                          setState(() {
                            messageError = "";
                          });
                        },
                        focusNode: messageFocusNode,
                        controller: messageController,
                        keyboardType: TextInputType.multiline,
                        minLines: 10,
                        maxLines: 50,
                        cursorColor: AppColors.blue,
                        style: TextStyle(
                            fontSize: widthsize * 4 / 100,
                            color: AppColors.black_text),
                        decoration: InputDecoration(
                            hintText: "Enter message",
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.all(widthsize * 3 / 100),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: AppColors.disable)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColors.blue)),
                            errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColors.error)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColors.error)),
                            errorStyle: TextStyle(
                                fontSize: widthsize * 3 / 100,
                                color: AppColors.error),
                            errorText: (messageError.length > 0
                                ? messageError
                                : null)),
                      ),
                    ),

                    Container(
                      width: widthsize,
                      height: heightsize * 5 / 100,
                      margin: EdgeInsets.only(top: heightsize * 3 / 100),
                      padding: EdgeInsets.only(
                          left: widthsize * 5 / 100,
                          right: widthsize * 5 / 100),
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
                                "Submit",
                                style: TextStyle(
                                    fontSize: widthsize * 4 / 100,
                                    color: AppColors.white_text),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
