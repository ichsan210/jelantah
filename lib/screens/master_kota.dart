// @dart=2.9
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jelantah/constants.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:jelantah/screens/master_driver_detail.dart';
import 'package:jelantah/screens/master_user_balance.dart';
import 'package:jelantah/screens/master_user_detail.dart';
import 'package:jelantah/screens/registration_driver.dart';
import 'package:jelantah/screens/registration_user.dart';
import 'package:jelantah/screens/setting_data_master.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jelantah/screens/register.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MasterKota extends StatefulWidget {
  @override
  _MasterDriverState createState() => _MasterDriverState();
}

class _MasterDriverState extends State<MasterKota> {
  var _token;
  bool loading = true;
  var i;
  var province_id = new List();
  var province_name = new List();
  var name = new List();

  get_data() async {
    Map bodi = {"token": _token};
    var body = json.encode(bodi);
    final response = await http.post(
      Uri.parse("$kIpAddress/api/admin/cities/get"),
      body: body,
    );
    final data = jsonDecode(response.body);
    for (i = 0; i < data['cities'].length; i++) {
      setState(() {
        name.add(data['cities'][i]['name']);
        int provinsiID=data['cities'][i]['province_id'];
        province_name.add(province_id[provinsiID-1]);
      });
    }
    Future.delayed(const Duration(milliseconds: 5000), () {
      setState(() {
        loading = false;
      });
    });
  }

  nama_provinsi() async {
    Map bodi = {"token": _token};
    var body = json.encode(bodi);
    final response = await http.post(
      Uri.parse("$kIpAddress/api/admin/provinces/get"),
      body: body,
    );
    final data = jsonDecode(response.body);
    for (i = 0; i < data['provinces'].length; i++) {
      setState(() {
        province_id.add(data['provinces'][i]['name']);
      });
    }
    Future.delayed(const Duration(milliseconds: 5000), () {
      get_data();
    });
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(
      () {
        _token = preferences.getString("token");
        // _token = (preferences.getString('token') ?? '');
      },
    );
    nama_provinsi();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    if (loading)
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    return Center(
      child: Container(
        //width: kIsWeb ? 500.0 : double.infinity,
        child: Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SettingDataMaster()));
              },
              color: Colors.blue,
              icon: Icon(
                Icons.keyboard_arrow_left,
                size: 30,
              ),
            ),
            title: Container(
              child: Text(
                "Data Master Kota",
                style: TextStyle(
                  color: Colors.blue, // 3
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            // actions: <Widget>[
            //   Container(
            //     margin: EdgeInsets.only(right: 30),
            //     child: IconButton(
            //       onPressed: () {
            //         Navigator.of(context).push(MaterialPageRoute(
            //             builder: (context) => RegisterDriver()));
            //       },
            //       icon: Icon(
            //         Icons.add,
            //         color: Colors.black,
            //       ),
            //     ),
            //   ),
            // ],
          ),
          body: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(50, 10, 40, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 150,
                      child: Text(
                        'Provinsi',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      width: 150,
                      child: Text(
                        'Kota/Kabupaten',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
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
                        for (i = 0; i < name.length; i++)
                          RC_MasterUser(
                            province_name: province_name[i],
                            name: name[i],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RC_MasterUser extends StatelessWidget {
  RC_MasterUser({this.province_name, this.name});

  String province_name, name;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 50,
        margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: const Offset(1.0, 1.0),
              blurRadius: 1.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.only(left: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 150,
                    child: Text(
                      province_name,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    width: 150,
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Container(
            //   padding: EdgeInsets.only(right: 20),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       GestureDetector(
            //         onTap: () {
            //
            //         },
            //         child: Icon(
            //           Icons.settings,
            //           size: 30.0,
            //           color: Colors.black,
            //         ),
            //       ),
            //       SizedBox(
            //         width: 20,
            //       ),
            //       GestureDetector(
            //         onTap: () {
            //           showAlertDialog2(context);
            //         },
            //         child: Icon(
            //           Icons.delete,
            //           size: 30.0,
            //           color: Colors.black,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
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
        //delete();
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (c, a1, a2) => MasterKota(),
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
      content: Text("Hapus driver ini?"),
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

// delete() async {
//   SharedPreferences preferences = await SharedPreferences.getInstance();
//   var token = preferences.getString("token");
//
//   Map bodi = {"token": token};
//   var body = json.encode(bodi);
//   final response = await http.post(
//     Uri.parse("$kIpAddress/api/admin/drivers/$id/delete"),
//     body: body,
//   );
//   final data = jsonDecode(response.body);
//   print(data);
// }
}
