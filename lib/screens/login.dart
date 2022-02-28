
import 'dart:ui';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:sonnen_rennt/constants/color.dart';
import 'package:sonnen_rennt/logic/auth.dart';
import 'package:sonnen_rennt/structs/auth.dart';
import 'package:sonnen_rennt/widgets/utils/waiting.dart';



class LoginScreen extends StatefulWidget {

  LoginScreen({this.refreshAuthStatusCallback});

  Function refreshAuthStatusCallback = (){};

  @override
  _LoginScreenState createState() => _LoginScreenState(
    refreshAuthStatusCallback: refreshAuthStatusCallback
  );
}


class ObscuredText extends ChangeNotifier {
  bool _obscuredPassword = true;

  void toggle() {
    _obscuredPassword = !_obscuredPassword;
    notifyListeners();
  }

  void setObscured(bool obscured) {
    _obscuredPassword = obscured;
    notifyListeners();
  }

  bool get obscured => _obscuredPassword;

}

class _LoginScreenState extends State<LoginScreen> {

  _LoginScreenState({this.refreshAuthStatusCallback});

  final _formKey = GlobalKey<FormState>();

  Function refreshAuthStatusCallback = (){};

  String _input_username, _input_password;
  bool _storeLoginCredentials = false;

  String _errorUsername = null;
  String _errorPassword = null;

  bool _waiting = false;
  ObscuredText obscuredText = ObscuredText();

