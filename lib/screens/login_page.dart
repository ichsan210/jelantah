import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register.dart';
import 'dashboard.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

enum LoginStatus { notSignIn, signIn }

class _LoginPageState extends State<LoginPage> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  late String email, password;
  final _key = new GlobalKey<FormState>();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      login();
    }
  }

  login() async {
    final response = await http.post(Uri.parse("http://192.168.8.105/flutter/login.php"),
        headers: {
          "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept",
        },
        body: {"email": email, "password": password});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    String emailAPI = data['email'];
    String namaAPI = data['nama'];
    String id = data['id'];
    if (value == 1) {
      setState(() {
        _loginStatus = LoginStatus.signIn;
        savePref(value, emailAPI, namaAPI, id);
      });
      print(pesan);
      print(namaAPI);
      print(emailAPI);
    } else {
      showAlertDialog(context);
      print(pesan);
    }
  }

  savePref(int value, String email, String nama, String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("nama", nama);
      preferences.setString("email", email);
      preferences.setString("id", id);
      preferences.commit();
    });
  }

  var value;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");

      _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.commit();
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return Scaffold(
          body: Form(
            key: _key,
            child: Center(
              child: Container(
                width: kIsWeb ? 500.0 : double.infinity,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/mobil.PNG"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      height: 380,
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(30),
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10)),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                          children: <Widget>[
                                            Text('Email / No Telp', style: TextStyle(color: Color(0xff283c71)),),
                                            TextFormField(
                                              style: TextStyle(color: Color(0xff283c71)),
                                              validator: (e) {
                                                if (e!.isEmpty) {
                                                  return "Masukan Email / No Telp";
                                                }
                                              },
                                              onSaved: (e) => email = e!,
                                              decoration: InputDecoration(
                                                hintText: "Masukan Email / No Telp", ),
                                            ),
                                            SizedBox(height: 10),
                                            Text('Password', style: TextStyle(color: Color(0xff283c71)),),
                                            TextFormField(
                                              style: TextStyle(color: Color(0xff283c71)),
                                              obscureText: _secureText,
                                              onSaved: (e) => password = e!,
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
                                                if (e!.isEmpty) {
                                                  return "Please insert password";
                                                }
                                              },
                                            ),
                                            SizedBox(height: 20),
                                            Text("Lupa Password?", style: TextStyle(color: Colors.blue, fontSize: 16), textAlign: TextAlign.right,),
                                            SizedBox(height: 40),
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
                                                  child: Text('Masuk',
                                                      style:
                                                      TextStyle(color: Colors.white))),
                                            ),
                                            SizedBox(height: 20),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text("Belum punya akun? ", style: TextStyle(color: Colors.grey, fontSize: 16), ),
                                                Text("Daftar", style: TextStyle(color: Colors.blue, fontSize: 16), ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
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
        break;
      case LoginStatus.signIn:
        return Dashboard(signOut);
        break;
    }
  }

  void showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget continueButton = TextButton(
      child: Text("Ok"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Login Gagal"),
      content: Text("Email atau Password salah!"),
      actions: [
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




