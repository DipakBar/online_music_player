import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:online_music_player/admin/admin_dashboard.dart';
import 'package:online_music_player/main.dart';
import 'package:online_music_player/models/admindetails.dart';
import 'package:online_music_player/models/userdetails.dart';
import 'package:online_music_player/pages/dashboard.dart';
import 'package:online_music_player/pages/firstpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:online_music_player/models/globalclass.dart' as globalclass;

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => StartPageState();
}

class StartPageState extends State<StartPage> {
  static const String KEYLOGIN = "login";
  static const String ADMINLOGIN = "adminlogin";
  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    whereToGo();
  }

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('assets/images/music.png'),
                  height: 250,
                  width: 250,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              "Developed By Snehasis",
              style: TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void whereToGo() async {
    var sharedPref = await SharedPreferences.getInstance();
    var isLoggedIn = sharedPref.getBool(KEYLOGIN);
    var isAdminLoggedIn = sharedPref.getBool(ADMINLOGIN);

    String id = sharedPref.getString("id") ?? "";
    String name = sharedPref.getString("name") ?? "";
    String phone = sharedPref.getString("phone") ?? "";
    String email = sharedPref.getString("email") ?? "";
    String image = sharedPref.getString("image") ?? "";

    String adminid = sharedPref.getString("adminid") ?? "";
    String adminname = sharedPref.getString("adminname") ?? "";
    String adminphone = sharedPref.getString("adminphone") ?? "";
    String adminemail = sharedPref.getString("adminemail") ?? "";
    String adminimage = sharedPref.getString("adminimage") ?? "";

    Timer(const Duration(seconds: 2), () {
      if (isLoggedIn != null) {
        if (isLoggedIn) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DashBoard(
                    User(id, name, phone, email, image),
                    globalclass.controller.stream),
              ));
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const FirstPage(),
              ));
        }
      } else if (isAdminLoggedIn != null) {
        if (isAdminLoggedIn) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AdminDashboard(
                  Admin(adminid, adminname, adminphone, adminemail, adminimage),
                ),
              ));
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const FirstPage(),
              ));
        }
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const FirstPage(),
            ));
      }
    });
  }
}
