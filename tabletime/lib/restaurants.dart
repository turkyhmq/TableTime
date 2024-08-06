import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
  import 'package:tabletime/newRestaurant.dart';
import 'package:tabletime/tablesList.dart';
import 'Login.dart';
import 'dashBoard.dart';
import 'dbase/dbservices.dart';
import 'profile.dart';

class Restaurants extends StatefulWidget {
  String lang;
  String userid;
  String username;
  String roleid;
  var rows;

  Restaurants(
      {Key? key,
        required this.userid,
        required this.username,
        required this.roleid,
        required this.rows,
        required this.lang})
      : super(key: key);

  @override
  _RestaurantsState createState() => _RestaurantsState(
      this.userid, this.username, this.roleid, this.rows, this.lang);
}

class _RestaurantsState extends State<Restaurants> {
  String lang;
  String userid;
  String username;
  String roleid;
  var rows, restrows, imgPath;

  _RestaurantsState(
      this.userid, this.username, this.roleid, this.rows, this.lang);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imgPath = rows[0];
    restrows = rows[1];
  }

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Profile',
      style: optionStyle,
    ),
    Text(
      'Index 1: Chat',
      style: optionStyle,
    ),
    Text(
      'Index 2: Logout',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    print(index);
    if (index == 0) {
      gohome();
    }
    if (index == 1) {
      goprofile();
    }
    if (index == 2) {
      logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: const Color(0xFFfbfaf5),
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: ListView(
          children: [
            // logo
            Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/logo.png'),
                    fit: BoxFit.contain),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 20,
                    left: 20,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_circle_left_outlined,
                        size: 40,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Body
            Container(
              child: Column(
                children: [
                  if (roleid == "1")
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      margin: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () {
                          addRest();
                        },
                        child: const Text(
                          'Add Restaurant',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ),
                  if (restrows.length == 0)
                    const Text(
                      "No restaurants exists!",
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    ),
                  if (restrows.length > 0)
                    for (var row in restrows)
                      Card(
                        elevation: 5,
                        margin: EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              GestureDetector(
                                onTap: () {
                                  viewTables(row['restid']);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.orangeAccent,
                                  ),
                                  child: Text(
                                    "View tables",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      (row['restpic'] == null)
                                          ? imgPath + "blank.png"
                                          : row['restpic'],
                                    ),
                                    radius: 25,
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      (row['restname'] == null)
                                          ? ""
                                          : row['restname'],
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if(roleid =="1" || roleid =="2" || roleid !="3") {
                                        delRest(row['restid']);
                                      }
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      color: (roleid == "1" || roleid == "2") ? Colors.red : Colors.transparent,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Description: ${(row['descr'] == null) ? "" : row['descr']}',
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                'Email: ${(row['restemail'] == null) ? "" : row['restemail']}',
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                'Tel: ${(row['restphone'] == null) ? "" : row['restphone']}',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  void logout() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Login(lang: lang)),
        ModalRoute.withName('/'));
  }

  void goprofile() {
    Map<String, dynamic> posts = {"act": "getUserById", "userid": userid};
    dbservices.doPost("getUserById", posts).then((result) {
      Map<String, dynamic> res = jsonDecode(result);
      var block = res['response'];
      if (block['status'] == "done") {
        var rows = block['rows']; // user profile data

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => profile(
                  userid: userid,
                  username: username,
                  roleid: roleid,
                  rows: rows,
                  lang: lang,
                )));
      }
    });
  }

  void gohome() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => dashBoard(
                userid: userid,
                username: username,
                roleid: roleid,
                rows: rows,
                lang: lang)));
  }

  void delRest(restid) {
    Map<String, dynamic> posts = {
      "act": "delRest",
      "restid": restid,
      "userid": userid
    };
    dbservices.doPost("delRest", posts).then((result) {
      Map<String, dynamic> res = jsonDecode(result);
      var block = res['response'];
      if (block['status'] == "done") {
        var rows = block['rows']; // user profile data

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Restaurants(
                  userid: userid,
                  username: username,
                  roleid: roleid,
                  rows: rows,
                  lang: lang,
                )));
      }
    });
  }

  void addRest() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => newRestaurant(
              userid: userid,
              username: username,
              roleid: roleid,
              rows: rows,
              lang: lang,
            )));
  }

  void viewTables(restid) {
    Map<String, dynamic> posts = {
      "act": "getTables",
      "restid": restid,
      "userid": userid
    };
    dbservices.doPost("getTables", posts).then((result) {
      Map<String, dynamic> res = jsonDecode(result);
      var block = res['response'];
      if (block['status'] == "done") {
        var rows = block['rows']; // user profile data

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => tablesList(
                  userid: userid,
                  username: username,
                  roleid: roleid,
                  rows: rows,
                  lang: lang,
                )));
      }
    });
  }
}

