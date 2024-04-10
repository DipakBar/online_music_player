import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:online_music_player/admin/admin_profile.dart';
import 'package:online_music_player/models/admindetails.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:online_music_player/models/alluser.dart';
import 'package:online_music_player/models/globalclass.dart' as globalclass;
import 'package:online_music_player/models/myurl.dart';
import 'package:online_music_player/models/song_fetch.dart';
import 'package:online_music_player/pages/loadingdialog.dart';

class AdminDashboard extends StatefulWidget {
  Admin admin;
  AdminDashboard(this.admin);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState(admin);
}

class _AdminDashboardState extends State<AdminDashboard> {
  GlobalKey<FormState> form = GlobalKey();
  TextEditingController title = TextEditingController();
  TextEditingController singer = TextEditingController();
  TextEditingController genre = TextEditingController();
  TextEditingController duration = TextEditingController();
  TextEditingController fileformat = TextEditingController();
  TextEditingController lyrics = TextEditingController();
  TextEditingController file = TextEditingController();
  TextEditingController image = TextEditingController();

  Admin admin;
  _AdminDashboardState(this.admin);

  File? pickedImage;
  File? pickedFile;

  List<AllUser> users = [];

  pickImage() async {
    try {
      FilePickerResult? photo = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );
      if (photo == null) return;
      File tempImage = File(photo.files.single.path!);
      setState(() {
        pickedImage = tempImage;
        var pickname = photo.files.single.name;
        image.text = pickname.toString();
      });
      Get.back();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'wav', 'flac'],
      );
      if (result == null) return;
      File tempFile = File(result.files.single.path!);
      setState(() {
        pickedFile = tempFile;
        var pickName = result.files.single.name;
        file.text = pickName.toString();
      });
      Get.back();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future upload(String title, String singer, String genre, String duration,
      String fileformat, File? filepath, File? image, String lyrics) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const LoadingDialog();
      },
    );
    try {
      var request = http.MultipartRequest(
          "POST", Uri.parse(MyUrl.fullurl + "song_upload.php"));

      request.fields['title'] = title;
      request.fields['singer'] = singer;
      request.fields['genre'] = genre;
      request.fields['duration'] = duration;
      request.fields['file_format'] = fileformat;

      request.files.add(await http.MultipartFile.fromBytes(
          'file_path', filepath!.readAsBytesSync(),
          filename: filepath.path.split("/").last));

      request.files.add(await http.MultipartFile.fromBytes(
          'image', image!.readAsBytesSync(),
          filename: image.path.split("/").last));

      request.fields['lyrics'] = lyrics;

      var response = await request.send();
      var responded = await http.Response.fromStream(response);
      var jsondata = jsonDecode(responded.body);

      if (jsondata['status'] == true) {
        Fluttertoast.showToast(
          gravity: ToastGravity.CENTER,
          msg: jsondata['msg'],
        );
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
          gravity: ToastGravity.CENTER,
          msg: jsondata['msg'],
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        gravity: ToastGravity.CENTER,
        msg: e.toString(),
      );
    }
  }

  Future getData() async {
    try {
      var response = await http.get(
        Uri.parse("${MyUrl.fullurl}get_song.php"),
      );
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200) {
        globalclass.musics.clear();
        for (int i = 0; i < jsondata['data'].length; i++) {
          Music music = Music(
            id: jsondata['data'][i]['id'],
            title: jsondata['data'][i]['title'],
            singer: jsondata['data'][i]['singer'],
            genre: jsondata['data'][i]['genre'],
            duration: jsondata['data'][i]['duration'],
            filepath: jsondata['data'][i]['file_path'],
            image: jsondata['data'][i]['image'],
            lyrics: jsondata['data'][i]['lyrics'],
          );
          globalclass.musics.add(music);
        }
      }
      return globalclass.musics;
    } catch (e) {
      print(e);
    }
  }

  Future getUser() async {
    try {
      var response = await http.get(
        Uri.parse("${MyUrl.fullurl}get_user.php"),
      );
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200) {
        users.clear();
        for (int i = 0; i < jsondata['data'].length; i++) {
          AllUser user = AllUser(
            jsondata['data'][i]['id'],
            jsondata['data'][i]['name'],
            jsondata['data'][i]['phone'],
            jsondata['data'][i]['email'],
            jsondata['data'][i]['password'],
            jsondata['data'][i]['image'],
          );
          users.add(user);
        }
      }
      return users;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 1, 167, 189),
            title: const Text('Admin Panel'),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {
                    Get.to(() => AdminProfile(admin),
                        transition: Transition.rightToLeftWithFade);
                  },
                  icon: const Icon(Icons.person))
            ],
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(70),
              child: TabBar(
                tabs: [
                  Tab(text: 'All Songs'),
                  Tab(text: 'All Users'),
                  Tab(text: 'Upload'),
                ],
                indicatorColor: Color.fromARGB(255, 143, 228, 220),
                unselectedLabelColor: Colors.black,
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                splashFactory: NoSplash.splashFactory,
              ),
            ),
          ),
          body: SafeArea(
            child: TabBarView(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: FutureBuilder(
                            builder:
                                (BuildContext context, AsyncSnapshot data) {
                              if (data.hasData) {
                                return ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemCount: globalclass.musics.length,
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 5),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: 35,
                                          child: CachedNetworkImage(
                                            imageUrl: MyUrl.fullurl +
                                                globalclass.musics[index].image,
                                            placeholder: (context, url) =>
                                                const Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                            imageBuilder:
                                                (context, imageProvider) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white,
                                                    image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover)),
                                              );
                                            },
                                          ),
                                        ),
                                        title: Text(
                                            globalclass.musics[index].title),
                                        subtitle: Text(
                                            globalclass.musics[index].singer),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 250),
                                  child: CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.blue),
                                  ),
                                );
                              }
                            },
                            future: getData(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: FutureBuilder(
                            builder:
                                (BuildContext context, AsyncSnapshot data) {
                              if (data.hasData) {
                                return ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemCount: users.length,
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 5),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: 35,
                                          child: CachedNetworkImage(
                                            imageUrl: MyUrl.fullurl +
                                                MyUrl.imageurl +
                                                users[index].image,
                                            placeholder: (context, url) =>
                                                const Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                            imageBuilder:
                                                (context, imageProvider) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white,
                                                    image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.contain)),
                                              );
                                            },
                                          ),
                                        ),
                                        title: Text(users[index].name),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                "Phone: ${users[index].phone}"),
                                            Text(
                                                "Password: ${users[index].password}"),
                                            Text(
                                                "Email: ${users[index].email}"),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 250),
                                  child: CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.blue),
                                  ),
                                );
                              }
                            },
                            future: getUser(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Form(
                    key: form,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextFormField(
                              controller: title,
                              keyboardType: TextInputType.name,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Title Required";
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                labelText: "Title",
                                hintText: "Enter the Song Title",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(28)),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: singer,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Singer Required";
                                } else {
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                labelText: "Singer",
                                hintText: "Enter the Singer Name",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(28)),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: genre,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Genre Required";
                                } else {
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                labelText: "Genre",
                                hintText: "Enter the Genre",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(28)),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: duration,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Duration Required";
                                } else {
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: "Duration",
                                hintText: "Enter the Song Duration",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(28)),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: fileformat,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "File Format Required";
                                } else {
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                labelText: "File Format",
                                hintText: "Enter the File Format",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(28)),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: lyrics,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Lyrics Required";
                                } else {
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                labelText: "Lyrics",
                                hintText: "Enter the Song Lyrics",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(28)),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () {
                                pickFile();
                              },
                              child: Container(
                                height: 70,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1.0, color: Colors.black),
                                    borderRadius: BorderRadius.circular(28)),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: TextFormField(
                                      controller: file,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          Fluttertoast.showToast(
                                              msg: 'Choose Song');
                                        } else {
                                          return null;
                                        }
                                      },
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      keyboardType: TextInputType.name,
                                      enabled: false,
                                      decoration: const InputDecoration(
                                          labelText: "Choose a Song",
                                          hintText: "Choose a Song",
                                          suffixIcon: Icon(Icons.upload)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () {
                                pickImage();
                              },
                              child: Container(
                                height: 70,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1.0, color: Colors.black),
                                    borderRadius: BorderRadius.circular(28)),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: TextFormField(
                                      controller: image,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          Fluttertoast.showToast(
                                              msg: 'Choose Song Image');
                                        } else {
                                          return null;
                                        }
                                      },
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      keyboardType: TextInputType.name,
                                      enabled: false,
                                      decoration: const InputDecoration(
                                          labelText: "Choose Song Image",
                                          hintText: "Choose Song Image",
                                          suffixIcon: Icon(Icons.image)),
                                    ),
                                  ),
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
                                    if (form.currentState!.validate()) {
                                      upload(
                                          title.text,
                                          singer.text,
                                          genre.text,
                                          duration.text,
                                          fileformat.text,
                                          pickedFile,
                                          pickedImage,
                                          lyrics.text);
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "Please Enter All Details");
                                    }
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => Colors.blue),
                                    shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                    child: Text(
                                      'Upload',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
