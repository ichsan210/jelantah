
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jelantah/screens/master_user.dart';
import 'package:jelantah/screens/master_user_password.dart';
import 'package:jelantah/screens/tutorial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MasterUserDetail extends StatefulWidget {
  final int id, price;
  final String first_name, last_name, email, phone_number;

  MasterUserDetail({
    required Key key,
    required this.id,
    required this.price,
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.phone_number,
  }) : super(key: key);

  @override
  _MasterUserDetailState createState() => _MasterUserDetailState();
}

class _MasterUserDetailState extends State<MasterUserDetail> {
  final _key = new GlobalKey<FormState>();
  late String first_name_isi,
      last_name_isi,
      email_isi,
      phone_number_isi,
      price_isi;
  var _token;

  var i;

  var id;

  check() {
    print("jalan");
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      ubahUser();
    }
  }

  ubahUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token");
    var iduser = widget.id;
    Map bodi = {
      "token": token,
      "first_name":first_name_isi,
      "last_name":last_name_isi,
      "email":email_isi,
      "phone_number":phone_number_isi,
      "price":price_isi
    };
    var body = json.encode(bodi);
    final response = await http.post(
      Uri.parse("http://127.0.0.1:8000/api/admin/users/$iduser/put"),
      body: body,
    );
    final data = jsonDecode(response.body);
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
    //get_data();
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
                  Navigator.pop(context);
                },
                color: Colors.blue,
                icon: Icon(
                  Icons.keyboard_arrow_left,
                  size: 30,
                ),
              ),
              title: Text(
                "Edit User",
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
                          'Nama Depan',
                          style: TextStyle(color: Colors.blue),
                        ),
                        Container(
                          child: TextFormField(
                            onSaved: (e) => first_name_isi = e!,
                            initialValue: widget.first_name,
                            decoration: InputDecoration(
                              hintText: "Masukan nama depan",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Nama Belakang',
                          style: TextStyle(color: Colors.blue),
                        ),
                        Container(
                          child: TextFormField(
                            onSaved: (e) => last_name_isi = e!,
                            initialValue: widget.last_name,
                            decoration: InputDecoration(
                              hintText: "Masukan nama belakang",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Email',
                          style: TextStyle(color: Colors.blue),
                        ),
                        Container(
                          child: TextFormField(
                            onSaved: (e) => email_isi = e!,
                            initialValue: widget.email,
                            decoration: InputDecoration(
                              hintText: "Masukan email",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Nomer Handphone',
                          style: TextStyle(color: Colors.blue),
                        ),
                        Container(
                          child: TextFormField(
                            onSaved: (e) => phone_number_isi = e!,
                            initialValue: widget.phone_number,
                            decoration: InputDecoration(
                              hintText: "Masukan nomer handphone",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Harga Minyak Jelantah per Liter',
                          style: TextStyle(color: Colors.blue),
                        ),
                        Container(
                          child: TextFormField(
                            onSaved: (e) => price_isi = e!,
                            initialValue: widget.price.toString(),
                            decoration: InputDecoration(
                              hintText: "Masukan nomer handphone",
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
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => MasterUserPassword(id: widget.id)));

                                //showAlertDialog2(context);
                              },
                              child: Text('Ubah Password',
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
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => MasterUser()));

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Konfirmasi"),
      content: Text("Simpan data user ini?"),
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
