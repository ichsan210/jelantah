import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jelantah/screens/historis_item.dart';

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
  var status = [
    "Selesai",
    "Selesai",
    "Selesai",
    "Selesai",
  ];
  var volume = [
    "10",
    "10",
    "10",
    "10",
  ];

  List _isikota = ["Semua Kota", "Jakarta"];
  List _isiStatus = ["Semua Status", "Berhasil"];
  late List<DropdownMenuItem<String>> _dropdownKota, _dropdownStatus;
  late String _kotaterpilih, _statusterpilih;

  @override
  void initState() {
    _dropdownKota = getDropdownKota();
    _kotaterpilih = _dropdownKota[0].value!;

    _dropdownStatus = getDropdownStatus();
    _statusterpilih = _dropdownStatus[0].value!;
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropdownKota() {
    List<DropdownMenuItem<String>> items = [];
    for (String kota in _isikota) {
      items.add(new DropdownMenuItem(value: kota, child: new Text(kota)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getDropdownStatus() {
    List<DropdownMenuItem<String>> items = [];
    for (String status in _isiStatus) {
      items.add(new DropdownMenuItem(value: status, child: new Text(status)));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: kIsWeb ? 500.0 : double.infinity,
        child: Scaffold(
          appBar: AppBar(
              titleSpacing: 0,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                  color: Colors.blue,
                  icon: Icon(Icons.keyboard_arrow_left, size: 30,),
              ),
              title: Text(
                "Permintaan Penjemputan",
                style: TextStyle(
                  color: Colors.blue, // 3
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0.0),
          body: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 30, top: 20),
                    color: Colors.white,
                    width: 150,
                    child: SizedBox(
                      height: 50,
                      child: OutlineButton(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        onPressed: () {},
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            isExpanded: true,
                            value: _kotaterpilih,
                            items: _dropdownKota,
                            onChanged: changedropdownKota,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 30, top: 20),
                    color: Colors.white,
                    width: 150,
                    child: SizedBox(
                      height: 50,
                      child: OutlineButton(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        onPressed: () {},
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            isExpanded: true,
                            value: _statusterpilih,
                            items: _dropdownStatus,
                            onChanged: changedropdownStatus,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: Scrollbar(
                  showTrackOnHover: true,
                  isAlwaysShown: true,
                  child: SingleChildScrollView(
                    child: Align(
                      child: Column(
                        children: [
                          for (var i = 0; i < orderid.length; i++)
                            RC_PermintaanPenjemputan(
                                orderid: orderid[i],
                                alamat: alamat[i],
                                estimasi: estimasi[i],
                                status: status[i],
                                volume: volume[i])
                          // RC_PermintaanPenjemputan(orderid: '123-456-789', alamat: 'Jalan Cut Meutia No 1, Jakarta Barat, 11146', estimasi: '-', status: 'Selesai', volume: '10',),
                          // RC_PermintaanPenjemputan(orderid: '123-456-111', alamat: 'Jalan Cut Meutia No 1, Jakarta Barat, 11146', estimasi: '-', status: 'Selesai', volume: '10',),
                          // RC_PermintaanPenjemputan(orderid: '123-456-222', alamat: 'Jalan Cut Meutia No 1, Jakarta Barat, 11146', estimasi: '-', status: 'Selesai', volume: '10',),
                          // RC_PermintaanPenjemputan(orderid: '123-456-333', alamat: 'Jalan Cut Meutia No 1, Jakarta Barat, 11146', estimasi: '-', status: 'Selesai', volume: '10',),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed: () {},
            child: Icon(Icons.list),
          ),
        ),
      ),
    );
  }

  void changedropdownKota(String? kotaTerpilih) {
    setState(() {
      _kotaterpilih = kotaTerpilih!;
    });
  }

  void changedropdownStatus(String? statusTerpilih) {
    setState(() {
      _statusterpilih = statusTerpilih!;
    });
  }
}

class RC_PermintaanPenjemputan extends StatelessWidget {
  RC_PermintaanPenjemputan(
      {required this.orderid,
      required this.alamat,
      required this.estimasi,
      required this.status,
      required this.volume});

  String orderid, alamat, estimasi, status, volume;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Historis_Item()));
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(30, 15, 30, 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: const Offset(1.0, 1.0),
              blurRadius: 1.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 5, bottom: 5, right: 10, left: 10),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order ID : ' + orderid,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.chat,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 50,
                ),
                Column(
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
                      volume + ' L',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
