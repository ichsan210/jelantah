// @dart=2.9

import 'dart:convert';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jelantah/constants.dart';
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

  var link_url = new List();
  var link_label = new List();
  var link_active = new List();

  bool loading = true;

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
  var latitude = new List();
  var longitude = new List();

  get_data() async {
    Map bodi = {
      "token": _token,
      "status": ["pending", "change_date"],
      "start_date": null,
      "end_date": null
    };
    var body = json.encode(bodi);
    final response = await http.post(
      Uri.parse("$kIpAddress/api/admin/pickup_orders/get"),
      body: body,
    );
    final data = jsonDecode(response.body);
    for (i = 0; i < data['pickup_orders']['links'].length; i++) {
      setState(() {
        link_url.add(data['pickup_orders']['links'][i]["url"]);
        if(data['pickup_orders']['links'][i]["label"]=="&laquo; Previous"){
          link_label.add("< Previous");
        }else if (data['pickup_orders']['links'][i]["label"]=="Next &raquo;"){
          link_label.add("Next >");
        }else{
          link_label.add(data['pickup_orders']['links'][i]["label"]);
        }
        link_active.add(data['pickup_orders']['links'][i]["active"]);
      });
    }
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
        estimate_volume.add(
            data['pickup_orders']['data'][i]['estimate_volume'].toString());
        status.add(data['pickup_orders']['data'][i]['status']);
        tanggalOrder.add(formatTanggal(tanggal));
        latitude.add(data['pickup_orders']['data'][i]['latitude'].toString());
        longitude.add(data['pickup_orders']['data'][i]['longitude'].toString());
      });
    }
  }

  get_data_page(link_url_pilih) async{
    await refresh_data();
    var pesan = await data_api(link_url_pilih);
    print(pesan);
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
    setState((){ loading = false; });
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
    if(loading) return Scaffold(
        appBar: AppBar(
            titleSpacing: 0,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginPage()));
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
            elevation: 0.0),body: Center(child: CircularProgressIndicator()));

    return Center(
      child: Container(
        // width: kIsWeb ? 500.0 : double.infinity,
        child: Scaffold(
          appBar: AppBar(
              titleSpacing: 0,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginPage()));
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
                                latitude: latitude[i],
                                longitude: longitude[i],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
                    height: 20,
                    child: Row(
                      children: [
                        for (var i = 0; i < link_label.length; i++)
                          RC_Pagination(
                            link_label: link_label[i],
                            link_active: link_active[i],
                            link_url: link_url[i],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container RC_Pagination({link_active, link_label, link_url}) {
    return Container(
      margin: EdgeInsets.only(right: 5),
      child: TextButton(
        onPressed: () {
          Future.delayed(const Duration(milliseconds: 2000), () {
            if(isRedundentClick(DateTime.now())){
              print('hold on, processing');
              return;
            }
            setState(() {
              if (link_url != null && link_active != true) {
                setState((){ loading = true; });
                get_data_page(link_url);
              }
            });
          });
        },
        child: Text(link_label),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              link_active == true ? Color(0xffE7EEF4) : Color(0xffFFFFFF),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ))),
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
      Uri.parse("$kIpAddress/api/admin/cities/$idcity/get"),
      body: body,
    );
    final data = jsonDecode(response.body);
    var cityName = data['city']['name'].toString();
    setState(() {
      namaKota[i] = cityName;
    });
  }

  refresh_data() {
    link_url.clear();
    link_label.clear();
    link_active.clear();
    id.clear();
    pickup_order_no.clear();
    address.clear();
    pickup_date.clear();
    estimate_volume.clear();
    namaKota.clear();
    postal_code.clear();
    status.clear();
    tanggalOrder.clear();
    latitude.clear();
    longitude.clear();
  }

  data_api(link_url_pilih) async{
    Map bodi = {
      "token": _token,
      "status": ["pending", "change_date"],
      "start_date": null,
      "end_date": null
    };
    var body = json.encode(bodi);
    final response = await http.post(
      Uri.parse(link_url_pilih),
      body: body,
    );
    final data = jsonDecode(response.body);

    Future.delayed(const Duration(milliseconds: 3000), () {
    for (i = 0; i < data['pickup_orders']['links'].length; i++) {
      setState(() {
        link_url.add(data['pickup_orders']['links'][i]["url"]);
        if(data['pickup_orders']['links'][i]["label"]=="&laquo; Previous"){
          link_label.add("< Previous");
        }else if (data['pickup_orders']['links'][i]["label"]=="Next &raquo;"){
          link_label.add("Next >");
        }else{
          link_label.add(data['pickup_orders']['links'][i]["label"]);
        }
        link_active.add(data['pickup_orders']['links'][i]["active"]);
      });
    }
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
          estimate_volume.add(
              data['pickup_orders']['data'][i]['estimate_volume'].toString());
          status.add(data['pickup_orders']['data'][i]['status']);
          tanggalOrder.add(formatTanggal(tanggal));
          latitude.add(data['pickup_orders']['data'][i]['latitude'].toString());
          longitude
              .add(data['pickup_orders']['data'][i]['longitude'].toString());
        });
      }
    setState((){ loading = false; });
    });
    return "tes";
  }

  DateTime loginClickTime;

  bool isRedundentClick(DateTime currentTime){
    if(loginClickTime==null){
      loginClickTime = currentTime;
      print("first click");
      return false;
    }
    print('diff is ${currentTime.difference(loginClickTime).inSeconds}');
    if(currentTime.difference(loginClickTime).inSeconds<10){//set this difference time in seconds
      return true;
    }

    loginClickTime = currentTime;
    return false;
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
  RC_PermintaanPenjemputan(
      {this.orderid,
      this.alamat,
      this.estimasi,
      this.status,
      this.volume,
      this.tanggalEstimasi,
      this.tanggalOrder,
      this.namaKota,
      this.postal_code,
      this.latitude,
      this.longitude});

  String orderid,
      alamat,
      estimasi,
      status,
      volume,
      tanggalOrder,
      namaKota,
      postal_code,
      latitude,
      longitude;
  Container tanggalEstimasi;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetailPermintaan(
                orderid: orderid, latitude: latitude, longitude: longitude)));
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
                alamat + ", " + namaKota + ", " + postal_code,
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
