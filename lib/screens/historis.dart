// @dart=2.9
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jelantah/screens/detail_permintaan.dart';
import 'package:jelantah/screens/historis_item_batal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jelantah/screens/historis_item_selesai.dart';
import 'package:intl/intl.dart';
import 'package:jelantah/screens/login_page.dart';
import 'package:jelantah/screens/historis.dart';
import 'package:jelantah/screens/chat_list.dart';
import 'package:jelantah/screens/tutorial.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:jelantah/screens/account.dart';
import 'package:http/http.dart' as http;

const activeButtonColor = Color(0xffE7EEF4);
const inactiveButtonColor = Color(0xffFFFFFF);

class Historis extends StatefulWidget {
  @override
  _HistorisState createState() => _HistorisState();
}

class _HistorisState extends State<Historis> {
  // var orderid = ["123-456-781", "123-456-782", "123-456-783", "123-456-784"];
  // var alamat = [
  //   "Jalan Cut Meutia No 1, Jakarta Barat, 11146",
  //   "Jalan Cut Meutia No 1, Jakarta Barat, 11146",
  //   "Jalan Cut Meutia No 1, Jakarta Barat, 11146",
  //   "Jalan Cut Meutia No 1, Jakarta Barat, 11146",
  // ];
  // var estimasi = [
  //   "Senin, 22 November 2021",
  //   "Senin, 22 November 2021",
  //   "Senin, 22 November 2021",
  //   "Senin, 22 November 2021",
  // ];
  // var status = [
  //   "Selesai",
  //   "Batal",
  //   "Proses",
  //   "Dalam Perjalanan",
  // ];
  // var volume = [
  //   "10",
  //   "10",
  //   "10",
  //   "10",
  // ];

  Color semuaColor = inactiveButtonColor;
  Color prosesColor = activeButtonColor;
  Color perjalananColor = inactiveButtonColor;
  Color selesaiColor = inactiveButtonColor;
  Color batalColor = inactiveButtonColor;

  var statusTerpilih = "processed";

  var _token;

  var i;

  var id = new List();
  var pickup_order_no = new List();
  var address = new List();
  var pickup_date = new List();
  var estimate_volume = new List();
  var namaKota = new List();
  var postal_code = new List();
  var status = new List();
  var tanggalOrder = new List();
  var latitude = new List();
  var longitude = new List();

  void updateButtonStyle(String status) {
    //refeshData();
    if (status == "semua") {
      setState(() {
        statusTerpilih = "Semua";
      });
      if (semuaColor == inactiveButtonColor) {
        semuaColor = activeButtonColor;
        prosesColor = inactiveButtonColor;
        perjalananColor = inactiveButtonColor;
        selesaiColor = inactiveButtonColor;
        batalColor = inactiveButtonColor;
      }
    }
    if (status == "processed") {
      setState(() {
        statusTerpilih = "processed";
      });
      if (prosesColor == inactiveButtonColor) {
        semuaColor = inactiveButtonColor;
        prosesColor = activeButtonColor;
        perjalananColor = inactiveButtonColor;
        selesaiColor = inactiveButtonColor;
        batalColor = inactiveButtonColor;
      }
    }
    if (status == "on_pickup") {
      setState(() {
        statusTerpilih = "on_pickup";
      });
      if (perjalananColor == inactiveButtonColor) {
        semuaColor = inactiveButtonColor;
        prosesColor = inactiveButtonColor;
        perjalananColor = activeButtonColor;
        selesaiColor = inactiveButtonColor;
        batalColor = inactiveButtonColor;
      }
    }
    if (status == "closed") {
      setState(() {
        statusTerpilih = "closed";
      });
      if (selesaiColor == inactiveButtonColor) {
        semuaColor = inactiveButtonColor;
        prosesColor = inactiveButtonColor;
        perjalananColor = inactiveButtonColor;
        selesaiColor = activeButtonColor;
        batalColor = inactiveButtonColor;
      }
    }
    if (status == "cancelled") {
      setState(() {
        statusTerpilih = "cancelled";
      });
      if (batalColor == inactiveButtonColor) {
        semuaColor = inactiveButtonColor;
        prosesColor = inactiveButtonColor;
        perjalananColor = inactiveButtonColor;
        selesaiColor = inactiveButtonColor;
        batalColor = activeButtonColor;
      }
    }
  }

