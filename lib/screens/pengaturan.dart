//@dart=2.9
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jelantah/constants.dart';
import 'package:jelantah/screens/account.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Pengaturan extends StatefulWidget {
  @override
  _PengaturanState createState() => _PengaturanState();
}

class _PengaturanState extends State<Pengaturan> {
  var _token;

  var i;
  var value;
  var name;

  get_data() async {
    Map bodi = {"token": _token, "name": "need_approve_user"};
    var body = json.encode(bodi);
    final response = await http.post(
      Uri.parse("$kIpAddress/api/admin/settings/get"),
      body: body,
    );
    final data = jsonDecode(response.body);
      setState(() {
        value=data['setting']['value'];
        name=data['setting']['name'];
      });
      print(data);
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
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Scaffold(
          appBar: AppBar(
              titleSpacing: 0,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          Account()));
                },
                color: Colors.blue,
                icon: Icon(
                  Icons.keyboard_arrow_left,
                  size: 30,
                ),
              ),
              title: Text(
                "Pengaturan",
                style: TextStyle(
                  color: Colors.blue, // 3
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0.0),
          body: Container(
            margin: EdgeInsets.all(30),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Persetujuan Akun Baru',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                updatePersetujuan(1);
                              });
                            },
                            child: Text("ON", style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  value == "1" ? Color(0xffECF8ED) : Colors.transparent,
                                ),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ))),
                          ),
                          SizedBox(width: 20,),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                updatePersetujuan(0);
                              });
                            },
                            child: Text("OFF", style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold),),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  value == "0" ? Color(0xffFBE8E8) : Colors.transparent,
                                ),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ))),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updatePersetujuan(int i) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _token = preferences.getString('token');
    Map bodi = {"token": _token, "name": "need_approve_user", "value": i};
    var body = json.encode(bodi);
    final response = await http.post(
      Uri.parse("$kIpAddress/api/admin/settings/put"),
      body: body,
    );
    final data = jsonDecode(response.body);
    var status = data['status'];
    if (status == "success" && i == 1) {
      showAlertDialog(context);
    } else if (status == "success" && i == 0) {
      showAlertDialog2(context);
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (c, a1, a2) => Pengaturan(),
            transitionsBuilder: (c, anim, a2, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: Duration(milliseconds: 300),
          ),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Berhasil"),
      content: Text("Persetujuan user baru aktif"),
      actions: [
        okButton,
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

  showAlertDialog2(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (c, a1, a2) => Pengaturan(),
            transitionsBuilder: (c, anim, a2, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: Duration(milliseconds: 300),
          ),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Berhasil"),
      content: Text("Persetujuan user baru tidak aktif"),
      actions: [
        okButton,
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
