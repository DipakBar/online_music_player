import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_music_player/models/admindetails.dart';
import 'package:http/http.dart' as http;
import 'package:online_music_player/models/myurl.dart';
import 'package:online_music_player/pages/loadingdialog.dart';
import 'package:online_music_player/pages/startpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminProfile extends StatefulWidget {
  // const AdminProfile({super.key});
  Admin admin;
  AdminProfile(this.admin);

  @override
  State<AdminProfile> createState() => _AdminProfileState(admin);
}

class _AdminProfileState extends State<AdminProfile> {
  Admin admin;
  _AdminProfileState(this.admin);
  String i = '';
  GlobalKey<FormState> adminnamekey = GlobalKey();
  GlobalKey<FormState> adminphonekey = GlobalKey();
  GlobalKey<FormState> adminemailkey = GlobalKey();
  TextEditingController _adminname = TextEditingController();
  TextEditingController _adminphone = TextEditingController();
  TextEditingController _adminemail = TextEditingController();

  File? pickedImage;
  Future pickImage(ImageSource imageType) async {
    try {
      final photo =
          await ImagePicker().pickImage(source: imageType, imageQuality: 50);
      if (photo != null) {
        final tempImage = File(photo.path);
        setState(() {
          pickedImage = tempImage;
        });
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future createprofile(File photo, String id) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const LoadingDialog();
      },
    );

    try {
      var request = http.MultipartRequest(
          "POST", Uri.parse(MyUrl.fullurl + "admin_image_update.php"));
      request.files.add(await http.MultipartFile.fromBytes(
          'image', photo.readAsBytesSync(),
          filename: photo.path.split("/").last));
      request.fields['id'] = id;

      var response = await request.send();

      var responded = await http.Response.fromStream(response);
      var jsondata = jsonDecode(responded.body);
      if (jsondata['status'] == 'true') {
        var sharedPref = await SharedPreferences.getInstance();
        sharedPref.setString("adminimage", jsondata["imgtitle"]);
        admin.image = jsondata["imgtitle"];

        setState(() {
          i = jsondata["imgtitle"];
        });

        Navigator.pop(context);
        Fluttertoast.showToast(
          gravity: ToastGravity.CENTER,
          msg: jsondata['msg'],
        );
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(
          gravity: ToastGravity.CENTER,
          msg: jsondata['msg'],
        );
      }
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(
        gravity: ToastGravity.CENTER,
        msg: e.toString(),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    x().whenComplete(() {
      setState(() {});
    });
    super.initState();
  }

  Future x() async {
    var sharedPref = await SharedPreferences.getInstance();
    i = sharedPref.getString("adminimage") ?? '';
  }

  Future<void> updatename(String name) async {
    Map data = {'id': admin.id, 'name': name};
    var sharedPref = await SharedPreferences.getInstance();
    if (adminnamekey.currentState!.validate()) {
      showDialog(
          context: context,
          builder: (context) {
            return const LoadingDialog();
          });
      try {
        var res = await http.post(
            Uri.http(MyUrl.mainurl, MyUrl.suburl + "admin_name_update.php"),
            body: data);

        var jsondata = jsonDecode(res.body);
        if (jsondata['status'] == true) {
          Navigator.of(context).pop();
          Navigator.pop(context);
          setState(() {
            sharedPref.setString("adminname", jsondata["name"]);
            admin.name = jsondata["name"];
          });

          Fluttertoast.showToast(
            msg: jsondata['msg'],
          );
        } else {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Fluttertoast.showToast(
            msg: jsondata['msg'],
          );
        }
      } catch (e) {
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: e.toString());
      }
    }
  }

  Future<void> updatephone(String phone) async {
    Map data = {'id': admin.id, 'phone': phone};
    var sharedPref = await SharedPreferences.getInstance();
    if (adminphonekey.currentState!.validate()) {
      showDialog(
          context: context,
          builder: (context) {
            return const LoadingDialog();
          });
      try {
        var res = await http.post(
            Uri.http(MyUrl.mainurl, MyUrl.suburl + "admin_phone_update.php"),
            body: data);

        var jsondata = jsonDecode(res.body);
        if (jsondata['status'] == true) {
          Navigator.of(context).pop();
          Navigator.pop(context);
          setState(() {
            sharedPref.setString("adminphone", jsondata["phone"]);
            admin.phone = jsondata["phone"];
          });

          Fluttertoast.showToast(
            msg: jsondata['msg'],
          );
        } else {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Fluttertoast.showToast(
            msg: jsondata['msg'],
          );
        }
      } catch (e) {
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: e.toString());
      }
    }
  }

