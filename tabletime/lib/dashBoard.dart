import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tabletime/reservationlist.dart';
import 'Login.dart';
import 'dbase/dbservices.dart';
import 'profile.dart';
import 'restaurants.dart';

class dashBoard extends StatefulWidget {
  String lang;
  String userid;
  String username;
  String roleid;
  var rows;

  dashBoard({Key? key, required this.userid, required this.username, required this.roleid,
    required this.rows,
    required this.lang})
      : super(key: key);

  @override
  _dashBoardState createState() =>
      _dashBoardState(this.userid, this.username, this.roleid, this.rows, this.lang);
}

class _dashBoardState extends State<dashBoard> {
  String lang;
  String userid;
  String username;
  String roleid;
  var rows;

  _dashBoardState(this.userid, this.username, this.roleid, this.rows, this.lang);

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
        child: Column(
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
            ),
            Text("Welcome ... " + username,
              style: const TextStyle(fontSize: 20),
            ),
            if(roleid == "1") // Owners
              Column(
                children: [
                  //Body
                  GestureDetector(
                    onTap: (){
                      viewRestaurants();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.16,
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.list_alt_outlined, size:75, ),
                          Text("Restaurants",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 50,),
                  GestureDetector(
                    onTap: (){
                      viewReservations();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.16,
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.list_alt_outlined, size:75, ),
                          Text("Tables requests",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            if(roleid == "2") // Employees
              Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      viewRestaurants();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.16,
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.list_alt_outlined, size:75, ),
                          Text("Restaurants",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            if(roleid == "3")
              Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      viewRestaurants();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.16,
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.list_alt_outlined, size:75, ),
                          Text("Restaurants",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      viewReservations();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.16,
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.list_alt_outlined, size:75, ),
                          Text("My reservations",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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

  }

  void viewRestaurants() {
    Map<String, dynamic> posts = {"act": "getRest", "userid": userid, "roleid":roleid};
    dbservices.doPost("getRest", posts).then((result) {
      Map<String, dynamic> res = jsonDecode(result);
      var block = res['response'];
      if (block['status'] == "done") {
        var rows = block['rows']; // user profile data

        Navigator.push(context,
            MaterialPageRoute(builder: (context) =>
                Restaurants(userid: userid, username: username, roleid: roleid,
                  rows: rows, lang: lang,)));
      }
    });
  }

  void viewReservations() {
    Map<String, dynamic> posts = {"act": "getReserves", "userid": userid, "roleid":roleid};
    dbservices.doPost("getReserves", posts).then((result) {
      Map<String, dynamic> res = jsonDecode(result);
      var block = res['response'];
      if (block['status'] == "done") {
        var rows = block['rows']; // user profile data

        Navigator.push(context,
            MaterialPageRoute(builder: (context) =>
                reservationlist(userid: userid, username: username, roleid: roleid,
                  rows: rows, lang: lang,)));
      }
    });
  }


}
