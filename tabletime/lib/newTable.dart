import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:tabletime/restaurants.dart';
import 'package:tabletime/tablesList.dart';
import 'Login.dart';
import 'dashBoard.dart';
import 'dbase/dbservices.dart';
import 'profile.dart';

class newTable extends StatefulWidget {
  String lang;
  String userid;
  String username;
  String roleid;
  var rows; // contains restaurant ID

  newTable({Key? key, required this.userid, required this.username, required this.roleid,
      required this.rows,
      required this.lang})
      : super(key: key);

  @override
  _newTableState createState() =>
      _newTableState(this.userid, this.username, this.roleid, this.rows, this.lang);
}

class _newTableState extends State<newTable> {
  String lang;
  String userid;
  String username;
  String roleid;
  var rows, tablerows, restid; // contains restaurant ID

  _newTableState(this.userid, this.username, this.roleid, this.rows, this.lang);


  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    startNFC();
    restid = rows[0];
  }

  startNFC() async {
    // Check availability
    bool isAvailable = await NfcManager.instance.isAvailable();
    print(isAvailable);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  // Stop Session
    NfcManager.instance.stopSession();
  }

  TextEditingController _nfcController = TextEditingController();
  TextEditingController _tablenumController = TextEditingController();
  TextEditingController _tabchairController = TextEditingController();
  TextEditingController _tabpositionController = TextEditingController();

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
              ),
               const Text("New Table",
              style: TextStyle(fontSize: 20),
                 textAlign: TextAlign.center,
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
                            padding: EdgeInsets.only(top: 1.0, left: 5,),
                            child: Icon(Icons.numbers_outlined),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    GestureDetector(
                      onTap: (){
                        if(_nfcController.text == "") {
                          _tagRead();
                        }else{
                          setState(() { });
                        }
                      },
                      child: Icon(Icons.nfc, size: 50,),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(50, 0, 50, 15),
                width: MediaQuery.of(context).size.width * 0.7,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextField(
                  controller: _tablenumController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Table Name or number",
                    icon: Padding(
                      padding: EdgeInsets.only(top: 1.0, left: 5,),
                      child: Icon(Icons.table_bar_sharp),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(50, 0, 50, 15),
                width: MediaQuery.of(context).size.width * 0.7,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextField(
                  controller: _tabchairController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Number of chairs",
                    icon: Padding(
                      padding: EdgeInsets.only(top: 1.0, left: 5,),
                      child: Icon(Icons.chair_alt),
                    ),
                  ),
                ),
              ),

              //------------ This one is for the description of table position ----------
              Container(
                margin: const EdgeInsets.fromLTRB(50, 0, 50, 15),
                width: MediaQuery.of(context).size.width * 0.7,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextField(
                  controller: _tabpositionController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Table Position",
                    icon: Padding(
                      padding: EdgeInsets.only(top: 1.0, left: 5,),
                      child: Icon(Icons.deck),
                    ),
                  ),
                ),
              ),

              // Button Register
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                margin: const EdgeInsets.fromLTRB(50, 20, 50, 20),
                decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(onPressed: () {
                  saveTable();
                  }, child: const Text('Save',
                  style: TextStyle(color: Colors.black, fontSize: 20),),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                margin: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: () { Navigator.pop(context); },
                  child: const Text('Cancel',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
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
      _nfcController.text = TagVal.trim();
      print(tagvalue);
      NfcManager.instance.stopSession();
    });
  }

  void saveTable() {
    String nfc = _nfcController.text;
    String tablenum = _tablenumController.text;
    String chairnum = _tabchairController.text;
    String tabposition = _tabpositionController.text;
    var _save = true;
    if(tablenum == ""){
      _save = false;
    }
    if(chairnum == ""){
      _save = false;
    }
    if(_save) {
      Map<String, dynamic> posts = {
        "act": "saveTable", "nfc": nfc, "restid": restid, "tablenum": tablenum,
        "chairnum": chairnum, "tabposition": tabposition, "userid": userid
      };
      dbservices.doPost("saveTable", posts).then((result) {
        Map<String, dynamic> res = jsonDecode(result);
        var block = res['response'];
        if (block['status'] == "error") {
          Fluttertoast.showToast(
              msg: block['msg'],
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );
        }
        if (block['status'] == "done") {
          var rows = block['rows']; // user profile data

          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) =>
                  tablesList(userid: userid,
                    username: username,
                    roleid: roleid,
                    rows: rows,
                    lang: lang,)));
        }
      });
    }
  }
}
