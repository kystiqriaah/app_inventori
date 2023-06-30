import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:app_inventori/model/api.dart';
import 'package:logger/logger.dart';
import 'menu_page.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

enum LoginStatus { SignOut, SignIn }

class _LoginState extends State<Login> {
  FocusNode myFocusNode = FocusNode();
  LoginStatus _loginStatus = LoginStatus.SignOut;
  String? username, password;
  final _key = GlobalKey<FormState>();
  bool _secureText = true;
  final Logger _logger = Logger();

  void showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  void check() {
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      login();
    }
  }

  void login() async {
    final response = await http.post(Uri.parse(BaseUrl.urlLogin),
        body: {"username": username, "pass": password});
    final data = jsonDecode(response.body);
    int value = data['success'];
    String pesan = data['message'];
    String idAPI = data['id'];
    String userLevel = data['level'];

    if (value == 1) {
      setState(() {
        savePref(value, idAPI, userLevel);
        _logger.i(pesan);
        _loginStatus = LoginStatus.SignIn;
      });
    } else {
      _logger.e(pesan);
      dialogGagal(pesan);
    }
  }

  void savePref(int val, String idAPI, String userLevel) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt("value", val);
    preferences.setString("id", idAPI);
    preferences.setString("level", userLevel);
  }

  void getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      var value = preferences.getInt("value");
      var level = preferences.getString("level");

      if (value == 1) {
        _loginStatus = LoginStatus.SignIn;
      } else {
        _loginStatus = LoginStatus.SignOut;
      }

      _logger.i("User level: $level");
    });
  }

  void logOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt("value", 0);
    preferences.setString("id", null.toString());
    preferences.setString("level", null.toString());
    setState(() {
      _loginStatus = LoginStatus.SignOut;
    });
  }

  void dialogGagal(String pesan) {
    AwesomeDialog(
      dismissOnTouchOutside: false,
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      headerAnimationLoop: false,
      title: 'ERROR',
      desc: pesan,
      btnOkOnPress: () {},
      btnOkIcon: Icons.cancel,
      btnOkColor: Colors.red,
    ).show();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.SignOut:
        return Scaffold(
          body: Form(
            key: _key,
            child: ListView(
              padding: const EdgeInsets.only(top: 90.0, left: 20.0, right: 20.0),
              children: <Widget>[
                const Icon(
                  CupertinoIcons.cube_box,
                  size: 50.0,
                ),
                const Text(
                  "INVENTORI",
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.2,
                ),
                const SizedBox(
                  height: 25.0,
                ),
                TextFormField(
                  validator: (e) {
                    if (e!.isEmpty) {
                      return "silahkan isi username";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (e) => username = e,
                  decoration: InputDecoration(
                    labelText: "Username",
                    labelStyle: TextStyle(
                      color: myFocusNode.hasFocus
                          ? Colors.blue
                          : const Color.fromARGB(255, 32, 54, 70),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 32, 54, 70),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  obscureText: _secureText,
                  validator: (e) {
                    if (e!.isEmpty) {
                      return "silahkan isi password";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (e) => password = e,
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(
                      color: myFocusNode.hasFocus
                          ? Colors.blue
                          : const Color.fromARGB(255, 32, 54, 70),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 32, 54, 70),
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _secureText ? Icons.visibility_off : Icons.visibility,
                        color: myFocusNode.hasFocus
                            ? Colors.blue
                            : const Color.fromARGB(255, 32, 54, 70),
                      ),
                      onPressed: showHide,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                MaterialButton(
                  padding: const EdgeInsets.all(20.0),
                  color: const Color.fromARGB(255, 41, 69, 91),
                  onPressed: () {
                    check();
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      case LoginStatus.SignIn:
        return MenuPage(logOut);
    }
  }
}
