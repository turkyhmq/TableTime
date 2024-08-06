import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'Login.dart';
import 'dbase/dbservices.dart';
import 'profile.dart';
import 'restaurants.dart';
import 'package:intl/intl.dart' as intl;

class reservationlist extends StatefulWidget {
  String lang;
  String userid;
  String username;
  String roleid;
  var rows;

  reservationlist({Key? key, required this.userid, required this.username, required this.roleid,
      required this.rows,
      required this.lang})
      : super(key: key);

  @override
  _reservationlistState createState() =>
      _reservationlistState(this.userid, this.username, this.roleid, this.rows, this.lang);
}

class _reservationlistState extends State<reservationlist> {
  String lang;
  String userid;
  String username;
  String roleid;
  var rows;

  var datevals = {};  // date converts

  _reservationlistState(this.userid, this.username, this.roleid, this.rows, this.lang);

  @override
  void initState(){
    // TODO: implement initState
    super.initState();

  }


  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
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
    if(index == 0){
      gohome();
    }
    if(index == 1){
      goprofile();
    }
    if(index == 2){
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
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.25,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/logo.png'),
                      fit: BoxFit.contain
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 20, left: 20,
                      child: GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.arrow_circle_left_outlined, size: 50, color: Colors.amber, ),
                      ),
                    ),
                  ],
                ),
              ),
              if(roleid == "1")
                const Text("Tables Reservations", style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              if(roleid == "3")
               const Text("My Reservations", style: TextStyle(fontSize: 20),
               textAlign: TextAlign.center,
               ),
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for(var row in rows)
                          Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          margin: const EdgeInsets.fromLTRB(80, 0, 80, 15),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(15)
                          ),
                          child: Column(
                            children: [
                              if(roleid == "1")
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const Text("Name: ",
                                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                        ),
                                        Text((row['fullname'] == null) ? "" : row['fullname']),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const Text("Email: ",
                                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                        ),
                                        Text((row['email'] == null) ? "" : row['email']),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const Text("Mobile: ",
                                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                        ),
                                        Text((row['mobile'] == null) ? "" : row['mobile']),
                                      ],
                                    ),
                                    Divider(),
                                  ],
                                ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text("Restaurant: ",
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  Text((row['restname'] == null) ? "" : row['restname']),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text("Table Name: ",
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  Text((row['tabnum'] == null) ? "" : row['tabnum']),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text("Number of chairs: ",
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  Text((row['tabchairs'] == null) ? "" : row['tabchairs']),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text("Date: ",
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  Text((row['reservetimeb'] == null) ? "" : row['reservetimeb']),
                                ],
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
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
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) =>
            Login(lang:lang)),
        ModalRoute.withName('/'));

  }


  void goprofile() {
    Map<String, dynamic> posts = {"act": "getUserById", "userid": userid};
    dbservices.doPost("getUserById", posts).then((result) {
      Map<String, dynamic> res = jsonDecode(result);
      var block = res['response'];
      if (block['status'] == "done") {
        var rows = block['rows']; // user profile data

        Navigator.push(context,
            MaterialPageRoute(builder: (context) =>
                profile(userid: userid, username: username, roleid: roleid,
                  rows: rows, lang: lang,)));
      }
    });
  }

  void gohome() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) =>
            reservationlist(userid: userid, username: username, roleid:roleid,  rows:rows, lang:lang)));

  }


}
