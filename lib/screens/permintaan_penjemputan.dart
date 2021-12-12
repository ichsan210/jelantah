// @dart=2.9

import 'dart:convert';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jelantah/screens/detail_permintaan.dart';
import 'package:jelantah/screens/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jelantah/screens/historis_item.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jelantah/screens/historis_item_map.dart';

class PermintaanPenjemputan extends StatefulWidget {
  @override
  _PermintaanPenjemputanState createState() => _PermintaanPenjemputanState();
}

class _PermintaanPenjemputanState extends State<PermintaanPenjemputan> {
  var orderid = ["123-456-789", "123-456-789", "123-456-789", "123-456-789"];
  var alamat = [
    "Jalan Cut Meutia No 1, Jakarta Barat, 11146",
    "Jalan Cut Meutia No 1, Jakarta Barat, 11146",
    "Jalan Cut Meutia No 1, Jakarta Barat, 11146",
    "Jalan Cut Meutia No 1, Jakarta Barat, 11146",
  ];
  var estimasi = [
    "-",
    "-",
    "-",
    "-",
  ];

  // var status = [
  //   "Selesai",
  //   "Selesai",
  //   "Selesai",
  //   "Selesai",
  // ];
  var volume = [
    "10",
    "10",
    "10",
    "10",
  ];

  // List _isikota = ["Semua Kota", "Jakarta"];
  // List _isiStatus = ["Semua Status", "Berhasil"];
  // late List<DropdownMenuItem<String>> _dropdownKota, _dropdownStatus;
  // late String _kotaterpilih, _statusterpilih;

  DateTime selectedDate1 = DateTime.now();

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

