import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jelantah/screens/tutorial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jelantah/screens/tambah_tutorial_berhasil.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TambahTutorial extends StatefulWidget {
  @override
  _TambahTutorialState createState() => _TambahTutorialState();
}

class _TambahTutorialState extends State<TambahTutorial> {
  var _token;
  late String name, description, youtube_link, video_category_id;
  final _key = new GlobalKey<FormState>();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    print("jalan");
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      save();
    }
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

  save() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _token = preferences.getString("token");
    print("tambah " + _token);
    String? videoId = convertUrlToId(youtube_link);
    print(videoId);
    Map bodi = {
      "token": _token,
      "show_on_user": true,
      "show_on_driver": true,
      "name": name,
      "description": description,
      "youtube_link": videoId,
      "video_category_id": 1,
    };
    var body = json.encode(bodi);
    final response = await http.post(
      Uri.parse("http://127.0.0.1:8000/api/admin/videos/post"),
      body: body,
    );
    final data = jsonDecode(response.body);
    String status = data['status'];
    String message = data['message'];
    if (status == "success") {
      setState(() {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Tutorial()));
      });
    } else {
      print(message);
    }
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(
      () {
        _token = preferences.getString("token");
        // _token = (preferences.getString('token') ?? '');
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    getPref();
    super.initState();
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
                "Tambah Video",
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
                            initialValue: "Edukasi",
                            validator: (e) {
                              if (e!.isEmpty) {
                                return "Please insert email";
                              }
                            },
                            onSaved: (e) => video_category_id = e!,
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
                                return "Please insert email";
                              }
                            },
                            onSaved: (e) => name = e!,
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
                            validator: (e) {
                              if (e!.isEmpty) {
                                return "Please insert email";
                              }
                            },
                            onSaved: (e) => youtube_link = e!,
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
                            validator: (e) {
                              if (e!.isEmpty) {
                                return "Please insert email";
                              }
                            },
                            onSaved: (e) => description = e!,
                            decoration: InputDecoration(
                              hintText: "Masukan Deskripsi",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // MaterialButton(
                  //   onPressed: () {
                  //     check();
                  //   },
                  //   child: Text("Unggah"),
                  // ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xff2f9efc),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                        onPressed: () {
                          check();
                        },
                        child: Text('Unggah',
                            style:
                            TextStyle(color: Colors.white))),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
