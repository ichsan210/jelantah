// @dart=2.9

import 'dart:convert';

import 'dart:convert' show JSON;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jelantah/screens/permintaan_penjemputan.dart';
import 'package:jelantah/screens/tutorial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UbahPermintaan extends StatefulWidget {
  final String pickup_order_no,
      address,
      namaKota,
      postal_code,
      pickup_date,
      estimate_volume,
      tanggalOrder,
      driver_id;

  UbahPermintaan({
    Key key,
    this.pickup_order_no,
    this.address,
    this.pickup_date,
    this.estimate_volume,
    this.tanggalOrder,
    this.driver_id,
    this.postal_code,
    this.namaKota,
  }) : super(key: key);

  @override
  _UbahPermintaanState createState() => _UbahPermintaanState();
}

class _UbahPermintaanState extends State<UbahPermintaan> {
  String address, tanggalOrder, driver, estimate_volume;
  final _key = new GlobalKey<FormState>();

  List _isiDriver = ["Driver", "Ichsan", "Dimas", "steven"];
  List<DropdownMenuItem<String>> _dropdownDriver;
  String _driverterpilih;

  DateTime selectedDate1 = DateTime.now();

  var _token;
  var i;

  //var id = new List();
  //var first_name = new List();
  List first_name = List();
  var last_name = new List();
  List _namaDriver = ["Pilih Driver"];
  List id = [0];

  int _idTerpilih;
  var _idDriver;

  Future<void> _selectDate1(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate1,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate1)
      setState(() {
        selectedDate1 = picked;
      });
  }

  List<DropdownMenuItem<String>> getDropdownDriver() {
    List<DropdownMenuItem<String>> items = [];
    for (String driver in _namaDriver) {
      items.add(new DropdownMenuItem(value: driver, child: new Text(driver)));
    }
    return items;
  }

  void changedropdownDriver(String driverTerpilih) {
    setState(() {
      _driverterpilih = driverTerpilih;
      print(_driverterpilih);

      _idTerpilih = _namaDriver.indexOf(_driverterpilih);
      print(_idTerpilih);

      _idDriver = id[_idTerpilih];
      print(_idDriver);
    });
  }

  get_data() async {
    Map bodi = {"token": _token};
    var body = json.encode(bodi);
    final response = await http.post(
      Uri.parse("http://127.0.0.1:8000/api/admin/drivers/get"),
      body: body,
    );
    final data = jsonDecode(response.body);
    for (i = 0; i < data['users'].length; i++) {
      setState(() {
        id.add(data['users'][i]['id'].toString());
        // first_name.add(data['users'][i]['first_name']);
        // last_name.add(data['users'][i]['last_name']);
        _namaDriver.add(data['users'][i]['first_name'] +
            " " +
            data['users'][i]['last_name']);
        // address.add(data['users'][i]['addresses'][0]['address']);
        // phone_number.add(data['users'][i]['addresses'][0]['phone_number']);
      });
    }
    print(_isiDriver);
    _dropdownDriver = getDropdownDriver();
    _driverterpilih = _dropdownDriver[0].value;
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

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
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
              "Ubah Data",
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
                        'Alamat',
                        style: TextStyle(color: Colors.blue),
                      ),
                      Container(
                        child: TextFormField(
                          enabled: false,
                          onSaved: (e) => address = e,
                          initialValue: widget.address+", "+widget.namaKota+", "+widget.postal_code,
                          decoration: InputDecoration(
                            hintText: "Pilih Kategori",
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Estimasi Penjemputan',
                        style: TextStyle(color: Colors.blue),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${DateFormat("d MMMM yyyy", "id_ID").format(selectedDate1)}",
                            style: TextStyle(fontSize: 16),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.calendar_today_outlined,
                            ),
                            iconSize: 17,
                            color: Colors.blue,
                            onPressed: () => _selectDate1(context),
                          ),
                        ],
                      ),
                      Container(
                        child: Divider(color: Colors.grey),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Driver',
                        style: TextStyle(color: Colors.blue),
                      ),
                      Container(
                        child: SizedBox(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButtonFormField(
                              hint: Text("Pilih Driver"),
                              isExpanded: true,
                              value: _driverterpilih,
                              items: _dropdownDriver,
                              validator: (value) =>
                                  value == 0 ? 'field required' : null,
                              onChanged: changedropdownDriver,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Total Volume (Liter)',
                        style: TextStyle(color: Colors.blue),
                      ),
                      Container(
                        child: TextFormField(
                          enabled: false,
                          onSaved: (e) => estimate_volume = e,
                          initialValue: widget.estimate_volume,
                          decoration: InputDecoration(
                            hintText: "",
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Tanggal Order',
                        style: TextStyle(color: Colors.blue),
                      ),
                      Container(
                        child: TextFormField(
                          enabled: false,
                          onSaved: (e) => tanggalOrder = e,
                          initialValue: widget.tanggalOrder,
                          decoration: InputDecoration(
                            hintText: "",
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
                      child: Text('Ubah Data',
                          style: TextStyle(color: Colors.white))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  saveData() async {
    String formattedDate =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedDate1);
    print(formattedDate);
    var noorder = widget.pickup_order_no;
    Map bodi = {
      "token": _token,
      "driver_id": _idDriver,
      "pickup_date": formattedDate,
    };
    var body = json.encode(bodi);
    final response = await http.post(
      Uri.parse(
          "http://127.0.0.1:8000/api/admin/pickup_orders/$noorder/assign/post"),
      body: body,
    );
    final data = jsonDecode(response.body);
    String status = data['status'];
    String message = data['message'];
    print(data);
    print(noorder);
    if (status == "success") {
      setState(() {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => PermintaanPenjemputan()));
      });
    } else {
      print(message);
    }
  }
}
