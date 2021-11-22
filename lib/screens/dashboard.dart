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
  var idyoutube = ["LvUYbxlSGHw", "LvUYbxlSGHw", "LvUYbxlSGHw"];
  var judul = ["Semua yang perlu kamu ketahui, Jelantah App", "judul2", "judul3"];
  var deskripsi = ["youtube1", "youtube1", "youtube1"];
  var tanggal = ["10 Oktober 2021", "10 Oktober 2021", "10 Oktober 2021"];

  var _nama;

  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(
      () {
        _nama = (preferences.getString('nama') ?? '');
      },
    );
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
    final DateTime? picked = await showDatePicker(
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
    final DateTime? picked = await showDatePicker(
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
        width: kIsWeb ? 500.0 : double.infinity,
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
                            "${_nama}",
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
                          // IconButton(
                          //   onPressed: () {
                          //     showAlertDialog(context);
                          //   },
                          //   icon: Icon(
                          //     Icons.logout,
                          //     color: Colors.black,
                          //   ),
                          // )
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(30, 5, 30, 5),
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
                            '4.000.000',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        width: 160,
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
                              'Total Pasokan',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '100',
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
                              'Harga per Liter',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  ' Rp.',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF2F9EFC),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '4.000',
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
                      Text(
                        'Kelola Video',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blue,
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
                          for (var i = 0; i < url.length; i++)
                            RC_Video(
                                url: url[i],
                                idyoutube: idyoutube[i],
                                judul: judul[i],
                                deskripsi: deskripsi[i],
                                tanggal: tanggal[i]),
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
                      pageBuilder: (c, a1, a2) => Tutorial(),
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
}

class RC_Video extends StatelessWidget {
  RC_Video(
      {required this.url,
      required this.idyoutube,
      required this.judul,
      required this.deskripsi,
      required this.tanggal});

  String url, idyoutube, judul, deskripsi, tanggal;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        var urllaunchable = await canLaunch(url); //canLaunch is from url_launcher package
        if(urllaunchable){
          await launch(url); //launch is from url_launcher package to launch URL
        }else{
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
                  width: 230,
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
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
