// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'; import 'package:jelantah/constants.dart';
import 'package:intl/intl.dart';
import 'package:jelantah/screens/master_user.dart';
import 'package:jelantah/screens/tambah_balance.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MasterUserBalance extends StatefulWidget {
  final id, first_name, last_name;

  MasterUserBalance({
     Key key,
     this.id,
    this.first_name,
    this.last_name,
  }) : super(key: key);

  @override
  _MasterUserBalanceState createState() => _MasterUserBalanceState();
}

class _MasterUserBalanceState extends State<MasterUserBalance> {
  var _token, i;
  var amount = new List();
  var type = new List();
  var tanggal = new List();
  var id = new List();

  int balanceCredit=0;
  int balanceDebit=0;
  int totalBalance=0;

  formatTanggal(tanggalBalance) {
    var datestring = tanggalBalance.toString();
    DateTime parseDate =
    new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(datestring);
    var inputDate = DateTime.parse(parseDate.add(Duration(hours: 7)).toString());
    var outputFormat = DateFormat("d MMMM yyyy HH:mm", "id_ID");
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  get_data() async {
    var userid = widget.id;
    Map bodi = {"token": _token, "user_id": userid};
    var body = json.encode(bodi);
    final response = await http.post(
      Uri.parse("$kIpAddress/api/admin/balance_history/get"),
      body: body,
    );
    final data = jsonDecode(response.body);
    for (i = 0; i < data['balance_history'].length; i++) {
      var tanggalBalance = data['balance_history'][i]['created_at'];
      var jumlah = data['balance_history'][i]['amount'];
      var transaksi = data['balance_history'][i]['type'];
      setState(() {
        id.insert(0,data['balance_history'][i]['id']);
        amount.insert(0,jumlah);
        type.insert(0,transaksi);
        tanggal.insert(0,formatTanggal(tanggalBalance));
        if(transaksi=="credit"){
          balanceCredit = balanceCredit+int.parse(jumlah.toString());
        }
        if(transaksi=="debit"){
          balanceDebit = balanceDebit+int.parse(jumlah.toString());
        }
      });
    }
    setState(() {
      totalBalance = balanceCredit-balanceDebit;
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
    // TODO: implement initState
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
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MasterUser()));
                },
                color: Colors.blue,
                icon: Icon(
                  Icons.keyboard_arrow_left,
                  size: 30,
                ),
              ),
              title: Text(
                "Balance",
                style: TextStyle(
                  color: Colors.blue, // 3
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0.0),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
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
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.first_name+ " " + widget.last_name,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(width: 5,),
                          Text(
                            "Total Balance : Rp."+totalBalance.toString(),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => TambahBalance(id:widget.id, first_name:widget.first_name, last_name:widget.last_name)));
                        },
                        child: Text(
                          "+ Tambah Transaksi",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Scrollbar(
                showTrackOnHover: true,
                isAlwaysShown: true,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (i = 0; i < amount.length; i++)
                        RC_UserBalance(
                          id:id[i],
                          iduser:widget.id,
                          first_name:widget.first_name,
                          last_name:widget.last_name,
                          amount: amount[i],
                          type: type[i],
                          tanggal: tanggal[i],

                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RC_UserBalance extends StatelessWidget {
  RC_UserBalance({this.amount, this.type, this.tanggal, this.id, this.iduser, this.first_name, this.last_name});

  String type, tanggal, first_name, last_name;
  int amount, id, iduser;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 250,
                    child: Text(
                      tanggal,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Text(
                    type,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  if(type=="credit")
                    Text(
                      "+ "+amount.toString(),
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  if(type=="debit")
                    Text(
                      "- "+amount.toString(),
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  SizedBox(width: 10,),
                  GestureDetector(
                    onTap: (){
                      showAlertDialog2(context);
                    },
                    child: Icon(
                      Icons.delete,
                      size: 25.0,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Divider(color: Colors.blue,)
        ],
      ),
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
            pageBuilder: (c, a1, a2) => MasterUserBalance(id:iduser, first_name:first_name, last_name:last_name),
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
      content: Text("Hapus transaksi ini?"),
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

  delete() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString("token");

    Map bodi = {"token": token};
    var body = json.encode(bodi);
    final response = await http.post(
      Uri.parse("$kIpAddress/api/admin/balance_history/$id/delete"),
      body: body,
    );
    final data = jsonDecode(response.body);
    print(data);
  }
}
