// @dart=2.9

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'; import 'package:jelantah/constants.dart';
import 'package:intl/intl.dart';
import 'package:jelantah/screens/tambah_tutorial.dart';
import 'package:jelantah/screens/ubah_tutorial.dart';
import 'package:jelantah/screens/login_page.dart';
import 'package:jelantah/screens/historis.dart';
import 'package:jelantah/screens/chat_list.dart';
import 'package:jelantah/screens/tutorial.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Tutorial extends StatefulWidget {

  @override
  _TutorialState createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  var url = ["https://www.youtube.com/watch?v=LvUYbxlSGHw","https://www.youtube.com/watch?v=LvUYbxlSGHw","https://www.youtube.com/watch?v=LvUYbxlSGHw"];
  var idyoutube = ["LvUYbxlSGHw","LvUYbxlSGHw","LvUYbxlSGHw","8XYqZgntKr0"];
  var judul = ["judul1","judul2","judul3"];
  var deskripsi = ["youtube1","youtube1","youtube1"];
  var tanggal = ["10 Oktober 2021","10 Oktober 2021","10 Oktober 2021"];

  int _selectedNavbar = 3;
  var _token;
  var i;

  var idvideo = new List();
  var title_video = new List();
  var description = new List();
  var youtube_link = new List();
  var video_category_id = new List();
  var date = new List();

  List _isikategori =  ["Edukasi"];
  List<DropdownMenuItem<String>> _dropdownKategori;
  String _kategoriterpilih;

  var id = new List();
  var name = new List();

  get_kategori() async {
    Map bodi = {"token": _token};
    var body = json.encode(bodi);
    final response = await http.post(
      Uri.parse("$kIpAddress/api/admin/video_categories/get"),
      body: body,
    );
    final data = jsonDecode(response.body);
    for (i = 0; i < data['video_categories'].length; i++) {
        setState(() {
          id.add(data['video_categories'][i]['id']);
          name.add(data['video_categories'][i]['name']);
        });
    }
    // print(data);
    // print(name);
  }

  get_video() async {
    Map bodi = {"token": _token, "video_category_id":1};
    var body = json.encode(bodi);
    final response = await http.post(
      Uri.parse("$kIpAddress/api/admin/videos/get"),
      body: body,
    );
    final data = jsonDecode(response.body);
    for (i = 0; i < data['videos'].length; i++) {
      var tanggal = data['videos'][i]['updated_at'];
      setState(() {
        idvideo.add(data['videos'][i]['id']);
        title_video.add(data['videos'][i]['name']);
        description.add(data['videos'][i]['description']);
        youtube_link.add(data['videos'][i]['youtube_link']);
        video_category_id.add(data['videos'][i]['video_category_id']);
        date.add(formatTanggal(tanggal));
      });
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
    get_kategori();
    get_video();
  }

  @override
  void initState() {
    super.initState();
    getPref();
    _dropdownKategori = getDropdownKategori();
    _kategoriterpilih = _dropdownKategori[0].value;
  }

  List<DropdownMenuItem<String>> getDropdownKategori() {
    List<DropdownMenuItem<String>> items = [];
    for (String kategori in _isikategori) {
      items.add(new DropdownMenuItem(
          value: kategori,
          child: new Text(kategori)
      ));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Container(
        // width: kIsWeb ? 500.0 : double.infinity,
        child: DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
                titleSpacing: 0,
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => LoginPage()));
                  },
                  color: Colors.blue,
                  icon: Icon(Icons.keyboard_arrow_left, size: 30,),
                ),
                title: Text(
                  "Kelola Video",
                  style: TextStyle(
                    color: Colors.blue, // 3
                  ),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0.0),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
                  alignment:Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ButtonTheme(
                    alignedDropdown: true,
                    padding: EdgeInsets.only(left: 50),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        isExpanded: true,
                        value: _kategoriterpilih,
                        items: _dropdownKategori,
                        onChanged: changedropdownKategori,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Scrollbar(
                    showTrackOnHover: true,
                    isAlwaysShown: true,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          for (var i = 0; i < idvideo.length; i++)
                            RC_Video(
                                idvideo : idvideo[i],
                                url: youtube_link[i],
                                idyoutube: youtube_link[i],
                                video_category_id: video_category_id[i],
                                judul: title_video[i],
                                deskripsi: description[i],
                                tanggal: date[i]),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        TambahTutorial()));
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }

  void changedropdownKategori(String kategoriTerpilih) {
    setState(() {
      _kategoriterpilih = kategoriTerpilih;
    });
  }

  formatTanggal(tanggal) {
    var datestring = tanggal.toString();
    DateTime parseDate =
    new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(datestring);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat("d MMMM yyyy","id_ID");
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }
}

class RC_Video extends StatelessWidget {
  RC_Video(
      { this.url,
         this.idyoutube,
         this.judul,
         this.deskripsi,
         this.tanggal,
         this.idvideo, this.video_category_id});

  String url, idyoutube, judul, deskripsi, tanggal;
  int idvideo, video_category_id;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                UbahTutorial(idvideo: idvideo, judul:judul, url:"https://www.youtube.com/watch?v="+url, deskripsi:deskripsi, video_category_id:video_category_id )));
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image:
                  NetworkImage("https://img.youtube.com/vi/$idyoutube/0.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tanggal,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
                Container(
                  width: 300,
                  child: Row(
                    children: [
                      Flexible(
                        child: new Text(
                          judul,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),)
                    ],
                  ),
                ),
                Container(
                  width: 300,
                  child: Row(
                    children: [
                      Flexible(
                        child: new Text(
                          deskripsi,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),)
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


