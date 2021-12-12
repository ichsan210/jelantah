// @dart=2.9
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jelantah/screens/permintaan_penjemputan.dart';
import 'package:jelantah/screens/user_baru.dart';
import 'package:jelantah/screens/setting_data_master.dart';
import 'package:jelantah/screens/account.dart';
import 'package:jelantah/screens/login_page.dart';
import 'package:jelantah/screens/historis.dart';
import 'package:jelantah/screens/chat_list.dart';
import 'package:jelantah/screens/tutorial.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:jelantah/screens/ubah_tutorial.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:jelantah/screens/tutorial.dart';
import 'package:jelantah/screens/login_page.dart';

class Dashboard extends StatefulWidget {
  final VoidCallback signOut;

  Dashboard(this.signOut);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var url = [
    "https://www.youtube.com/watch?v=LvUYbxlSGHw",
    "https://www.youtube.com/watch?v=LvUYbxlSGHw",
    "https://www.youtube.com/watch?v=LvUYbxlSGHw"
  ];
  var idyoutube = ["LvUYbxlSGHw", "LvUYbxlSGHw", "LvUYbxlSGHw","8XYqZgntKr0"];
  var judul = [
    "Semua yang perlu kamu ketahui, Jelantah App",
    "judul2",
    "judul3"
  ];
  var deskripsi = ["youtube1", "youtube1", "youtube1"];
  var tanggal = ["10 Oktober 2021", "10 Oktober 2021", "10 Oktober 2021"];

  String _token;
  var _first_name = " ";
  var _last_name = " ";
  var _pemasokan = " ";
  var _pengeluaran = " ";
  var i;

  var id = new List();
  var title_video = new List();
  var description = new List();
  var youtube_link = new List();
  var date = new List();

  get_data() async {
    Map bodi = {"token": _token};
    var body = json.encode(bodi);
    final response = await http.post(
      Uri.parse("http://127.0.0.1:8000/api/admin/user/get"),
      body: body,
    );
    final data = jsonDecode(response.body);
    print(_token);
    String first_name = data['user']['first_name'];
    String last_name = data['user']['last_name'];
    setState(() {
      _first_name = first_name;
      _last_name = last_name;
    });
  }

  get_dashboard() async {
    Map bodi = {"token": _token};
    var body = json.encode(bodi);
    final response = await http.post(
      Uri.parse("http://127.0.0.1:8000/api/admin/dashboard/get"),
      body: body,
    );
    final data = jsonDecode(response.body);
    print(_token);
    int pengeluaran = data['total_price'];
    int pemasokan = data['total_weight'];
    setState(() {
      _pengeluaran = pengeluaran.toString();
      _pemasokan = pemasokan.toString();
    });
  }

