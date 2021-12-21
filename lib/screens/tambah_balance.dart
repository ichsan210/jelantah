// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:jelantah/screens/master_user.dart';
import 'package:jelantah/screens/master_user_balance.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TambahBalance extends StatefulWidget {
  final id, first_name, last_name;

  TambahBalance({
    Key key,
    this.id,
    this.first_name,
    this.last_name,
  }) : super(key: key);

  @override
  _TambahBalanceState createState() => _TambahBalanceState();
}

class _TambahBalanceState extends State<TambahBalance> {
  final _key = new GlobalKey<FormState>();
  var amount;

  List _listJenisTransaksi = ["credit", "debit"];
  String _valJenisTransaksi;

  check() {
    print("jalan");
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      saveData();
      print("berhasil");
    } else {
      print("gagal");
    }
  }

  saveData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var _token = preferences.getString("token");
    var iduser = widget.id;
    Map bodi = {
      "token": _token,
      "user_id": iduser,
      "amount": amount,
      "type": _valJenisTransaksi
    };
    var body = json.encode(bodi);
    final response = await http.post(
      Uri.parse("http://127.0.0.1:8000/api/admin/balance_history/post"),
      body: body,
    );
    //final data = jsonDecode(response.body);
    setState(() {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => MasterUserBalance(id:iduser, first_name:widget.first_name, last_name:widget.last_name)));
    });
    // String status = data['status'];
    // String message = data['message'];
    // print(data);
    // print(noorder);
    // if (status == "success") {
    //   setState(() {
    //     Navigator.of(context).push(
    //         MaterialPageRoute(builder: (context) => PermintaanPenjemputan()));
    //   });
    // } else {
    //   print(message);
    // }
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
                "Tambah Transaksi",
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
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Account',
                          style: TextStyle(color: Colors.blue),
                        ),
                        Container(
                          child: TextFormField(
                            enabled: false,
                            initialValue: widget.first_name+" "+widget.last_name,
                            validator: (e) {
                              if (e.isEmpty) {
                                return "Please insert email";
                              }
                            },
                            decoration: InputDecoration(
                              hintText: "Pilih Kategori",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Jenis Transaksi',
                          style: TextStyle(color: Colors.blue),
                        ),
                        DropdownButtonFormField(
                          hint: Text("Pilih jenis transaksi"),
                          value: _valJenisTransaksi,
                          items: _listJenisTransaksi.map((value) {
                            return DropdownMenuItem(
                              child: Text(value),
                              value: value,
                            );
                          }).toList(),
                          validator: (value) =>
                              value == 0 ? 'field required' : null,
                          onChanged: (value) {
                            setState(() {
                              _valJenisTransaksi = value;
                              print(_valJenisTransaksi);
                            });
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Jumlah',
                          style: TextStyle(color: Colors.blue),
                        ),
                        Container(
                          child: TextFormField(
                            validator: (e) {
                              if (e.isEmpty) {
                                return "Masukan jumlah uang";
                              }
                            },
                            onSaved: (e) => amount = e,
                            decoration: InputDecoration(
                              hintText: "Masukan besaran uang",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
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
                        child: Text('Simpan',
                            style: TextStyle(color: Colors.white))),
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
