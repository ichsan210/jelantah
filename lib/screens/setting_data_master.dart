import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:jelantah/screens/login_page.dart';
import 'package:jelantah/screens/master_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jelantah/screens/master_admin.dart';

class SettingDataMaster extends StatefulWidget {

  @override
  _SettingDataMasterState createState() => _SettingDataMasterState();
}

class _SettingDataMasterState extends State<SettingDataMaster> {
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
                icon: Icon(Icons.keyboard_arrow_left, size: 30,),
              ),
              title: Text(
                "Data Master",
                style: TextStyle(
                  color: Colors.blue, // 3
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0.0),
          body: Scrollbar(
            showTrackOnHover: true,
            isAlwaysShown: true,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  Container(
                    margin: EdgeInsets.fromLTRB(30, 5, 30, 5),
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              FlutterIcons.book_faw5s,
                              size: 30.0,
                              color: Colors.blue,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              'katagori Tutorial',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RawMaterialButton(
                              onPressed: () {
                              },
                              child: Icon(
                                Icons.arrow_forward,
                                size: 30.0,
                                color: Colors.blue,
                              ),
                              padding: EdgeInsets.all(15.0),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(30, 5, 30, 5),
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              FlutterIcons.truck_faw5s,
                              size: 30.0,
                              color: Colors.blue,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              'Driver',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RawMaterialButton(
                              onPressed: () {
                              },
                              child: Icon(
                                Icons.arrow_forward,
                                size: 30.0,
                                color: Colors.blue,
                              ),
                              padding: EdgeInsets.all(15.0),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(30, 5, 30, 5),
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 30.0,
                              color: Colors.blue,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              'Kota',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RawMaterialButton(
                              onPressed: () {
                              },
                              child: Icon(
                                Icons.arrow_forward,
                                size: 30.0,
                                color: Colors.blue,
                              ),
                              padding: EdgeInsets.all(15.0),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(30, 5, 30, 5),
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              size: 30.0,
                              color: Colors.blue,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              'User',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RawMaterialButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => MasterUser()));
                              },
                              child: Icon(
                                Icons.arrow_forward,
                                size: 30.0,
                                color: Colors.blue,
                              ),
                              padding: EdgeInsets.all(15.0),
                            )
                          ],
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
}