  get_data() async {
    Map bodi = {
      "token": _token,
      "status": ["processed", "on_pickup", "closed", "cancelled"],
      "start_date": null,
      "end_date": null
    };
    var body = json.encode(bodi);
    final response = await http.post(
      Uri.parse("http://127.0.0.1:8000/api/admin/pickup_orders/get"),
      body: body,
    );
    final data = jsonDecode(response.body);
    for (i = 0; i < data['pickup_orders']['data'].length; i++) {
      var tanggal = data['pickup_orders']['data'][i]['created_at'];
      var idcity = data['pickup_orders']['data'][i]['city_id'];
      var tanggalpickup = data['pickup_orders']['data'][i]['pickup_date'];
      setState(() {
        id.add(data['pickup_orders']['data'][i]['id'].toString());
        pickup_order_no.add(data['pickup_orders']['data'][i]['pickup_order_no'].toString());
        address.add(data['pickup_orders']['data'][i]['address']);
        postal_code.add(data['pickup_orders']['data'][i]['postal_code']);
        namaKota.add("");
        get_CityID(idcity, i);
        if(tanggalpickup==null){
          pickup_date.add("-");
        }else{
          pickup_date.add(formatTanggalPickup(tanggalpickup));
        }
        estimate_volume.add(data['pickup_orders']['data'][i]['estimate_volume'].toString());
        status.add(data['pickup_orders']['data'][i]['status']);
        tanggalOrder.add(formatTanggal(tanggal));
        latitude.add(data['pickup_orders']['data'][i]['latitude'].toString());
        longitude.add(data['pickup_orders']['data'][i]['longitude'].toString());
      });
    }
    print(pickup_date);
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(
      () {
        _token = preferences.getString("token");
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

  int _selectedNavbar = 1;

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
        child: DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
                title: Text(
                  "Riwayat",
                  style: TextStyle(
                    color: Colors.blue, // 3
                  ),
                ),
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                elevation: 0),
            body: Center(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(30, 5, 30, 5),
                      color: Colors.white,
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                updateButtonStyle("semua");
                              });
                            },
                            child: Text("Semua"),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  semuaColor,
                                ),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ))),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                updateButtonStyle("processed");
                              });
                            },
                            child: Text("Proses"),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  prosesColor,
                                ),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ))),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                updateButtonStyle("on_pickup");
                              });
                            },
                            child: Text("Dalam Perjalanan"),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  perjalananColor,
                                ),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ))),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                updateButtonStyle("closed");
                              });
                            },
                            child: Text("Selesai"),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  selesaiColor,
                                ),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ))),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                updateButtonStyle("cancelled");
                              });
                            },
                            child: Text("Batal"),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  batalColor,
                                ),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ))),
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
                              for (var i = 0; i < pickup_order_no.length; i++)
                                if (status[i] == statusTerpilih)
                                  RC_Historis(
                                    orderid: pickup_order_no[i],
                                    alamat: address[i],
                                    tanggalOrder: tanggalOrder[i],
                                    status: status[i],
                                    volume: estimate_volume[i],
                                    pickup_date: pickup_date[i],
                                    latitude: latitude[i],
                                    longitude: longitude[i],
                                  )
                                else if (statusTerpilih == "Semua" &&
                                    status[i] != "pending")
                                  RC_Historis(
                                    orderid: pickup_order_no[i],
                                    alamat: address[i],
                                    tanggalOrder: tanggalOrder[i],
                                    status: status[i],
                                    volume: estimate_volume[i],
                                    pickup_date: pickup_date[i],
                                    latitude: latitude[i],
                                    longitude: longitude[i],
                                  )
                              // RC_Historis(orderid: '123-456-333', alamat: 'Jalan Cut Meutia No 1, Jakarta Barat, 11146', estimasi: 'Senin, 1 Agustus 2021', status: 'Selesai', volume: '10', color: Colors.blue,),
                              // RC_Historis(orderid: '123-456-111', alamat: 'Jalan Cut Meutia No 1, Jakarta Barat, 11146', estimasi: 'Senin, 1 Agustus 2021', status: 'Batal', volume: '10', color: Colors.red,),
                              // RC_Historis(orderid: '123-456-333', alamat: 'Jalan Cut Meutia No 1, Jakarta Barat, 11146', estimasi: 'Senin, 1 Agustus 2021', status: 'Selesai', volume: '10', color: Colors.blue,),
                              // RC_Historis(orderid: '123-456-333', alamat: 'Jalan Cut Meutia No 1, Jakarta Barat, 11146', estimasi: 'Senin, 1 Agustus 2021', status: 'Selesai', volume: '10', color: Colors.blue,),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
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
      ),
    );
  }

  formatTanggal(tanggal) {
    var datestring = tanggal.toString();
    DateTime parseDate =
        new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(datestring);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat("d MMMM yyyy", "id_ID");
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  formatTanggalPickup(tanggal) {
    var datestring = tanggal.toString();
    DateTime parseDate =
    new DateFormat("yyyy-MM-dd' 'HH:mm:ss").parse(datestring);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat("d MMMM yyyy", "id_ID");
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  get_CityID(idcity, i) async {
    Map bodi = {
      "token": _token,
    };
    var body = json.encode(bodi);
    final response = await http.post(
      Uri.parse("http://127.0.0.1:8000/api/admin/cities/$idcity/get"),
      body: body,
    );
    final data = jsonDecode(response.body);
    var cityName = data['city']['name'].toString();
    setState(() {
      namaKota[i] = cityName;
    });
  }

  void refeshData() {
    setState(() {
      id.clear();
      pickup_order_no.clear();
      address.clear();
      pickup_date.clear();
      estimate_volume.clear();
      namaKota.clear();
      postal_code.clear();
      status.clear();
      tanggalOrder.clear();
      get_data();
    });
  }
}

class RC_Historis extends StatelessWidget {
  RC_Historis(
      {this.orderid,
      this.alamat,
      this.tanggalOrder,
      this.status,
      this.volume,
      this.pickup_date, this.latitude, this.longitude});

  String orderid, alamat, tanggalOrder, status, volume, pickup_date, latitude, longitude;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(status=="closed"){
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  Historis_Item_Selesai(orderid: orderid)));
        }else if(status=="cancelled"){
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  Historis_Item_Batal(orderid: orderid)));
        }
        else{
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DetailPermintaan(orderid: orderid, latitude:latitude, longitude:longitude)));
        }
              },
      child: Container(
        margin: EdgeInsets.fromLTRB(30, 5, 30, 5),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(10.0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ID ' + orderid,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      tanggalOrder,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Alamat',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                alamat,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Estimasi Penjemputan',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                pickup_date,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Volume',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        volume + ' Liter',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  if (status == 'closed')
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Selesai",
                        style: TextStyle(color: Colors.green),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Color(0xffECF8ED),
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ))),
                    ),
                  if (status == 'cancelled')
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Batal",
                        style: TextStyle(color: Colors.red),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Color(0xffFBE8E8),
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ))),
                    ),
                  if (status == 'processed')
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Proses",
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Color(0xffE7EEF4),
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ))),
                    ),
                  if (status == 'on_pickup')
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Dalam Perjalanan",
                        style: TextStyle(color: Colors.orange),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Color(0xffFEF5E8),
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ))),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
