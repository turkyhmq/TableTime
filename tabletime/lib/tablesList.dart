import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'Login.dart';
import 'dashBoard.dart';
import 'dbase/dbservices.dart';
import 'newTable.dart';
import 'profile.dart';
import 'reserveDetail.dart';
import 'package:fluttertoast/fluttertoast.dart';

class tablesList extends StatefulWidget {
  String lang;
  String userid;
  String username;
  String roleid;
  var rows;

  tablesList(
      {Key? key,
      required this.userid,
      required this.username,
      required this.roleid,
      required this.rows,
      required this.lang})
      : super(key: key);

  @override
  _tablesListState createState() => _tablesListState(
      this.userid, this.username, this.roleid, this.rows, this.lang);
}

class _tablesListState extends State<tablesList> {
  String lang;
  String userid;
  String username;
  String roleid;
  var rows, tablerows, restid;

  var _scanned = false;
  var _foundtable = false;

  _tablesListState(
      this.userid, this.username, this.roleid, this.rows, this.lang);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    restid = rows[0];
    tablerows = rows[1];
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

  TextEditingController _nfcController = new TextEditingController();

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
                        size: 50,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.1,
              child: const Text(
                "Tables List",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            if (roleid == "1") // Owner only
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(50, 0, 50, 10),
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: () {
                        addTable();
                      },
                      child: const Text(
                        'Add Table',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(50, 0, 50, 15),
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: 80,
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.55,
                          height: 80,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                            color: const Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: TextField(
                            controller: _nfcController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Scan NFC card",
                              icon: Padding(
                                padding: EdgeInsets.only(
                                  top: 1.0,
                                  left: 5,
                                ),
                                child: Icon(Icons.numbers_outlined),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (_nfcController.text == "") {
                              _tagRead();
                            }
                          },
                          child: Icon(
                            Icons.nfc,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    margin: const EdgeInsets.fromLTRB(50, 20, 50, 20),
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: () {
                        _scanned = true;
                        for (var row in tablerows) {
                          if (row['tabnfc'].toString() == _nfcController.text) {
                            _foundtable = true;
                          }
                        }
                        setState(() {});
                      },
                      child: const Text(
                        'Search',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                  ),
                  if (_scanned)
                    Container(
                      height: MediaQuery.of(context).size.height * 0.53,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            if (!_foundtable)
                              const Text("No table with this NFC code"),
                            if (_foundtable)
                              for (var row in tablerows)
                                if (row['tabnfc'] == _nfcController.text)
                                  Container(
                                    margin:
                                    const EdgeInsets.fromLTRB(0, 0, 0, 15),
                                    child: Stack(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.7,
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              color: Colors.amber,
                                              borderRadius:
                                              BorderRadius.circular(15)),
                                          child: Column(
                                            children: [
                                              Text(
                                                "Table " + row['tabnum'],
                                                textAlign: TextAlign.left,
                                              ),
                                              Text(
                                                  "Chairs:" + row['tabchairs']),
                                              Text("Position: " +
                                                  row['tabposition']),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: 8,
                                          left: 10,
                                          child: Column(
                                            children: [
                                              if (row['tabstatus'] ==
                                                  "0") // Not available
                                                GestureDetector(
                                                  onTap: () {
                                                    setTableState(
                                                        row['tableid'], "1");
                                                  },
                                                  child: const Icon(
                                                    Icons.circle,
                                                    color: Colors.red,
                                                    size: 35,
                                                  ),
                                                ),
                                              if (row['tabstatus'] ==
                                                  "1") // available
                                                GestureDetector(
                                                  onTap: () {
                                                    setTableState(
                                                        row['tableid'], "0");
                                                  },
                                                  child: const Icon(
                                                    Icons.circle,
                                                    color: Colors.green,
                                                    size: 35,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  if (tablerows.length > 0)
                    Container(
                      height: MediaQuery.of(context).size.height * 0.53,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            for (var row in tablerows)
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                                child: Stack(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: Colors.amber,
                                          borderRadius:
                                          BorderRadius.circular(15)),
                                      child: Column(
                                        children: [
                                          Text(
                                            "Table " + row['tabnum'],
                                            textAlign: TextAlign.left,
                                          ),
                                          Text("Chairs:" + row['tabchairs']),
                                          Text("Position: " +
                                              row['tabposition']),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 10,
                                      child: GestureDetector(
                                          onTap: () {
                                            delTable(
                                                row['restid'], row['tableid']);
                                          },
                                          child: const Icon(
                                            Icons.delete_forever,
                                            size: 35,
                                            color: Colors.red,
                                          )),
                                    ),
                                    Positioned(
                                      top: 8,
                                      left: 10,
                                      child: Column(
                                        children: [
                                          if (row['tabstatus'] ==
                                              "0") // Not available
                                            GestureDetector(
                                              onTap: () {
                                                setTableState(
                                                    row['tableid'], "1");
                                              },
                                              child: const Icon(
                                                Icons.circle,
                                                color: Colors.red,
                                                size: 35,
                                              ),
                                            ),
                                          if (row['tabstatus'] ==
                                              "1") // available
                                            GestureDetector(
                                              onTap: () {
                                                setTableState(
                                                    row['tableid'], "0");
                                              },
                                              child: const Icon(
                                                Icons.circle,
                                                color: Colors.green,
                                                size: 35,
                                              ),
                                            ),
                                        ],
                                      ),
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
            // Employee
            if (roleid == "2")
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(50, 0, 50, 10),
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: () {
                        addTable();
                      },
                      child: const Text(
                        'Add Table',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(50, 0, 50, 15),
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: 80,
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.55,
                          height: 80,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                            color: const Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: TextField(
                            controller: _nfcController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Scan NFC card",
                              icon: Padding(
                                padding: EdgeInsets.only(
                                  top: 1.0,
                                  left: 5,
                                ),
                                child: Icon(Icons.numbers_outlined),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (_nfcController.text == "") {
                              _tagRead();
                            }
                          },
                          child: Icon(
                            Icons.nfc,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    margin: const EdgeInsets.fromLTRB(50, 20, 50, 20),
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: () {
                        _scanned = true;
                        for (var row in tablerows) {
                          if (row['tabnfc'].toString() == _nfcController.text) {
                            _foundtable = true;
                          }
                        }
                        setState(() {});
                      },
                      child: const Text(
                        'Search',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                  ),
                  if (_scanned)
                    Container(
                      height: MediaQuery.of(context).size.height * 0.53,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            if (!_foundtable)
                              const Text("No table with this NFC code"),
                            if (_foundtable)
                              for (var row in tablerows)
                                if (row['tabnfc'] == _nfcController.text)
                                  Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 15),
                                    child: Stack(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              color: Colors.amber,
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Column(
                                            children: [
                                              Text(
                                                "Table " + row['tabnum'],
                                                textAlign: TextAlign.left,
                                              ),
                                              Text(
                                                  "Chairs:" + row['tabchairs']),
                                              Text("Position: " +
                                                  row['tabposition']),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: 8,
                                          left: 10,
                                          child: Column(
                                            children: [
                                              if (row['tabstatus'] ==
                                                  "0") // Not available
                                                GestureDetector(
                                                  onTap: () {
                                                    setTableState(
                                                        row['tableid'], "1");
                                                  },
                                                  child: const Icon(
                                                    Icons.circle,
                                                    color: Colors.red,
                                                    size: 35,
                                                  ),
                                                ),
                                              if (row['tabstatus'] ==
                                                  "1") // available
                                                GestureDetector(
                                                  onTap: () {
                                                    setTableState(
                                                        row['tableid'], "0");
                                                  },
                                                  child: const Icon(
                                                    Icons.circle,
                                                    color: Colors.green,
                                                    size: 35,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  if (tablerows.length > 0)
                    Container(
                      height: MediaQuery.of(context).size.height * 0.53,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            for (var row in tablerows)
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                                child: Stack(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: Colors.amber,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Column(
                                        children: [
                                          Text(
                                            "Table " + row['tabnum'],
                                            textAlign: TextAlign.left,
                                          ),
                                          Text("Chairs:" + row['tabchairs']),
                                          Text("Position: " +
                                              row['tabposition']),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 10,
                                      child: GestureDetector(
                                          onTap: () {
                                            delTable(
                                                row['restid'], row['tableid']);
                                          },
                                          child: const Icon(
                                            Icons.delete_forever,
                                            size: 35,
                                            color: Colors.red,
                                          )),
                                    ),
                                    Positioned(
                                      top: 8,
                                      left: 10,
                                      child: Column(
                                        children: [
                                          if (row['tabstatus'] ==
                                              "0") // Not available
                                            GestureDetector(
                                              onTap: () {
                                                setTableState(
                                                    row['tableid'], "1");
                                              },
                                              child: const Icon(
                                                Icons.circle,
                                                color: Colors.red,
                                                size: 35,
                                              ),
                                            ),
                                          if (row['tabstatus'] ==
                                              "1") // available
                                            GestureDetector(
                                              onTap: () {
                                                setTableState(
                                                    row['tableid'], "0");
                                              },
                                              child: const Icon(
                                                Icons.circle,
                                                color: Colors.green,
                                                size: 35,
                                              ),
                                            ),
                                        ],
                                      ),
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
            if (roleid == "3")
              Column(
                children: [
                  if (tablerows.length == 0)
                    const Text(
                      "No tablesList exists!",
                      style: TextStyle(color: Colors.red, fontSize: 25),
                    ),
                  if (tablerows.length > 0)
                    Container(
                      height: MediaQuery.of(context).size.height * 0.53,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            for (var row in tablerows)
                              GestureDetector(
                                onTap: () {
                                  if (row['tabstatus'] == "1") {
                                    makeReserve(row['tableid']);
                                  }
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 15),
                                  child: Stack(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            color: Colors.amber,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Column(
                                          children: [
                                            Text(
                                              "Table " + row['tabnum'],
                                              textAlign: TextAlign.left,
                                            ),
                                            Text("Chairs:" + row['tabchairs']),
                                            Text("Position: " +
                                                row['tabposition']),
                                          ],
                                        ),
                                      ),
                                      if (roleid != "3")
                                        Positioned(
                                          top: 8,
                                          left: 10,
                                          child: Column(
                                            children: [
                                              if (row['tabstatus'] ==
                                                  "0") // Not available
                                                GestureDetector(
                                                  onTap: () {},
                                                  child: const Icon(
                                                    Icons.circle,
                                                    color: Colors.red,
                                                    size: 35,
                                                  ),
                                                ),
                                              if (row['tabstatus'] ==
                                                  "1") // available
                                                GestureDetector(
                                                  onTap: () {},
                                                  child: const Icon(
                                                    Icons.circle,
                                                    color: Colors.green,
                                                    size: 35,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      if (roleid == "3")
                                        Positioned(
                                          top: 8,
                                          left: 10,
                                          child: Column(
                                            children: [
                                              if (row['tabstatus'] ==
                                                  "0") // Not available
                                                const Icon(
                                                  Icons.circle,
                                                  color: Colors.red,
                                                  size: 35,
                                                ),
                                              if (row['tabstatus'] ==
                                                  "1") // available
                                                const Icon(
                                                  Icons.circle,
                                                  color: Colors.green,
                                                  size: 35,
                                                )
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

  void _tagRead() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      Map<String, dynamic> tagvalue = tag.data;
      String tagvalueStr = tagvalue.toString();
      var tagAry = tagvalueStr.split("{identifier: ");
      var vals = tagAry[1].split("],");
      String TagVal = vals[0] + "]";
      _nfcController.text =
          TagVal.trim(); // Assuming this is the NFC identifier
      print("NFC Data: $TagVal");

      // Fetch table data based on NFC identifier
      fetchTableByNFC(TagVal.trim());
      NfcManager.instance.stopSession();
    });
  }

  void fetchTableByNFC(String nfcCode) {
    Map<String, dynamic> posts = {"nfc": nfcCode};
    dbservices.doPost("getTableByNFC", posts).then((result) {
      Map<String, dynamic> res = jsonDecode(result);
      var block = res['response'];
      if (block['status'] == "done") {
        // Update your UI with the fetched table data
        print("Table Data: ${block['rows']}");
      } else {
        Fluttertoast.showToast(
            msg: "No table found with this NFC code",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
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

  void delTable(restid, tableid) {
    Map<String, dynamic> posts = {
      "act": "delTable",
      "restid": restid,
      "tableid": tableid,
      "userid": userid
    };
    dbservices.doPost("delTable", posts).then((result) {
      Map<String, dynamic> res = jsonDecode(result);
      var block = res['response'];
      if (block['status'] == "done") {
        var rows = block['rows']; // user profile data

        Navigator.pushReplacement(
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

  void addTable() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => newTable(
                userid: userid,
                username: username,
                roleid: roleid,
                rows: rows,
                lang: lang)));
  }

  void setTableState(String tableid, String state) {
    Map<String, dynamic> posts = {
      "act": "setTable",
      "restid": restid,
      "tableid": tableid,
      "tabstate": state,
      "userid": userid
    };
    dbservices.doPost("setTable", posts).then((result) {
      Map<String, dynamic> res = jsonDecode(result);
      var block = res['response'];
      if (block['status'] == "done") {
        var rows = block['rows']; // user profile data

        Navigator.pushReplacement(
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

  void makeReserve(tableid) {
    Map<String, dynamic> posts = {
      "act": "reserveDetail",
      "restid": restid,
      "tableid": tableid,
      "userid": userid
    };
    dbservices.doPost("reserveDetail", posts).then((result) {
      Map<String, dynamic> res = jsonDecode(result);
      var block = res['response'];
      if (block['status'] == "done") {
        var rows = block['rows']; // user profile data

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => reserveDetail(
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
