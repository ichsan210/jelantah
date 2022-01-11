// @dart=2.9
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'; import 'package:jelantah/constants.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:jelantah/screens/master_user_balance.dart';
import 'package:jelantah/screens/master_user_detail.dart';
import 'package:jelantah/screens/registration_user.dart';
import 'package:jelantah/screens/setting_data_master.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jelantah/screens/register.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MasterUser extends StatefulWidget {
  @override
  _MasterUserState createState() => _MasterUserState();
}

class _MasterUserState extends State<MasterUser> {
  var _token;

  var i;
  var id = new List();
  var first_name = new List();
  var last_name = new List();
  var email = new List();
  var phone_number = new List();
  var price = new List();

  get_data() async {
    Map bodi = {"token": _token};
    var body = json.encode(bodi);
    final response = await http.post(
      Uri.parse("$kIpAddress/api/admin/users/get"),
      body: body,
    );
    final data = jsonDecode(response.body);
    for (i = 0; i < data['users'].length; i++) {
      setState(() {
        id.add(data['users'][i]['id']);
        first_name.add(data['users'][i]['first_name']);
        last_name.add(data['users'][i]['last_name']);
        email.add(data['users'][i]['email']);
        phone_number.add(data['users'][i]['phone_number']);
        price.add(data['users'][i]['price']);
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
                "Data Master User",
                style: TextStyle(
                  color: Colors.blue, // 3
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            actions: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 30),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => RegisterUser()));
                  },
                  icon: Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          body: Scrollbar(
            showTrackOnHover: true,
            isAlwaysShown: true,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (i = 0; i < first_name.length; i++)
                    RC_MasterUser(
                      id: id[i],
                      first_name: first_name[i],
                      last_name: last_name[i],
                      email: email[i],
                      phone_number: phone_number[i],
                      price: price[i],
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

class RC_MasterUser extends StatelessWidget {
  RC_MasterUser({this.first_name, this.last_name, this.email, this.id, this.phone_number, this.price});

  String first_name, last_name, email, phone_number;
  int id, price;

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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    first_name + " " + last_name,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => MasterUserBalance(id:id, first_name:first_name, last_name:last_name)));
                    },
                    child: Icon(
                        FontAwesome5.credit_card,
                        size: 30.0,
                        color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => MasterUserDetail(id:id, first_name:first_name, last_name:last_name, email:email, phone_number:phone_number, price:price)));
                    },
                    child: Icon(
                      Icons.settings,
                      size: 30.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: (){
                      showAlertDialog2(context);
                    },
                    child: Icon(
                      Icons.delete,
                      size: 30.0,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
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
        delete();
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (c, a1, a2) => MasterUser(),
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
      content: Text("Hapus user ini?"),
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

    Map bodi = {"token": token};
    var body = json.encode(bodi);
    final response = await http.post(
      Uri.parse("$kIpAddress/api/admin/users/$id/delete"),
      body: body,
    );
    final data = jsonDecode(response.body);
    print(data);
  }

}
