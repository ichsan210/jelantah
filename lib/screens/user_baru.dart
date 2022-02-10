// @dart=2.9

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jelantah/constants.dart';
import 'package:jelantah/screens/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserBaru extends StatefulWidget {
  @override
  _UserBaruState createState() => _UserBaruState();
}

class _UserBaruState extends State<UserBaru> {
  var nama = ["Dabiel Ardian", "Muhamad Ichsan", "Dimas Adi", "Steven Sen"];
  var notelp = ["08787876667", "08111112121", "08111112121", "08111112121"];
  var alamat = [
    "Jalan Cut Meutia No 1, Jakarta Barat, 11146",
    "Tanjung Gedong",
    "Tanjung Gedong",
    "Tanjung Gedong"
  ];

  //List cards = new List.generate( 1, (i)=>new RC_UserBaru(nama: isinama, notelp: isinotelp, alamat: isialamat));
  var _token;

  //var first_name=new List(5);
  //List<String> first_name = List<String>.empty(growable: true);
  //var first_name = <String>[];
  bool loading = true;
  var _panjangdata;
  var id = new List();
  var first_name = new List();
  var last_name = new List();
  var address = new List();
  var phone_number = new List();
  var email = new List();
  var namaKota = new List();
  var postal_code = new List();

  //var last_name, address,phone_number;
  var i = 0;

  refresh() {
    setState(() {});
  }

  get_data() async {
    Map bodi = {"token": _token};
    var body = json.encode(bodi);
    final response = await http.post(
      Uri.parse("$kIpAddress/api/admin/users/get"),
      body: body,
    );
    final data = jsonDecode(response.body);
    print(data);
    for (i = 0; i < data['users'].length; i++) {
      if (data['users'][i]['is_approve'] == 0) {
        var idcity = data['users'][i]['addresses'][0]['city_id'];
        print("aaaaaaaaaaaaaaaaaa " + idcity.toString());
        setState(() {
          id.add(data['users'][i]['id']);
          first_name.add(data['users'][i]['first_name']);
          last_name.add(data['users'][i]['last_name']);
          address.add(data['users'][i]['addresses'][0]['address']);
          email.add(data['users'][i]['email']);
          get_CityID(idcity);
          phone_number.add(data['users'][i]['addresses'][0]['phone_number']);
          postal_code.add(data['users'][i]['addresses'][0]['postal_code']);
        });
        print("aaa" + i.toString());
      }
    }
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        loading = false;
      });
    });
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
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    if (loading)
      return Scaffold(
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
                "Permintaan User Baru",
                style: TextStyle(
                  color: Colors.blue, // 3
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0.0),
          body: Center(child: CircularProgressIndicator()));
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
                "Permintaan User Baru",
                style: TextStyle(
                  color: Colors.blue, // 3
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0.0),
          body: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              FutureBuilder<dynamic>(
                // async work
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Text('Loading....');
                    default:
                      if (snapshot.hasError)
                        return Text('Error: ${snapshot.error}');
                      else
                        return Expanded(
                          child: Scrollbar(
                            showTrackOnHover: true,
                            isAlwaysShown: true,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  for (i = 0; i < first_name.length; i++)
                                    RC_UserBaru(
                                        nama: first_name[i],
                                        nama_belakang: last_name[i],
                                        notelp: phone_number[i],
                                        alamat: address[i],
                                        postal_code: postal_code[i],
                                        email: email[i],
                                        namaKota: namaKota[i],
                                        id: id[i],
                                        token: _token)
                                  //   // RC_UserBaru(nama: 'Dabiel Ardian', notelp: '08787876667', alamat: 'Jalan Cut Meutia No 1, Jakarta Barat, 11146',),
                                  //   // RC_UserBaru(nama: 'Muhamad Ichsan', notelp: '08111112121', alamat: 'Tanjung Gedong',),
                                  //   // RC_UserBaru(nama: 'Dimas Adi', notelp: '0822222222', alamat: 'Tanggerang Selatan',),
                                  //   // RC_UserBaru(nama: 'Steven Sen', notelp: '0833333333', alamat: 'Jakarta Barat',),
                                ],
                              ),
                            ),
                          ),
                        );
                  }
                },
              ),
              SizedBox(
                height: 10,
              ),
            ],
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
      Uri.parse("$kIpAddress/api/admin/cities/$idcity/get"),
      body: body,
    );
    final data = jsonDecode(response.body);
    var cityName = data['city']['name'].toString();
    print(cityName + i.toString());
    setState(() {
      namaKota.add(cityName);
    });
  }