  get_video() async {
    Map bodi = {"token": _token, "video_category_id":1};
    var body = json.encode(bodi);
    final response = await http.post(
      Uri.parse("http://127.0.0.1:8000/api/admin/videos/get"),
      body: body,
    );
    final data = jsonDecode(response.body);
    for (i = 0; i < data['videos'].length; i++) {
      var tanggal = data['videos'][i]['updated_at'];
      setState(() {
        id.add(data['videos'][i]['id']);
        title_video.add(data['videos'][i]['name']);
        description.add(data['videos'][i]['description']);
        youtube_link.add(data['videos'][i]['youtube_link']);
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
    get_data();
    get_dashboard();
    get_video();
  }

  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  int _selectedNavbar = 0;

  void _changeSelectedNavBar(int index) {
    setState(() {
      _selectedNavbar = index;
    });
  }

  DateTime selectedDate1 = DateTime.now();
  DateTime selectedDate2 = DateTime.now();

  Future<void> _selectDate1(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate1,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate1)
      setState(() {
        String date1 = new DateFormat("d MMMM yyyy", "id_ID")
            .format(selectedDate1)
            .toString();
        selectedDate1 = picked;
      });
  }

  Future<void> _selectDate2(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate2,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate2)
      setState(() {
        selectedDate2 = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        // width: kIsWeb ? 500.0 : double.infinity,
        child: Scaffold(
          body: Container(
            color: Color(0xFFF9FBFF),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(30, 5, 30, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Halo,",
                            style: TextStyle(
                              color: Colors.black, fontSize: 15, // 3
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            '$_first_name'+" "+'$_last_name',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.bold // 3
                                ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SettingDataMaster()));
                            },
                            icon: Icon(
                              FlutterIcons.sliders_faw,
                              color: Colors.black,
                            ),
                          ),
                          // IconButton(
                          //   onPressed: () {
                          //     Navigator.of(context).push(MaterialPageRoute(
                          //         builder: (context) => Account()));
                          //   },
                          //   icon: Icon(
                          //     Icons.account_circle,
                          //     color: Colors.black,
                          //   ),
                          // ),
                          IconButton(
                            onPressed: () {
                              showAlertDialog(context);
                            },
                            icon: Icon(
                              Icons.logout,
                              color: Colors.black,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                // Container(
                //   margin: EdgeInsets.fromLTRB(30, 5, 30, 5),
                //   padding: EdgeInsets.all(10),
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(10),
                //   ),
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text(
                //         'Total Pengeluaran',
                //         style: TextStyle(
                //           fontSize: 15,
                //           color: Colors.grey,
                //         ),
                //       ),
                //       Row(
                //         children: [
                //           Text(
                //             'Rp. ',
                //             style: TextStyle(
                //               fontSize: 15,
                //               color: Color(0xFF2F9EFC),
                //               fontWeight: FontWeight.bold,
                //             ),
                //           ),
                //           Text(
                //             _pengeluaran,
                //             style: TextStyle(
                //               fontSize: 25,
                //               color: Color(0xFF2F9EFC),
                //               fontWeight: FontWeight.bold,
                //             ),
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(30, 5, 10, 5),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Pengeluaran',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  'Rp. ',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF2F9EFC),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _pengeluaran,
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Color(0xFF2F9EFC),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(10, 5, 30, 5),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Pasokan',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  _pemasokan,
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Color(0xFF2F9EFC),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  ' L',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF2F9EFC),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Expanded(
                    //   child: Container(
                    //     margin: EdgeInsets.fromLTRB(10, 5, 30, 5),
                    //     padding: EdgeInsets.all(10),
                    //     decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.circular(10),
                    //     ),
                    //     child: Column(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text(
                    //           'Harga per Liter',
                    //           style: TextStyle(
                    //             fontSize: 15,
                    //             color: Colors.grey,
                    //           ),
                    //         ),
                    //         Row(
                    //           children: [
                    //             Text(
                    //               ' Rp.',
                    //               style: TextStyle(
                    //                 fontSize: 15,
                    //                 color: Color(0xFF2F9EFC),
                    //                 fontWeight: FontWeight.bold,
                    //               ),
                    //             ),
                    //             Text(
                    //               '4.000',
                    //               style: TextStyle(
                    //                 fontSize: 25,
                    //                 color: Color(0xFF2F9EFC),
                    //                 fontWeight: FontWeight.bold,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(30, 5, 30, 5),
                  child: Divider(color: Colors.grey),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(30, 5, 30, 5),
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: 30.0,
                            color: Colors.blue,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'User Baru',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RawMaterialButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => UserBaru()));
                            },
                            child: Icon(
                              Icons.arrow_forward,
                              size: 30.0,
                              color: Colors.blue,
                            ),
                            padding: EdgeInsets.all(15.0),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(30, 5, 30, 5),
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.card_travel,
                            size: 30.0,
                            color: Colors.blue,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Permintaan Penjemputan',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RawMaterialButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      PermintaanPenjemputan()));
                            },
                            child: Icon(
                              Icons.arrow_forward,
                              size: 30.0,
                              color: Colors.blue,
                            ),
                            padding: EdgeInsets.all(15.0),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(25, 5, 25, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Video',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Tutorial()));
                        },
                        child: Text(
                          'Kelola Video',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Scrollbar(
                    showTrackOnHover: true,
                    isAlwaysShown: true,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          for (var i = 0; i < youtube_link.length; i++)
                            RC_Video(
                                url: youtube_link[i],
                                idyoutube: youtube_link[i],
                                judul: title_video[i],
                                deskripsi: description[i],
                                tanggal: date[i]),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                )
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                title: Text('Beranda'),
              ),
              BottomNavigationBarItem(
                icon: Icon(FlutterIcons.file_text_o_faw),
                title: Text('Riwayat'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_outlined),
                title: Text('Pesan'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                title: Text('Profil'),
              ),
            ],
            currentIndex: _selectedNavbar,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.blueGrey,
            showUnselectedLabels: true,
            onTap: (index) {
              switch (index) {
                case 0:
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (c, a1, a2) => LoginPage(),
                      transitionsBuilder: (c, anim, a2, child) =>
                          FadeTransition(opacity: anim, child: child),
                      transitionDuration: Duration(milliseconds: 200),
                    ),
                  );
                  break;
                case 1:
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (c, a1, a2) => Historis(),
                      transitionsBuilder: (c, anim, a2, child) =>
                          FadeTransition(opacity: anim, child: child),
                      transitionDuration: Duration(milliseconds: 300),
                    ),
                  );
                  break;
                case 2:
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (c, a1, a2) => ChatList(),
                      transitionsBuilder: (c, anim, a2, child) =>
                          FadeTransition(opacity: anim, child: child),
                      transitionDuration: Duration(milliseconds: 300),
                    ),
                  );
                  break;
                case 3:
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (c, a1, a2) => Account(),
                      transitionsBuilder: (c, anim, a2, child) =>
                          FadeTransition(opacity: anim, child: child),
                      transitionDuration: Duration(milliseconds: 300),
                    ),
                  );
                  break;
              }
            },
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
        signOut();
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Log Out"),
      content: Text("Apakah anda ingin keluar dari apps?"),
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
       this.tanggal});

  String url, idyoutube, judul, deskripsi, tanggal;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        var urllaunchable =
            await canLaunch("https://www.youtube.com/watch?v="+url); //canLaunch is from url_launcher package
        if (urllaunchable) {
          await launch("https://www.youtube.com/watch?v="+url); //launch is from url_launcher package to launch URL
        } else {
          print("URL can't be launched.");
        }
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
                  image: NetworkImage(
                      "https://img.youtube.com/vi/$idyoutube/0.jpg"),
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
                  child: Text(
                    judul,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  width: 300,
                  child: Text(
                    deskripsi,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
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
