// @dart=2.9
import 'dart:convert';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:jelantah/screens/historis.dart';
import 'package:jelantah/screens/permintaan_penjemputan.dart';
import 'package:jelantah/screens/ubah_permintaan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jelantah/screens/historis_item.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jelantah/screens/historis_item_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DetailPermintaan extends StatefulWidget {
  final String orderid, latitude, longitude;

  DetailPermintaan(
      {Key key,
      String this.orderid,
      String this.latitude,
      String this.longitude})
      : super(key: key);

  @override
  _DetailPermintaanState createState() => _DetailPermintaanState();
}

class _DetailPermintaanState extends State<DetailPermintaan> {
  final Set<Marker> _markers = {};
  final _key = new GlobalKey<FormState>();

  var id = "";
  var pickup_order_no = "";
  var address = "";
  var pickup_date = "";
  var estimate_volume = "";
  var status = "";
  var tanggalOrder = "";
  var driver_id = "";
  var postal_code = "";
  var namaKota = "";
  var latitude = 0.0;
  var longitude = 0.0;
  var _token;
  var i;

  String alasan;

  //var _currentPosition = LatLng(latitude, longitude);

  check() {
    print("jalan");
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      save();
    }
  }

  save() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _token = preferences.getString("token");
    var orderid = widget.orderid;
    var response;
    if(status=="pending"){
      Map bodi = {"token": _token, "reject_reason": alasan};
      var body = json.encode(bodi);
      response = await http.post(
        Uri.parse(
            "http://127.0.0.1:8000/api/admin/pickup_orders/$orderid/reject/post"),
        body: body,
      );
    }else{
      Map bodi = {"token": _token, "cancel_reason": alasan};
      var body = json.encode(bodi);
      response = await http.post(
        Uri.parse(
            "http://127.0.0.1:8000/api/admin/pickup_orders/$orderid/cancel/post"),
        body: body,
      );
    }
    final data = jsonDecode(response.body);
    String statusjson = data['status'];
    String message = data['message'];
    if (statusjson == "success") {
      setState(() {
        if(status=="pending"){
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => PermintaanPenjemputan()));
        }else{
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => Historis()));
        }
      });
    } else {
      print(message);
    }
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

  get_data() async {
    var orderid = widget.orderid;
    Map bodi = {
      "token": _token,
    };
    var body = json.encode(bodi);
    final response = await http.post(
      Uri.parse("http://127.0.0.1:8000/api/admin/pickup_orders/$orderid/get"),
      body: body,
    );
    final data = jsonDecode(response.body);
    var tanggal = data['pickup_orders']['created_at'];
    var idcity = data['pickup_orders']['city_id'];
    var tanggalpickup = data['pickup_orders']['pickup_date'];
    var idDriver = data['pickup_orders']['driver_id'];
    setState(() {
      id = data['pickup_orders']['id'].toString();
      pickup_order_no = data['pickup_orders']['pickup_order_no'].toString();
      address = data['pickup_orders']['address'];
      get_CityID(idcity);
      if (data['pickup_orders']['pickup_date'] == null) {
        pickup_date = "-";
      } else {
        pickup_date = formatTanggalPickup(tanggalpickup);
      }
      if (data['pickup_orders']['driver_id'] == null) {
        driver_id = "-";
      } else {
        namaDriver(idDriver);
      }
      postal_code = data['pickup_orders']['postal_code'];
      estimate_volume = data['pickup_orders']['estimate_volume'].toString();
      status = data['pickup_orders']['status'];
      var latitudes = data['pickup_orders']['latitude'].toString();
      latitude = double.parse(latitudes);
      var longitudes = data['pickup_orders']['longitude'].toString();
      longitude = double.parse(longitudes);
      tanggalOrder = formatTanggal(tanggal);
    });
    print(data);
    // print(latitude);
    // print(longitude);
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
    _markers.add(
      Marker(
        markerId: MarkerId("$latitude, $longitude"),
        position: LatLng(
            double.parse(widget.latitude), double.parse(widget.longitude)),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
  }

  @override
  void initState() {
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
                "Detail Permintaan",
                style: TextStyle(
                  color: Colors.blue, // 3
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0.0),
          body: FutureBuilder<dynamic>(
            // async work
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Text('Loading....');
                default:
                  if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
                  else
                    return Column(
                      children: [
                        Expanded(
                          child: GoogleMap(
                            mapType: MapType.terrain,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(double.parse(widget.latitude),
                                  double.parse(widget.longitude)),
                              zoom: 18.0,
                            ),
                            markers: _markers,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            margin: EdgeInsets.all(30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.only(
                                    top: 10,
                                    bottom: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(10.0)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'ID ' + pickup_order_no,
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
                                Container(
                                  child: Divider(color: Colors.blue),
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
                                  address +
                                      ", " +
                                      namaKota +
                                      ", " +
                                      postal_code,
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
                                Text(
                                  'Driver',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  driver_id,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                          estimate_volume + ' Liter',
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
                                          style: TextStyle(
                                              color: Color(0xFF125894)),
                                        ),
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Color(0xFFE7EEF4)),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ))),
                                      ),
                                    if (status == 'processed')
                                      TextButton(
                                        onPressed: () {},
                                        child: Text(
                                          "Proses",
                                          style: TextStyle(
                                              color: Colors.blueAccent),
                                        ),
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              Color(0xffE7EEF4),
                                            ),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
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
                                SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          showAlertDialog(context);
                                        },
                                        child: Icon(
                                          FlutterIcons.ban_faw5s,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Color(0xff2f9efc),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: TextButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          UbahPermintaan(
                                                            pickup_order_no:
                                                                pickup_order_no,
                                                            address: address,
                                                            namaKota: namaKota,
                                                            postal_code:
                                                                postal_code,
                                                            pickup_date:
                                                                pickup_date,
                                                            estimate_volume:
                                                                estimate_volume,
                                                            tanggalOrder:
                                                                tanggalOrder,
                                                            driver_id:
                                                                driver_id,
                                                          )));
                                            },
                                            child: Text('Ubah Data',
                                                style: TextStyle(
                                                    color: Colors.white))),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
              }
            },
          ),
        ),
      ),
    );
  }

  get_CityID(idcity) async {
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
      namaKota = cityName;
    });
    print(cityName);
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

  namaDriver(idDriver) async {
    Map bodi = {
      "token": _token,
    };
    var body = json.encode(bodi);
    final response = await http.post(
      Uri.parse("http://127.0.0.1:8000/api/admin/drivers/$idDriver/get"),
      body: body,
    );
    final data = jsonDecode(response.body);
    var first_name = data['user']['first_name'];
    var last_name = data['user']['last_name'];
    var phone_number = data['user']['phone_number'];
    var dataDriver =
        first_name + " " + last_name + " " + "(" + phone_number + ")";
    setState(() {
      driver_id = dataDriver;
    });
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("kembali"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Lanjutkan"),
      onPressed: () {
        check();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Konfirmasi Pembatalan"),
      content: Form(
        key: _key,
        child: TextFormField(
          validator: (e) {
            if (e.isEmpty) {
              return "Masukan alasan pembatalan";
            }
          },
          onSaved: (e) => alasan = e,
          decoration: InputDecoration(
            hintText: "Masukan alasan",
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
      ),
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
