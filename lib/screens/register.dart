
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sonnen_rennt/constants/color.dart';
import 'package:sonnen_rennt/widgets/drawer.dart';
import 'package:sonnen_rennt/widgets/input.dart';
import 'package:sonnen_rennt/widgets/navbar.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool? _checkboxValue = false;

  final double height = window.physicalSize.height;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Navbar(
          transparent: true,
          title: "",
          reverseTextcolor: true,
        ),
        extendBodyBehindAppBar: true,
        drawer: NowDrawer(currentPage: "Account"),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/imgs/register-bg.png"),
                      fit: BoxFit.cover)),
            ),
            SafeArea(
              child: ListView(children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 16, left: 16.0, right: 16.0, bottom: 32),
                  child: Card(
                      elevation: 5,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Container(
                          height: MediaQuery.of(context).size.height * 0.78,
                          color: SunRunColors.bgColorScreen,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 24.0, bottom: 8),
                                    child: Center(
                                        child: Text("Register",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600))),
                                  ),
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.center,
                                  //   crossAxisAlignment:
                                  //   CrossAxisAlignment.center,
                                  //   children: [
                                  //     RawMaterialButton(
                                  //       onPressed: () {},
                                  //       elevation: 4.0,
                                  //       fillColor: SunRunColors.socialFacebook,
                                  //       child: Icon(FontAwesomeIcons.facebook,
                                  //           size: 16.0, color: Colors.white),
                                  //       padding: EdgeInsets.all(15.0),
                                  //       shape: CircleBorder(),
                                  //     ),
                                  //     RawMaterialButton(
                                  //       onPressed: () {},
                                  //       elevation: 4.0,
                                  //       fillColor: SunRunColors.socialTwitter,
                                  //       child: Icon(FontAwesomeIcons.twitter,
                                  //           size: 16.0, color: Colors.white),
                                  //       padding: EdgeInsets.all(15.0),
                                  //       shape: CircleBorder(),
                                  //     ),
                                  //     RawMaterialButton(
                                  //       onPressed: () {},
                                  //       elevation: 4.0,
                                  //       fillColor: SunRunColors.socialDribbble,
                                  //       child: Icon(FontAwesomeIcons.dribbble,
                                  //           size: 16.0, color: Colors.white),
                                  //       padding: EdgeInsets.all(15.0),
                                  //       shape: CircleBorder(),
                                  //     )
                                  //   ],
                                  // ),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(
                                  //       top: 24.0, bottom: 24.0),
                                  //   child: Center(
                                  //     child: Text("or be classical",
                                  //         style: TextStyle(
                                  //             color: SunRunColors.time,
                                  //             fontWeight: FontWeight.w200,
                                  //             fontSize: 16)),
                                  //   ),
                                  // ),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Input(
                                          placeholder: "First Name...",
                                          prefixIcon:
                                          Icon(Icons.school, size: 20),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Input(
                                            placeholder: "Last Name...",
                                            prefixIcon:
                                            Icon(Icons.email, size: 20)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0,
                                            left: 8.0,
                                            right: 8.0,
                                            bottom: 0),
                                        child: Input(
                                            placeholder: "Your Email...",
                                            prefixIcon:
                                            Icon(Icons.lock, size: 20)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, top: 0, bottom: 16),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            Checkbox(
                                                activeColor:
                                                SunRunColors.primary,
                                                onChanged: (bool? newValue) =>
                                                    setState(() =>
                                                    _checkboxValue =
                                                        newValue),
                                                value: _checkboxValue),
                                            Text(
                                                "I agree with the terms and conditions",
                                                style: TextStyle(
                                                    color: SunRunColors.black,
                                                    fontSize: 12,
                                                    fontWeight:
                                                    FontWeight.w200)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Center(
                                    child: RaisedButton(
                                      textColor: SunRunColors.white,
                                      color: SunRunColors.primary,
                                      onPressed: () {
                                        // Respond to button press
                                        Navigator.pushReplacementNamed(
                                            context, '/home');
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(32.0),
                                      ),
                                      child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 32.0,
                                              right: 32.0,
                                              top: 12,
                                              bottom: 12),
                                          child: Text("Get Started",
                                              style:
                                              TextStyle(fontSize: 14.0))),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))),
                ),
              ]),
            )
          ],
        ));
  }
}
