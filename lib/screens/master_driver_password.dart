import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jelantah/screens/master_driver.dart';
import 'package:jelantah/screens/master_user.dart';
import 'package:jelantah/screens/tutorial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MasterDriverPassword extends StatefulWidget {
  final int id;

  MasterDriverPassword({
    required this.id,
  });

  @override
  _MasterDriverPasswordState createState() => _MasterDriverPasswordState();
}

class _MasterDriverPasswordState extends State<MasterDriverPassword> {
  final _key = new GlobalKey<FormState>();
  late String password1, password2;

  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  var confirmPass;

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
      ubahPassword();
    }
  }

  ubahPassword() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token");
    var iduser = widget.id;
    Map bodi = {
      "token": token,
      "password":password1,
      "confirm_password":password2
    };
    var body = json.encode(bodi);
    final response = await http.post(
      Uri.parse("http://127.0.0.1:8000/api/admin/users/$iduser/password/put"),
      body: body,
    );
    final data = jsonDecode(response.body);
    print(data);
    if(data["status"]=="success"){
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => MasterDriver()));
    }
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
                  "Ubah Password Driver",
                  style: TextStyle(
                    color: Colors.blue, // 3
                  ),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0.0),
            body: Padding(
              padding: EdgeInsets.all(30),
              child: Form(
                key: _key,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Password',
                          style: TextStyle(color: Color(0xff283c71)),
                        ),
                        TextFormField(
                          controller: _pass,
                          style: TextStyle(color: Color(0xff283c71)),
                          obscureText: _secureText,
                          onSaved: (e) => password1 = e!,
                          decoration: InputDecoration(
                            hintText: "Masukan Password",
                            suffixIcon: IconButton(
                              onPressed: showHide,
                              icon: Icon(_secureText
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            ),
                          ),
                          validator: (e) {
                            confirmPass = e;
                            if (e!.isEmpty) {
                              return "Masukan Password";
                            }
                          },
                        ),
                        SizedBox(height: 20,),
                        Text(
                          'Konfirmasi Password',
                          style: TextStyle(color: Color(0xff283c71)),
                        ),
                        TextFormField(
                          controller: _confirmPass,
                          style: TextStyle(color: Color(0xff283c71)),
                          obscureText: _secureText,
                          onSaved: (e) => password2 = e!,
                          decoration: InputDecoration(
                            hintText: "Masukan Konfirmasi Password",
                            suffixIcon: IconButton(
                              onPressed: showHide,
                              icon: Icon(_secureText
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            ),
                          ),
                          validator: (e) {
                            if (e!.isEmpty) {
                              return "Masukan Konfirmasi Password";
                            }
                            if (e != confirmPass) {
                              return 'Password Berbeda';
                            }
                          },
                        ),
                      ],
                    ),
                    Container(
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
                  ],
                ),
              ),
            )
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
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Konfirmasi"),
      content: Text("Simpan password baru?"),
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