  get_data() async {
    Map bodi = {
      "token": _token,
      "status": ["pending", "change_date"],
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
      setState(() {
        id.add(data['pickup_orders']['data'][i]['id'].toString());
        pickup_order_no.add(
            data['pickup_orders']['data'][i]['pickup_order_no'].toString());
        address.add(data['pickup_orders']['data'][i]['address']);
        postal_code.add(data['pickup_orders']['data'][i]['postal_code']);
        namaKota.add("");
        get_CityID(idcity, i);
        pickup_date.add("-");
        estimate_volume.add(data['pickup_orders']['data'][i]['estimate_volume'].toString());
        status.add(data['pickup_orders']['data'][i]['status']);
        tanggalOrder.add(formatTanggal(tanggal));
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
    // _dropdownKota = getDropdownKota();
    // _kotaterpilih = _dropdownKota[0].value!;
    //
    // _dropdownStatus = getDropdownStatus();
    // _statusterpilih = _dropdownStatus[0].value!;
    super.initState();
    getPref();
  }

  // List<DropdownMenuItem<String>> getDropdownKota() {
  //   List<DropdownMenuItem<String>> items = [];
  //   for (String kota in _isikota) {
  //     items.add(new DropdownMenuItem(value: kota, child: new Text(kota)));
  //   }
  //   return items;
  // }
  //
  // List<DropdownMenuItem<String>> getDropdownStatus() {
  //   List<DropdownMenuItem<String>> items = [];
  //   for (String status in _isiStatus) {
  //     items.add(new DropdownMenuItem(value: status, child: new Text(status)));
  //   }
  //   return items;
  // }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        // width: kIsWeb ? 500.0 : double.infinity,
        child: Scaffold(
          appBar: AppBar(
              titleSpacing: 0,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => LoginPage()));
                },
                color: Colors.blue,
                icon: Icon(
                  Icons.keyboard_arrow_left,
                  size: 30,
                ),
              ),
              title: Text(
                "Permintaan Penjemputan",
                style: TextStyle(
                  color: Colors.blue, // 3
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0.0),
          body: Center(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Scrollbar(
                      showTrackOnHover: true,
                      isAlwaysShown: true,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            for (var i = 0; i < id.length; i++)
                              RC_PermintaanPenjemputan(
                                orderid: pickup_order_no[i],
                                alamat: address[i],
                                namaKota: namaKota[i],
                                postal_code: postal_code[i],
                                estimasi: pickup_date[i],
                                status: status[i],
                                volume: estimate_volume[i],
                                tanggalOrder: tanggalOrder[i],
                                tanggalEstimasi: tanggalEstimasi(context),
                              ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container tanggalEstimasi(BuildContext context) {
    return Container(
      margin: kIsWeb
          ? EdgeInsets.only(left: 135, right: 135)
          : EdgeInsets.only(left: 85, right: 85),
      color: Colors.white,
      child: SizedBox(
        height: 25,
        child: OutlineButton(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "${DateFormat("d MMMM yyyy", "id_ID").format(selectedDate1)}",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              Icon(
                Icons.arrow_drop_down_sharp,
                color: Colors.black,
              ),
            ],
          ),
          onPressed: () => _selectDate1(context),
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
      namaKota[i]=cityName;
    });
    print(cityName);
  }

// void changedropdownKota(String? kotaTerpilih) {
//   setState(() {
//     _kotaterpilih = kotaTerpilih!;
//   });
// }

// void changedropdownStatus(String? statusTerpilih) {
//   setState(() {
//     _statusterpilih = statusTerpilih!;
//   });
// }
}

class RC_PermintaanPenjemputan extends StatelessWidget {
  RC_PermintaanPenjemputan({
    this.orderid,
    this.alamat,
    this.estimasi,
    this.status,
    this.volume,
    this.tanggalEstimasi,
    this.tanggalOrder,
    this.namaKota,
    this.postal_code,
  });

  String orderid, alamat, estimasi, status, volume, tanggalOrder, namaKota, postal_code;
  Container tanggalEstimasi;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () {
      //   showModalBottomSheet(
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.only(
      //             topLeft: Radius.circular(45), topRight: Radius.circular(45)),
      //       ),
      //       backgroundColor: Colors.white,
      //       context: context,
      //       builder: (context) {
      //         return StatefulBuilder(
      //           builder: (BuildContext context, StateSetter setState) {
      //             return Container(
      //               padding: EdgeInsets.all(30),
      //               child: Column(
      //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                 children: [
      //                   Column(
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     children: [
      //                       Row(
      //                         mainAxisAlignment: MainAxisAlignment.center,
      //                         children: [
      //                           Container(
      //                             width: 50,
      //                             child: Divider(
      //                               color: Colors.blue,
      //                               thickness: 5,
      //                             ),
      //                           ),
      //                         ],
      //                       ),
      //                       SizedBox(
      //                         height: 15,
      //                       ),
      //                       Text(
      //                         "ID " + orderid,
      //                         style: TextStyle(
      //                           fontSize: 20,
      //                           color: Colors.black,
      //                           fontWeight: FontWeight.bold,
      //                         ),
      //                       ),
      //                       SizedBox(
      //                         height: 15,
      //                       ),
      //                       Container(
      //                         child: Divider(color: Colors.blue),
      //                       ),
      //                       SizedBox(
      //                         height: 15,
      //                       ),
      //                       Text(
      //                         'Estimasi Penjemputan',
      //                         style: TextStyle(
      //                           fontSize: 15,
      //                           color: Colors.grey,
      //                           fontWeight: FontWeight.bold,
      //                         ),
      //                       ),
      //                       tanggalEstimasi,
      //                       SizedBox(
      //                         height: 15,
      //                       ),
      //                       Text(
      //                         'No Telp',
      //                         style: TextStyle(
      //                           fontSize: 15,
      //                           color: Colors.grey,
      //                           fontWeight: FontWeight.bold,
      //                         ),
      //                       ),
      //                       Text(
      //                         "081111",
      //                         style: TextStyle(
      //                           fontSize: 15,
      //                           color: Colors.black,
      //                           fontWeight: FontWeight.bold,
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                   Column(
      //                     crossAxisAlignment: CrossAxisAlignment.stretch,
      //                     children: [
      //                       Container(
      //                         height: 50,
      //                         decoration: BoxDecoration(
      //                           color: Color(0xff2f9efc),
      //                           borderRadius: BorderRadius.circular(10),
      //                         ),
      //                         child: TextButton(
      //                             onPressed: () {
      //                               //showAlertDialog(context);
      //                             },
      //                             child: Text('Setujui',
      //                                 style: TextStyle(color: Colors.white))),
      //                       ),
      //                       SizedBox(
      //                         height: 10,
      //                       ),
      //                       Container(
      //                         height: 50,
      //                         decoration: BoxDecoration(
      //                           color: Colors.red,
      //                           borderRadius: BorderRadius.circular(10),
      //                         ),
      //                         child: TextButton(
      //                             onPressed: () {
      //                               //showAlertDialog2(context);
      //                             },
      //                             child: Text('Tolak',
      //                                 style: TextStyle(color: Colors.white))),
      //                       ),
      //                     ],
      //                   )
      //                 ],
      //               ),
      //             );
      //           },
      //         );
      //       });
      // },
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DetailPermintaan(orderid:orderid)));
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
                alamat+", "+namaKota+", "+postal_code,
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
                estimasi,
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
                  if (status == 'pending')
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Pending",
                        style: TextStyle(color: Color(0xFF125894)),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xFFE7EEF4)),
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
