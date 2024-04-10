import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:online_music_player/admin/admin_dashboard.dart';
import 'package:online_music_player/models/admindetails.dart';
import 'package:online_music_player/models/myurl.dart';
import 'package:online_music_player/pages/loadingdialog.dart';
import 'package:online_music_player/pages/startpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  GlobalKey<FormState> adminformkey = GlobalKey();
  bool isvisible = false;
  bool type = true;
  TextEditingController _adminemail = TextEditingController();
  TextEditingController _adminpassword = TextEditingController();

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
          Uri.http(MyUrl.mainurl, MyUrl.suburl + "admin_login.php"),
          body: data);
      var jsondata = jsonDecode(response.body);
      if (jsondata["status"] == "true") {
        Navigator.pop(context);

        var sharedPref = await SharedPreferences.getInstance();
        sharedPref.setBool(StartPageState.ADMINLOGIN, true);

        sharedPref.setString("adminid", jsondata["id"].toString());
        sharedPref.setString("adminname", jsondata["name"].toString());
        sharedPref.setString("adminphone", jsondata["phone"].toString());
        sharedPref.setString("adminemail", jsondata["email"].toString());
        sharedPref.setString("adminimage", jsondata["image"].toString());
        Admin admin = Admin(
            jsondata["id"].toString(),
            jsondata["name"].toString(),
            jsondata["phone"].toString(),
            jsondata["email"].toString(),
            jsondata["image"].toString());

        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => AdminDashboard(admin)));

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
                key: adminformkey,
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
                        "ADMIN LOGIN",
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
                      controller: _adminemail,
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
                      controller: _adminpassword,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Password Required";
                        } else if (_adminpassword.text.length <= 7) {
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
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Container(
                        margin: const EdgeInsets.only(top: 5),
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          onPressed: () {
                            if (adminformkey.currentState!.validate()) {
                              loginStatus(
                                  _adminemail.text, _adminpassword.text);
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
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