  Future<void> updateemail(String email) async {
    Map data = {'id': admin.id, 'email': email};
    var sharedPref = await SharedPreferences.getInstance();
    if (adminemailkey.currentState!.validate()) {
      showDialog(
          context: context,
          builder: (context) {
            return const LoadingDialog();
          });
      try {
        var res = await http.post(
            Uri.http(MyUrl.mainurl, MyUrl.suburl + "admin_email_update.php"),
            body: data);

        var jsondata = jsonDecode(res.body);
        if (jsondata['status'] == true) {
          Navigator.of(context).pop();
          Navigator.pop(context);
          setState(() {
            sharedPref.setString("adminemail", jsondata["email"]);
            admin.email = jsondata["email"];
          });

          Fluttertoast.showToast(
            msg: jsondata['msg'],
          );
        } else {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Fluttertoast.showToast(
            msg: jsondata['msg'],
          );
        }
      } catch (e) {
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Profile Information",
            style: TextStyle(fontSize: 20),
          ),
          backgroundColor: const Color.fromARGB(255, 1, 167, 189),
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(30),
                                  ),
                                ),
                                builder: (BuildContext context) {
                                  return SizedBox(
                                    height: 150,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            MaterialButton(
                                              minWidth: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: const Text(
                                                "View profile photo",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.black),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                showFullImageDialog();
                                              },
                                            ),
                                            MaterialButton(
                                                minWidth: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  showGeneralDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    transitionDuration:
                                                        const Duration(
                                                            milliseconds: 400),
                                                    pageBuilder: (context,
                                                        animation1,
                                                        animation2) {
                                                      return Container();
                                                    },
                                                    transitionBuilder: (context,
                                                        a1, a2, Widget) {
                                                      return ScaleTransition(
                                                        scale: Tween<double>(
                                                                begin: 0.5,
                                                                end: 1.0)
                                                            .animate(a1),
                                                        child: FadeTransition(
                                                          opacity:
                                                              Tween<double>(
                                                                      begin:
                                                                          0.5,
                                                                      end: 1.0)
                                                                  .animate(a1),
                                                          child: AlertDialog(
                                                            shape: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30),
                                                                borderSide:
                                                                    BorderSide
                                                                        .none),
                                                            title: const Text(
                                                              "Choose Profile Photo From",
                                                              style: TextStyle(
                                                                  fontSize: 23,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            ),
                                                            content:
                                                                SingleChildScrollView(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  TextButton
                                                                      .icon(
                                                                    icon:
                                                                        const Icon(
                                                                      Icons
                                                                          .camera_alt_rounded,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                    label:
                                                                        const Text(
                                                                      'Camera',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight:
                                                                              FontWeight.normal),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                      pickImage(
                                                                              ImageSource.camera)
                                                                          .whenComplete(
                                                                        () {
                                                                          if (pickedImage !=
                                                                              null) {
                                                                            createprofile(pickedImage!,
                                                                                admin.id);
                                                                          }
                                                                        },
                                                                      );
                                                                    },
                                                                  ),
                                                                  TextButton
                                                                      .icon(
                                                                    icon:
                                                                        const Icon(
                                                                      Icons
                                                                          .photo,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                    label:
                                                                        const Text(
                                                                      ' Gallery',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight:
                                                                              FontWeight.normal),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                      pickImage(
                                                                              ImageSource.gallery)
                                                                          .whenComplete(
                                                                        () {
                                                                          if (pickedImage !=
                                                                              null) {
                                                                            createprofile(pickedImage!,
                                                                                admin.id);
                                                                          }
                                                                        },
                                                                      );
                                                                    },
                                                                  ),
                                                                  TextButton
                                                                      .icon(
                                                                    icon:
                                                                        const Icon(
                                                                      Icons
                                                                          .close,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                    label:
                                                                        const Text(
                                                                      ' Cancel',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight:
                                                                              FontWeight.normal),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                child: const Text(
                                                  "Select profile photo",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.black),
                                                ))
                                          ]),
                                    ),
                                  );
                                });
                          },
                          child: CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.grey,
                            child: pickedImage != null
                                ? ClipOval(
                                    child: Image.file(
                                      pickedImage!,
                                      height: 135,
                                      width: 135,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: MyUrl.fullurl +
                                          MyUrl.imageurl +
                                          admin.image,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      imageBuilder: (context, imageProvider) {
                                        return Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                                image: DecorationImage(
                                                    image: imageProvider)),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: 3,
                          right: 10,
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.black, shape: BoxShape.circle),
                            child: InkWell(
                              onTap: () {
                                showGeneralDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  transitionDuration:
                                      const Duration(milliseconds: 400),
                                  pageBuilder:
                                      (context, animation1, animation2) {
                                    return Container();
                                  },
                                  transitionBuilder: (context, a1, a2, Widget) {
                                    return ScaleTransition(
                                      scale: Tween<double>(begin: 0.5, end: 1.0)
                                          .animate(a1),
                                      child: FadeTransition(
                                        opacity:
                                            Tween<double>(begin: 0.5, end: 1.0)
                                                .animate(a1),
                                        child: AlertDialog(
                                          shape: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              borderSide: BorderSide.none),
                                          title: const Text(
                                            "Choose Profile Photo From",
                                            style: TextStyle(
                                                fontSize: 23,
                                                fontWeight: FontWeight.normal),
                                          ),
                                          content: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                TextButton.icon(
                                                  icon: const Icon(
                                                    Icons.camera_alt_rounded,
                                                    color: Colors.black,
                                                  ),
                                                  label: const Text(
                                                    'Camera',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    pickImage(
                                                            ImageSource.camera)
                                                        .whenComplete(
                                                      () {
                                                        if (pickedImage !=
                                                            null) {
                                                          createprofile(
                                                              pickedImage!,
                                                              admin.id);
                                                        }
                                                      },
                                                    );
                                                  },
                                                ),
                                                TextButton.icon(
                                                  icon: const Icon(
                                                    Icons.photo,
                                                    color: Colors.black,
                                                  ),
                                                  label: const Text(
                                                    ' Gallery',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);

                                                    pickImage(
                                                            ImageSource.gallery)
                                                        .whenComplete(
                                                      () {
                                                        if (pickedImage !=
                                                            null) {
                                                          createprofile(
                                                              pickedImage!,
                                                              admin.id);
                                                        }
                                                      },
                                                    );
                                                  },
                                                ),
                                                TextButton.icon(
                                                  icon: const Icon(
                                                    Icons.close,
                                                    color: Colors.black,
                                                  ),
                                                  label: const Text(
                                                    ' Cancel',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: const Icon(
                                CupertinoIcons.camera_circle_fill,
                                color: Colors.white,
                                size: 35,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 5),
                              color: Colors.deepOrange.withOpacity(.2),
                              spreadRadius: 2,
                              blurRadius: 10)
                        ]),
                    child: ListTile(
                      title: const Text('Name'),
                      subtitle: Text(admin.name),
                      leading: const Icon(CupertinoIcons.person),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _adminname.text = admin.name;
                          showGeneralDialog(
                            context: context,
                            barrierDismissible: false,
                            transitionDuration:
                                const Duration(milliseconds: 400),
                            pageBuilder: (context, animation1, animation2) {
                              return Container();
                            },
                            transitionBuilder: (context, a1, a2, Widget) {
                              return ScaleTransition(
                                scale: Tween<double>(begin: 0.5, end: 1.0)
                                    .animate(a1),
                                child: FadeTransition(
                                  opacity: Tween<double>(begin: 0.5, end: 1.0)
                                      .animate(a1),
                                  child: AlertDialog(
                                      shape: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          borderSide: BorderSide.none),
                                      content: Form(
                                        key: adminnamekey,
                                        child: TextFormField(
                                          controller: _adminname,
                                          keyboardType: TextInputType.name,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          decoration: const InputDecoration(
                                            labelText: "Name",
                                            hintText: "Enter your Full Name",
                                            prefixIcon:
                                                Icon(CupertinoIcons.person),
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Name Required";
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              "Cancel",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 15),
                                            )),
                                        TextButton(
                                            onPressed: () {
                                              if (adminnamekey.currentState!
                                                  .validate()) {
                                                updatename(_adminname.text);
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Please Enter Your Name");
                                              }
                                            },
                                            child: const Text(
                                              "Save",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ))
                                      ]),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      tileColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 5),
                              color: Colors.deepOrange.withOpacity(.2),
                              spreadRadius: 2,
                              blurRadius: 10)
                        ]),
                    child: ListTile(
                      title: Text('Phone'),
                      subtitle: Text(admin.phone),
                      leading: Icon(CupertinoIcons.phone),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _adminphone.text = admin.phone;
                          showGeneralDialog(
                            context: context,
                            barrierDismissible: false,
                            transitionDuration:
                                const Duration(milliseconds: 400),
                            pageBuilder: (context, animation1, animation2) {
                              return Container();
                            },
                            transitionBuilder: (context, a1, a2, Widget) {
                              return ScaleTransition(
                                scale: Tween<double>(begin: 0.5, end: 1.0)
                                    .animate(a1),
                                child: FadeTransition(
                                  opacity: Tween<double>(begin: 0.5, end: 1.0)
                                      .animate(a1),
                                  child: AlertDialog(
                                      shape: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          borderSide: BorderSide.none),
                                      content: Form(
                                        key: adminphonekey,
                                        child: TextFormField(
                                          controller: _adminphone,
                                          keyboardType: TextInputType.phone,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          decoration: InputDecoration(
                                            labelText: "Phone No",
                                            hintText: "Enter your Phone Number",
                                            prefixIcon:
                                                Icon(CupertinoIcons.phone),
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Phone no Required";
                                            } else if (value.length < 10) {
                                              return "Please enter valid phone";
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Cancel",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 15),
                                            )),
                                        TextButton(
                                            onPressed: () {
                                              if (adminphonekey.currentState!
                                                  .validate()) {
                                                updatephone(_adminphone.text);
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Please Enter Your Phone Number");
                                              }
                                            },
                                            child: Text(
                                              "Save",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ))
                                      ]),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      tileColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 5),
                              color: Colors.deepOrange.withOpacity(.2),
                              spreadRadius: 2,
                              blurRadius: 10)
                        ]),
                    child: ListTile(
                      title: Text('Email'),
                      subtitle: Text(admin.email),
                      leading: Icon(CupertinoIcons.mail),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _adminemail.text = admin.email;
                          showGeneralDialog(
                            context: context,
                            barrierDismissible: false,
                            transitionDuration:
                                const Duration(milliseconds: 400),
                            pageBuilder: (context, animation1, animation2) {
                              return Container();
                            },
                            transitionBuilder: (context, a1, a2, Widget) {
                              return ScaleTransition(
                                scale: Tween<double>(begin: 0.5, end: 1.0)
                                    .animate(a1),
                                child: FadeTransition(
                                  opacity: Tween<double>(begin: 0.5, end: 1.0)
                                      .animate(a1),
                                  child: AlertDialog(
                                      shape: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          borderSide: BorderSide.none),
                                      content: Form(
                                        key: adminemailkey,
                                        child: TextFormField(
                                          controller: _adminemail,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          decoration: InputDecoration(
                                            labelText: "Email",
                                            hintText:
                                                "Enter your Email Address",
                                            prefixIcon:
                                                Icon(CupertinoIcons.mail),
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Email Required";
                                            } else if (!RegExp(
                                                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{3,4}$')
                                                .hasMatch(value)) {
                                              return "Please enter valid email";
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Cancel",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 15),
                                            )),
                                        TextButton(
                                            onPressed: () {
                                              if (adminemailkey.currentState!
                                                  .validate()) {
                                                updateemail(_adminemail.text);
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Please Enter Your Email Id");
                                              }
                                            },
                                            child: Text(
                                              "Save",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ))
                                      ]),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      tileColor: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    child: ElevatedButton(
                      onPressed: () {
                        showGeneralDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierLabel: '',
                          transitionDuration: const Duration(milliseconds: 400),
                          pageBuilder: (context, animation1, animation2) {
                            return Container();
                          },
                          transitionBuilder: (context, a1, a2, Widget) {
                            return ScaleTransition(
                              scale: Tween<double>(begin: 0.5, end: 1.0)
                                  .animate(a1),
                              child: FadeTransition(
                                opacity: Tween<double>(begin: 0.5, end: 1.0)
                                    .animate(a1),
                                child: AlertDialog(
                                  title: const Text('Are You Sure?'),
                                  content: const Text('Do you want to logout?'),
                                  shape: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide.none),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        'No',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        var sharedPref = await SharedPreferences
                                            .getInstance();
                                        sharedPref.clear();
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const StartPage()),
                                            (Route<dynamic> route) => false);
                                      },
                                      child: const Text(
                                        "Yes",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'Log Out',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.red),
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showFullImageDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Container(
          color: Colors.transparent,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
            child: Dialog(
              backgroundColor: Colors.transparent,
              child: Center(
                child: CachedNetworkImage(
                  imageUrl: MyUrl.fullurl + MyUrl.imageurl + admin.image,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          image: DecorationImage(image: imageProvider)),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