  void _clickLogIn(AuthHandler handler, BuildContext context) async {
    if (_waiting) {
      final snackBar = SnackBar(
        content: Text("Warte bis die vorherige Anfrage bearbeitet wurde!",
            style: TextStyle(color: Colors.white)
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    try {
      if (_formKey.currentState.validate()) {
        setState(() {
          _waiting = true;
        });
        var result = await handler.tryLoginAndStore(_input_username, _input_password);

        if (result == true) {
          var secStorage = FlutterSecureStorage();
          if (_storeLoginCredentials) {
            secStorage.write(key: "username", value: _input_username);
            secStorage.write(key: "password", value: _input_password);
          }
        } else {
          if (result is LoginResult) {
            LoginResult res = result;
            if (res.usernameError != null) {
              _errorUsername = res.usernameError;
            }
            if (res.passwordError != null) {
              _errorPassword = res.passwordError;
            }
            final snackBar = SnackBar(
              content: Text(res.text,
                  style: TextStyle(color: Colors.white)
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else if (result is UserIdResult) {
            UserIdResult res = result;
            final snackBar = SnackBar(
              content: Text(res.text,
                  style: TextStyle(color: Colors.white)
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {
            final snackBar = SnackBar(
                content: Text("Unvorhergesehener Fehler!",
                  style: TextStyle(color: Colors.white),
                )
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
          _formKey.currentState.validate();
        }
      }
    } on Exception {
      print("login failed!");
    } on Error {
      print("login failed!");
    }
    setState(() {
      _waiting = false;
    });
  }

  @override
  void initState() {
    var fut = Future.sync(() async {
      var secStorage = FlutterSecureStorage();

      if (await secStorage.containsKey(key: "username")) {
        _input_username = await secStorage.read(key: "username");
      }

      if (await secStorage.containsKey(key: "password")) {
        _input_password = await secStorage.read(key: "password");
      }

      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: Navbar(
        //   transparent: true,
        //   title: "",
        //   reverseTextcolor: true,
        // ),
        // extendBodyBehindAppBar: true,
        // drawer: NowDrawer(currentPage: "Login"),
        body: Stack(
          children: [
            Container(
              color: Colors.deepOrangeAccent,
              // decoration: BoxDecoration(
              //     image: DecorationImage(
              //         image: AssetImage("assets/imgs/register-bg.png"),
              //         fit: BoxFit.cover)),
            ),
            SafeArea(
              child: ListView(children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 32, left: 16.0, right: 16.0, bottom: 32),
                  child: Card(
                      elevation: 5,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Container(
                          height: MediaQuery.of(context).size.height * 0.78,
                          // color: SunRunColors.bgColorScreen,
                          color: SunRunColors.djk_bg_darker,
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
                                        child: Text("Login",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: SunRunColors.djk_heading,
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
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            child: TextFormField(
                                              controller: TextEditingController(text: _input_username),
                                              onChanged: (String value) {
                                                _input_username = value;
                                              },
                                              validator: (val) {
                                                if(_errorUsername != null) {
                                                  String err = _errorUsername;
                                                  _errorUsername = null;
                                                  return err;
                                                }

                                                if(val == null || val.length <= 0)
                                                  return "Darf nicht leer sein!";

                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                hintText: "Nutzername",
                                                enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.white),
                                                    borderRadius: BorderRadius.circular(50.0),
                                                    gapPadding: 2.0
                                                ),
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.white),
                                                    borderRadius: BorderRadius.circular(50.0),
                                                    gapPadding: 2.0
                                                ),
                                                prefixIcon: Icon(Icons.person, size: 20, color: SunRunColors.djk_heading,),
                                                hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                                                labelStyle: TextStyle(
                                                  color: Colors.blue,
                                                ),
                                                // border: Border.all(color: Colors.white),
                                                // borderRadius: BorderRadius.circular(50),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            child: ChangeNotifierProvider.value(
                                              value: obscuredText,
                                              builder: (context, child) {
                                                return TextFormField(
                                                  controller: TextEditingController(text: _input_password),
                                                  onChanged: (String value) {
                                                    _input_password = value;
                                                  },
                                                  validator: (val) {
                                                    if(_errorPassword != null) {
                                                      String err = _errorPassword;
                                                      _errorPassword = null;
                                                      return err;
                                                    }

                                                    if(val == null || val.length <= 0)
                                                      return "Darf nicht leer sein!";

                                                    return null;
                                                  },
                                                  keyboardType: TextInputType.visiblePassword,
                                                  obscureText: Provider.of<ObscuredText>(context, listen: false).obscured,
                                                  decoration: InputDecoration(
                                                    hintText: "Passwort",
                                                    enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(color: Colors.white),
                                                        borderRadius: BorderRadius.circular(50.0),
                                                        gapPadding: 2.0
                                                    ),
                                                    border: OutlineInputBorder(
                                                        borderSide: BorderSide(color: Colors.white),
                                                        borderRadius: BorderRadius.circular(50.0),
                                                        gapPadding: 2.0
                                                    ),
                                                    prefixIcon: Icon(Icons.lock, size: 20, color: SunRunColors.djk_heading,),
                                                    suffixIcon: RawMaterialButton(
                                                      onPressed: () {
                                                        Provider.of<ObscuredText>(context, listen: false).toggle();
                                                      },
                                                      child: Icon(Provider.of<ObscuredText>(context, listen: false).obscured ? Icons.visibility_off : Icons.visibility),
                                                    ),
                                                    hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                                                    labelStyle: TextStyle(
                                                      color: Colors.blue,
                                                    ),
                                                    // border: Border.all(color: Colors.white),
                                                    // borderRadius: BorderRadius.circular(50),
                                                  ),
                                                );
                                              },
                                            )
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, top: 0, bottom: 16),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            children: [
                                              Theme(
                                                data: Theme.of(context).copyWith(
                                                  unselectedWidgetColor: Colors.white,
                                                ),
                                                child: Checkbox(
                                                    checkColor: SunRunColors.djk_heading,
                                                    activeColor: SunRunColors.primary,
                                                    onChanged: (bool newValue) =>
                                                        setState(() =>
                                                        _storeLoginCredentials =
                                                            newValue),
                                                    value: _storeLoginCredentials),
                                              ),
                                              Text(
                                                  "Anmeldedaten speichern",
                                                  style: TextStyle(
                                                      color: SunRunColors.djk_heading,
                                                      fontSize: 12,
                                                      fontWeight:
                                                      FontWeight.w300)),
                                            ],
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            "Registrierungen sind bisher \nnur über die Webapplikation möglich!",
                                            style: TextStyle(color: SunRunColors.djk_heading),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Builder(
                                    builder: (ctx) {
                                      if (_waiting) {
                                        return SrWaitingWidget();
                                      } else {
                                        return Center(
                                          child: RaisedButton(
                                            textColor: SunRunColors.white,
                                            color: SunRunColors.primary,
                                            onPressed: () {
                                              _clickLogIn(Provider.of<AuthHandler>(context, listen: false), context);
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
                                                child: Text("Anmelden",
                                                    style: TextStyle(fontSize: 14.0))),
                                          ),
                                        );
                                      }
                                    },
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
