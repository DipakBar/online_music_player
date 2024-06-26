import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_music_player/models/myurl.dart';
import 'package:online_music_player/models/userdetails.dart';
import 'package:online_music_player/pages/dashboard.dart';
import 'package:online_music_player/pages/forget.dart';
import 'package:online_music_player/pages/loadingdialog.dart';
import 'package:online_music_player/pages/signuppage.dart';
import 'package:online_music_player/pages/startpage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:online_music_player/models/globalclass.dart' as globalclass;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> formkey = GlobalKey();
  bool isvisible = false;
  bool type = true;
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  InputDecoration style = InputDecoration(
    labelText: 'Email',
    hintText: 'Enter your Email',
    fillColor: Colors.grey[150],
    filled: true,
    prefixIcon: const Icon(Icons.email),
    prefixIconColor: Colors.black,
    contentPadding: const EdgeInsets.only(top: 0, left: 10),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black, width: 2),
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(
          color: Color.fromARGB(
            255,
            5,
            127,
            192,
          ),
          width: 2),
    ),
  );
  Future<void> loginStatus(String email, String password) async {
    Map data = {"email": email, "password": password};
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return LoadingDialog();
        });

    try {
      var response = await http.post(
          Uri.http(MyUrl.mainurl, MyUrl.suburl + "user_login.php"),
          body: data);
      var jsondata = jsonDecode(response.body);
      if (jsondata["status"] == "true") {
        Navigator.pop(context);

        var sharedPref = await SharedPreferences.getInstance();
        sharedPref.setBool(StartPageState.KEYLOGIN, true);

        sharedPref.setString("id", jsondata["id"].toString());
        sharedPref.setString("name", jsondata["name"].toString());
        sharedPref.setString("phone", jsondata["phone"].toString());
        sharedPref.setString("email", jsondata["email"].toString());
        sharedPref.setString("image", jsondata["image"].toString());
        User user = User(
            jsondata["id"].toString(),
            jsondata["name"].toString(),
            jsondata["phone"].toString(),
            jsondata["email"].toString(),
            jsondata["image"].toString());

        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) =>
                DashBoard(user, globalclass.controller.stream)));

        Fluttertoast.showToast(
          msg: jsondata['msg'],
        );
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: jsondata['msg'],
        );
      }
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 80),
            child: Form(
                autovalidateMode: AutovalidateMode.always,
                key: formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/images/login.png",
                        height: 220,
                        width: 220,
                      ),
                    ),
                    Container(
                      child: const Text(
                        "LOGIN",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      child: Text(
                        "Login to your account",
                        style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Email Required";
                        } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{3,4}$')
                            .hasMatch(value)) {
                          return "Please enter valid email";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        labelText: "Email",
                        hintText: "Enter your Email",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28)),
                        prefixIcon: Icon(CupertinoIcons.mail),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _password,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Password Required";
                        } else if (_password.text.length <= 7) {
                          return 'Password must be atleast 8 Characters';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: type,
                      decoration: InputDecoration(
                        labelText: "Password",
                        hintText: "Enter password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28)),
                        prefixIcon: const Icon(CupertinoIcons.lock),
                        suffixIcon: TextButton(
                          child: type
                              ? const Icon(Icons.visibility_off)
                              : const Icon(
                                  Icons.visibility,
                                  color: Colors.black,
                                ),
                          onPressed: () {
                            setState(() {
                              type = !type;
                            });
                          },
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              // Navigator.of(context).pushReplacement(
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             const ForgetPass()));
                            },
                            child: const Text(
                              "Forget password?",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            )),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () {
                          if (formkey.currentState!.validate()) {
                            loginStatus(_email.text, _password.text);
                          } else {
                            Fluttertoast.showToast(
                                msg: "Please Enter Email Id and Password");
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            'LOGIN',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => Colors.blue),
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(fontSize: 15),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignUpPage()));
                            },
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            )),
                      ],
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
