// @dart=2.9
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jelantah/screens/login_page.dart';
import 'package:jelantah/screens/historis.dart';
import 'package:jelantah/screens/chat_list.dart';
import 'package:jelantah/screens/tutorial.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:jelantah/screens/account.dart';
import 'package:http/http.dart' as http;

class ChatRoom extends StatefulWidget {
  final int id;
  final String nama;

  ChatRoom({Key key, this.id, this.nama}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  List<ChatMessage> messages = [
    ChatMessage(messageContent: "Hello, Will", messageType: "receiver"),
    ChatMessage(messageContent: "How have you been?", messageType: "receiver"),
    ChatMessage(
        messageContent: "Hey Kriss, I am doing fine dude. wbu?",
        messageType: "sender"),
    ChatMessage(messageContent: "ehhhh, doing OK.", messageType: "receiver"),
    ChatMessage(
        messageContent: "Is there any thing wrong?", messageType: "sender"),
  ];
  final _key = new GlobalKey<FormState>();
  var isitext;
  var _token;

  int i;

  var message = new List();

  var to_user_id = new List();

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
    var iduser = widget.id;
    var namauser = widget.nama;
    Map bodi = {
      "token": _token,
      "message":isitext
    };
    var body = json.encode(bodi);
    final response = await http.post(
      Uri.parse("http://127.0.0.1:8000/api/admin/chats/$iduser/post"),
      body: body,
    );
    final data = jsonDecode(response.body);
    String status = data['status'];
    String message = data['message'];
    if (status == "success") {
      setState(() {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (c, a1, a2) => ChatRoom(id: iduser, nama: namauser),
            transitionsBuilder: (c, anim, a2, child) =>
                FadeTransition(
                    opacity: anim, child: child),
            transitionDuration:
            Duration(milliseconds: 10),
          ),
        );
      });
    } else {
      print(message);
    }
  }

  get_data() async {
    var iduser = widget.id;
    print(iduser);
    Map bodi = {"token": _token};
    var body = json.encode(bodi);
    final response = await http.post(
      Uri.parse("http://127.0.0.1:8000/api/admin/chats/$iduser/get"),
      body: body,
    );
    final data = jsonDecode(response.body);
    for (i = 0; i < data['chats']['data'].length; i++) {
      setState(() {
        message.add(data['chats']['data'][i]['message']);
        to_user_id.add(data['chats']['data'][i]['to_user_id']);
      });
    }
    print(data['chats']['data'].length);
    setState(() {

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
              title: Text(
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
                  isAlwaysShown: true,
                  child: ListView.builder(
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
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: (to_user_id[index] != widget.id
                                  ? Colors.grey.shade200
                                  : Colors.blue[200]),
                            ),
                            padding: EdgeInsets.all(16),
                            child: Text(
                              message[index],
                              style: TextStyle(fontSize: 15),
                            ),
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
                          onTap: () {},
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
                            onSaved: (e) => isitext = e,
                            decoration: InputDecoration(
                                hintText: "Write message...",
                                hintStyle: TextStyle(color: Colors.black54),
                                border: InputBorder.none),
                            onFieldSubmitted: (value){
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
}

class ChatMessage {
  String messageContent;
  String messageType;

  ChatMessage({@required this.messageContent, @required this.messageType});
}
