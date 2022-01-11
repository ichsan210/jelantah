import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'; import 'package:jelantah/constants.dart';
import 'package:jelantah/screens/tutorial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UbahTutorial extends StatefulWidget {
  final int idvideo, video_category_id;
  final String judul, deskripsi, url;
  UbahTutorial(
      {required Key key,
      required this.idvideo,
      required this.judul,
      required this.deskripsi,
      required this.url,
      required this.video_category_id})
      : super(key: key);

  @override
  _UbahTutorialState createState() => _UbahTutorialState();
}

class _UbahTutorialState extends State<UbahTutorial> {
  late String judul, url, deskripsi;
  final _key = new GlobalKey<FormState>();

  check() {
    print("jalan");
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      editVideo();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        // width: kIsWeb ? 500.0 : double.infinity,
        child: Scaffold(
          appBar: AppBar(
              titleSpacing: 0,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.blue,
                icon: Icon(
                  Icons.keyboard_arrow_left,
                  size: 30,
                ),
              ),
              title: Text(
                "Ubah Video",
                style: TextStyle(
                  color: Colors.blue, // 3
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0.0),
          body: Padding(
            padding: EdgeInsets.all(30.0),
            child: Form(
              key: _key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Kategori',
                          style: TextStyle(color: Colors.blue),
                        ),
                        Container(
                          child: TextFormField(
                            enabled: false,
                            //onSaved: (e) => email = e,
                            initialValue: "Edukasi",
                            decoration: InputDecoration(
                              hintText: "Pilih Kategori",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Judul',
                          style: TextStyle(color: Colors.blue),
                        ),
                        Container(
                          child: TextFormField(
                            validator: (e) {
                              if (e!.isEmpty) {
                                return "Masukan Judul video!";
                              }
                            },
                            onSaved: (e) => judul = e!,
                            initialValue: widget.judul,
                            decoration: InputDecoration(
                              hintText: "Masukan Judul",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Link Youtube',
                          style: TextStyle(color: Colors.blue),
                        ),
                        Container(
                          child: TextFormField(
                            onSaved: (e) => url = e!,
                            initialValue: widget.url,
                            decoration: InputDecoration(
                              hintText: "Masukan Link Youtube",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Deskripsi',
                          style: TextStyle(color: Colors.blue),
                        ),
                        Container(
                          child: TextFormField(
                            onSaved: (e) => deskripsi = e!,
                            initialValue: widget.deskripsi,
                            decoration: InputDecoration(
                              hintText: "Masukan Deskripsi",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextButton(
                              onPressed: () {
                                showAlertDialog2(context);
                              },
                              child: Text('Hapus',
                                  style: TextStyle(color: Colors.white))),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color(0xff2f9efc),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextButton(
                              onPressed: () {
                                showAlertDialog(context);
                              },
                              child: Text('Simpan',
                                  style: TextStyle(color: Colors.white))),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Tidak"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Ya"),
      onPressed: () {
        check();
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (c, a1, a2) => Tutorial(),
            transitionsBuilder: (c, anim, a2, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: Duration(milliseconds: 300),
          ),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Konfirmasi"),
      content: Text("Simpan video ini?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  String? convertUrlToId(String url, {bool trimWhitespaces = true}) {
    if (!url.contains("http") && (url.length == 11)) return url;
    if (trimWhitespaces) url = url.trim();

    for (var exp in [
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$")
    ]) {
      Match? match = exp.firstMatch(url);
      if (match != null && match.groupCount >= 1) return match.group(1);
    }
    return null;
  }

  editVideo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token");
    int id = widget.idvideo;
    String? videoId = convertUrlToId(url);
    Map bodi = {
      "token": token,
      "show_on_user": true,
      "show_on_driver": true,
      "name": judul,
      "description":deskripsi,
      "youtube_link":videoId,
      "video_category_id":1
    };
    var body = json.encode(bodi);
    final response = await http.post(
      Uri.parse("$kIpAddress/api/admin/videos/$id/put"),
      body: body,
    );
    final data = jsonDecode(response.body);
    print(data);
    print(token);
    print(judul);
    print(id);
  }

  void showAlertDialog2(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Tidak"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Ya"),
      onPressed: () {
        delete();
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (c, a1, a2) => Tutorial(),
            transitionsBuilder: (c, anim, a2, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: Duration(milliseconds: 300),
          ),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Konfirmasi"),
      content: Text("Konfirmasi hapus video?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  delete() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token");
    int id = widget.idvideo;
    Map bodi = {
      "token": token,
    };
    var body = json.encode(bodi);
    final response = await http.post(
      Uri.parse("$kIpAddress/api/admin/videos/$id/delete"),
      body: body,
    );
    final data = jsonDecode(response.body);
    print(data);
  }
}
