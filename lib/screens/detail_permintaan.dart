// @dart=2.9
import 'dart:convert';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jelantah/screens/ubah_permintaan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jelantah/screens/historis_item.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jelantah/screens/historis_item_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DetailPermintaan extends StatefulWidget {
  final String orderid;

  DetailPermintaan({ Key key, String this.orderid})
      : super(key: key);

  @override
  _DetailPermintaanState createState() => _DetailPermintaanState();
}

class _DetailPermintaanState extends State<DetailPermintaan> {
  final Set<Marker> _markers = {};
  final LatLng _currentPosition =
      LatLng(-6.1874211698185695, 106.83344419697433);

  var id="";
  var pickup_order_no="";
  var address="";
  var pickup_date="";
  var estimate_volume="";
  var status="";
  var tanggalOrder="";
  var driver_id="";
  var postal_code="";
  var namaKota="";
  var _token;
  var i;


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
    setState(() {
      id = data['pickup_orders']['id'].toString();
      pickup_order_no = data['pickup_orders']['pickup_order_no'].toString();
      address = data['pickup_orders']['address'];
      get_CityID(idcity);
      pickup_date = "-";
      driver_id = "-";
      postal_code = data['pickup_orders']['postal_code'];
      estimate_volume = data['pickup_orders']['estimate_volume'].toString();
      status = data['pickup_orders']['status'];
      tanggalOrder = formatTanggal(tanggal);
    });
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
    get_data();
  }

  @override
  void initState() {
    super.initState();
    getPref();
    _markers.add(
      Marker(
        markerId: MarkerId("-6.1874211698185695, 106.83344419697433"),
        position: _currentPosition,
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
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
                            mapType: MapType.normal,
                            initialCameraPosition: CameraPosition(
                              target: _currentPosition,
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
                                  address+", "+namaKota+", "+postal_code,
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
                                  ],
                                ),
                                SizedBox(height: 30,),
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Color(0xff2f9efc),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) =>
                                                UbahPermintaan(pickup_order_no: pickup_order_no, address:address, namaKota:namaKota, postal_code:postal_code, pickup_date:pickup_date, estimate_volume:estimate_volume, tanggalOrder:tanggalOrder, driver_id: driver_id,)));

                                      },
                                      child: Text('Ubah Data',
                                          style:
                                          TextStyle(color: Colors.white))),
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
      namaKota=cityName;
    });
    print(cityName);
  }
}
