// @dart=2.9
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:intl/intl.dart';
import 'package:jelantah/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jelantah/screens/login_page.dart';
import 'package:jelantah/screens/historis.dart';
import 'package:jelantah/screens/chat_list.dart';
import 'package:jelantah/screens/tutorial.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:jelantah/screens/account.dart';
import 'package:http/http.dart' as http;
import 'package:jelantah/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatRoom extends StatefulWidget {
  final int id;
  final String nama;

  ChatRoom({Key key, this.id, this.nama}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  final _key = new GlobalKey<FormState>();
  var isitext;
  var _token;

  int i;

  var message = new List();
  var image = new List();

  var to_user_id = new List();
  var datetime = new List();

  var link_url = new List();
  var link_label = new List();
  var link_active = new List();

  var isiTextHint = "Tulis Pesan..";

  bool _validate = false;

  String isiBase64string;

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      save();
    }
  }

  save() async {
    if(isitext=="" && isiBase64string==null){

    }
    else{
      Map bodi;
      SharedPreferences preferences = await SharedPreferences.getInstance();
      _token = preferences.getString("token");
      var iduser = widget.id;
      var namauser = widget.nama;
      if(isiBase64string==null){
        bodi = {"token": _token, "message": isitext};
        print("jalan--------------------------------------------");
      }else{
        bodi = {"token": _token, "message": isitext, "image":"data:image/jpeg;base64,"+isiBase64string};
        print(isiBase64string);
      }
      var body = json.encode(bodi);
      final response = await http.post(
        Uri.parse("$kIpAddress/api/admin/chats/$iduser/post"),
        body: body,
      );
      final data = jsonDecode(response.body);
      String status = data['status'];
      String message = data['message'];
      if (status == "success") {
        setState(() {
          print("pesan terkirim"+isitext);
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (c, a1, a2) => ChatRoom(id: iduser, nama: namauser),
              transitionsBuilder: (c, anim, a2, child) =>
                  FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: 10),
            ),
          );
        });
      } else {
        print(message);
      }
    }
  }

  get_data() async {
    var iduser = widget.id;
    print(iduser);
    Map bodi = {"token": _token};
    var body = json.encode(bodi);
    final response = await http.post(
      Uri.parse("$kIpAddress/api/admin/chats/$iduser/get"),
      body: body,
    );
    final data = jsonDecode(response.body);
    for (i = 0; i < data['chats']['links'].length; i++) {
      setState(() {
        link_url.add(data['chats']['links'][i]["url"]);
        if (data['chats']['links'][i]["label"] == "&laquo; Previous") {
          link_label.add("< Previous");
        } else if (data['chats']['links'][i]["label"] == "Next &raquo;") {
          link_label.add("Next >");
        } else {
          link_label.add(data['chats']['links'][i]["label"]);
        }
        link_active.add(data['chats']['links'][i]["active"]);
      });
    }
    for (i = 0; i < data['chats']['data'].length; i++) {
      setState(() {
        message.add(data['chats']['data'][i]['message']);
        if(data['chats']['data'][i]['image']==null){
          image.add("-");
        }else{
          image.add(data['chats']['data'][i]['image']);
        }
        to_user_id.add(data['chats']['data'][i]['to_user_id']);
        datetime
            .add(formatTanggalPickup(data['chats']['data'][i]['created_at']));
      });
    }
    print(data['chats']['data'].length);
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

  ScrollController _scrollController = new ScrollController();

  data_api(link_url_pilih) async {
    Map bodi = {
      "token": _token,
    };
    var body = json.encode(bodi);
    final response = await http.post(
      Uri.parse(link_url_pilih),
      body: body,
    );
    final data = jsonDecode(response.body);

    Future.delayed(const Duration(milliseconds: 2000), () {
      for (i = 0; i < data['chats']['links'].length; i++) {
        setState(() {
          link_url.add(data['chats']['links'][i]["url"]);
          // if(data['pickup_orders']['links'][i]["label"]=="&laquo; Previous"){
          //   link_label.add("< Previous");
          // }else if (data['chats']['links'][i]["label"]=="Next &raquo;"){
          //   link_label.add("Next >");
          // }else{
          //   link_label.add(data['chats']['links'][i]["label"]);
          // }
          // link_active.add(data['chats']['links'][i]["active"]);
        });
      }
      for (i = 0; i < data['chats']['data'].length; i++) {
        setState(() {
          message.add(data['chats']['data'][i]['message']);
          if(data['chats']['data'][i]['image']==null){
            image.add("-");
          }else{
            image.add(data['chats']['data'][i]['image']);
          }
          to_user_id.add(data['chats']['data'][i]['to_user_id']);
          datetime
              .add(formatTanggalPickup(data['chats']['data'][i]['created_at']));
        });
      }
    });
    return "tes";
  }

  final ImagePicker imgpicker = ImagePicker();
  String imagepath = "";

  openImage() async {
    try {
      final pickedFile = await ImagePickerWeb.getImageAsBytes();
      //you can use ImageCourse.camera for Camera capture
      if (pickedFile != null) {
        // imagepath = pickedFile.path;
        // print(imagepath);
        // //output /data/user/0/com.example.testapp/cache/image_picker7973898508152261600.jpg
        //
        // File imagefile = File(imagepath); //convert Path to File
        // Uint8List imagebytes = await imagefile.readAsBytes(); //convert to bytes
        String base64string =
            base64.encode(pickedFile); //convert bytes to base64 string
        //print(base64string);
        /* Output:
              /9j/4Q0nRXhpZgAATU0AKgAAAAgAFAIgAAQAAAABAAAAAAEAAAQAAAABAAAJ3
              wIhAAQAAAABAAAAAAEBAAQAAAABAAAJ5gIiAAQAAAABAAAAAAIjAAQAAAABAAA
              AAAIkAAQAAAABAAAAAAIlAAIAAAAgAAAA/gEoAA ... long string output
              */

        Uint8List decodedbytes = base64.decode(base64string);
        //decode base64 stirng to bytes

        setState(() {
          isiTextHint="Gambar siap dikirim!";
          isiBase64string=base64string;
        });
      }
      else {
        print("No image is selected.");
      }
    }
    catch (e) {
      print("error while picking file.");
    }
  }

  @override
  Widget build(BuildContext context) {
    _scrollController
      ..addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          if (link_url.last != null && link_active.last != true) {
            if (isRedundentClick(DateTime.now())) {
              print('hold on, processing');
              return;
            }
            data_api(link_url.last);
            print("terpanggil");
          }
        }
      });

    return Center(
      child: Container(
        child: Scaffold(
          appBar: AppBar(
              titleSpacing: 0,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ChatList()));
                },
                color: Colors.blue,
                icon: Icon(
                  Icons.keyboard_arrow_left,
                  size: 30,
                ),
              ),
              title: SelectableText(
                widget.nama,
                style: TextStyle(
                  color: Colors.blue, // 3
                ),
              ),
              backgroundColor: Colors.white,
              elevation: 0.0),
          body: Column(
            children: <Widget>[
              Expanded(
                child: Scrollbar(
                  showTrackOnHover: true,
                  child: ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    itemCount: message.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: (to_user_id[index] != widget.id
                            ? EdgeInsets.only(
                                left: 14, right: 60, top: 10, bottom: 10)
                            : EdgeInsets.only(
                                left: 60, right: 14, top: 10, bottom: 10)),
                        child: Align(
                          alignment: (to_user_id[index] != widget.id
                              ? Alignment.topLeft
                              : Alignment.topRight),
                          child: Column(
                            crossAxisAlignment: (to_user_id[index] != widget.id
                                ? CrossAxisAlignment.start
                                : CrossAxisAlignment.end),
                            children: [
                              if(image[index]!="-")
                                GestureDetector(
                                  onTap: () async {
                                    var urllaunchable =
                                    await canLaunch('$kIpAddress'+image[index]); //canLaunch is from url_launcher package
                                    if (urllaunchable) {
                                      await launch('$kIpAddress'+image[index]); //launch is from url_launcher package to launch URL
                                    } else {
                                      print("URL can't be launched.");
                                    }
                                  },
                                  child: Image.network('$kIpAddress'+image[index],height: 150,
                                      fit:BoxFit.fitWidth),
                                ),
                              SizedBox(height: 5,),
                              if(message[index]!="")
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: (to_user_id[index] != widget.id
                                        ? Colors.grey.shade200
                                        : Colors.blue[200]),
                                  ),
                                  padding: EdgeInsets.all(16),
                                  child: SelectableText(
                                    message[index],
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              SelectableText(
                                datetime[index],
                                style: TextStyle(fontSize: 10),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                  height: 60,
                  width: double.infinity,
                  color: Colors.white,
                  child: Form(
                    key: _key,
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            openImage();
                          },
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.lightBlue,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TextFormField(
                            inputFormatters: [
                              new LengthLimitingTextInputFormatter(255),
                            ],
                            onSaved: (e) => isitext = e,
                            decoration: InputDecoration(
                                hintText: isiTextHint,
                                hintStyle: TextStyle(color: Colors.black54),
                                border: InputBorder.none),
                            onFieldSubmitted: (value) {
                              check();
                            },
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        FloatingActionButton(
                          onPressed: () {
                            check();
                          },
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 18,
                          ),
                          backgroundColor: Colors.blue,
                          elevation: 0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  formatTanggalPickup(tanggal) {
    var datestring = tanggal.toString();
    DateTime parseDate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(datestring);
    var inputDate =
        DateTime.parse(parseDate.add(Duration(hours: 7)).toString());
    var outputFormat = DateFormat("d/MM/yyyy HH:mm", "id_ID");
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  DateTime loginClickTime;

  bool isRedundentClick(DateTime currentTime) {
    if (loginClickTime == null) {
      loginClickTime = currentTime;
      print("first click");
      return false;
    }
    print('diff is ${currentTime.difference(loginClickTime).inSeconds}');
    if (currentTime.difference(loginClickTime).inSeconds < 5) {
      //set this difference time in seconds
      return true;
    }

    loginClickTime = currentTime;
    return false;
  }
}

class ChatMessage {
  String messageContent;
  String messageType;

  ChatMessage({@required this.messageContent, @required this.messageType});
}