// @override
// Widget build(BuildContext context) {
//   return FutureBuilder<dynamic>(
//     future: get_data(), // function where you call your api
//     builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {  // AsyncSnapshot<Your object type>
//       if( snapshot.connectionState == ConnectionState.waiting){
//         return  Center(child: Text('Please wait its loading...'));
//       }else{
//         // if (snapshot.hasError)
//         //   return Center(child: Text('Error: ${snapshot.error}'));
//         // else
//           return Center(
//             child: Container(
//               // width: kIsWeb ? 500.0 : double.infinity,
//               child: Scaffold(
//                 appBar: AppBar(
//                     titleSpacing: 0,
//                     leading: IconButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       color: Colors.blue,
//                       icon: Icon(Icons.keyboard_arrow_left, size: 30,),
//                     ),
//                     title: Text(
//                       "User Baru",
//                       style: TextStyle(
//                         color: Colors.blue, // 3
//                       ),
//                     ),
//                     backgroundColor: Colors.transparent,
//                     elevation: 0.0),
//                 body: Column(
//                   children: [
//                     SizedBox(height: 10,),
//                     Expanded(
//                       child: Scrollbar(
//                         showTrackOnHover: true,
//                         isAlwaysShown: true,
//                         child: SingleChildScrollView(
//                           child: Column(
//                             children: [
//                               for(i = 0; i < _panjangdata; i++)
//                                 RC_UserBaru(nama: first_name[i], notelp: phone_number[i], alamat: address[i])
//                               //   // RC_UserBaru(nama: 'Dabiel Ardian', notelp: '08787876667', alamat: 'Jalan Cut Meutia No 1, Jakarta Barat, 11146',),
//                               //   // RC_UserBaru(nama: 'Muhamad Ichsan', notelp: '08111112121', alamat: 'Tanjung Gedong',),
//                               //   // RC_UserBaru(nama: 'Dimas Adi', notelp: '0822222222', alamat: 'Tanggerang Selatan',),
//                               //   // RC_UserBaru(nama: 'Steven Sen', notelp: '0833333333', alamat: 'Jakarta Barat',),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 10,),
//                   ],
//                 ),
//               ),
//             ),
//           );  // snapshot.data  :- get your object which is pass from your downloadData() function
//       }
//     },
//   );
// }

}

class RC_UserBaru extends StatelessWidget {
  RC_UserBaru(
      {this.nama,
      this.nama_belakang,
      this.notelp,
      this.alamat,
      this.email,
      this.id,
      this.token,
      this.postal_code,
      this.namaKota});

  String nama,
      nama_belakang,
      notelp,
      alamat,
      token,
      email,
      postal_code,
      namaKota;
  int id;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(45), topRight: Radius.circular(45)),
            ),
            backgroundColor: Colors.white,
            context: context,
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 50,
                              child: Divider(
                                color: Colors.blue,
                                thickness: 5,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          nama + " " + nama_belakang,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          child: Divider(color: Colors.blue),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Alamat',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          alamat + ", "+namaKota+", "+ postal_code,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'No Telp',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          notelp,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
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
                              child: Text('Setujui',
                                  style: TextStyle(color: Colors.white))),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextButton(
                              onPressed: () {
                                showAlertDialog2(context);
                              },
                              child: Text('Tolak',
                                  style: TextStyle(color: Colors.white))),
                        ),
                      ],
                    )
                  ],
                ),
              );
            });
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(30, 15, 30, 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                nama + " " + nama_belakang,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                alamat + ", " + namaKota + ", " + postal_code,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                email,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                notelp,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
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
        isApprove();
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (c, a1, a2) => UserBaru(),
            transitionsBuilder: (c, anim, a2, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: Duration(milliseconds: 300),
          ),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Konfirmasi"),
      content: Text("Konfirmasi akun baru?"),
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

  void showAlertDialog2(BuildContext context) {
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
        delete();
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (c, a1, a2) => UserBaru(),
            transitionsBuilder: (c, anim, a2, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: Duration(milliseconds: 300),
          ),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Konfirmasi"),
      content: Text("Tolak & hapus akun baru?"),
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

  isApprove() async {
    Map bodi = {"token": token, "is_approve": 1};
    var body = json.encode(bodi);
    final response = await http.post(
      Uri.parse("$kIpAddress/api/admin/users/$id/is_approve/put"),
      body: body,
    );
    final data = jsonDecode(response.body);
    print(data);
  }

  delete() async {
    Map bodi = {"token": token, "is_approve": 1};
    var body = json.encode(bodi);
    final response = await http.post(
      Uri.parse("$kIpAddress/api/admin/users/$id/delete"),
      body: body,
    );
    final data = jsonDecode(response.body);
    print(data);
  }
}
