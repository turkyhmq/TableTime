import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Login.dart';
import 'dashBoard.dart';
import 'dbase/dbservices.dart';
import 'profile.dart';
import 'restaurants.dart';

class reserveDetail extends StatefulWidget {
  String lang;
  String userid;
  String username;
  String roleid;
  var rows;

  reserveDetail({Key? key, required this.userid, required this.username, required this.roleid,
    required this.rows,
    required this.lang})
      : super(key: key);

  @override
  _reserveDetailState createState() =>
      _reserveDetailState(this.userid, this.username, this.roleid, this.rows, this.lang);
}

class _reserveDetailState extends State<reserveDetail> {
  String lang;
  String userid;
  String username;
  String roleid;
  var rows, tablerows, foodrows, tableid;
  var totalPrice = 0;
  var foodTypesMap = {
    1: "Fish",
    2: "Checkins",
    3: "Meats",
    4: "Drink",
    5: "Cheeses"
  };

  Map<int, int> foodQuantity = {};

  _reserveDetailState(this.userid, this.username, this.roleid, this.rows, this.lang);

  var foodids = {};
  var foodlist = {}; // init the selection

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    tablerows = rows[0];
    foodrows = rows[1];
    for(var tablerow in tablerows){
      tableid = tablerow['tableid'];
    }
    if(foodrows.length > 0) {
      for (var foodrow in foodrows) {
        foodids[int.parse(foodrow['foodid'])] = "0";
        foodlist[int.parse(foodrow['foodid'])] = false;
      }
    }
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

  bool isChecked = false;
  TextEditingController _dateController = new TextEditingController();
  TextEditingController _timeController = new TextEditingController();

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2022, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = '${picked.day}-${picked.month}-${picked.year}';
      });
    }
  }

  ///Time
  TimeOfDay timeOfDay = TimeOfDay.now();
  Future displayTimePicker(BuildContext context) async {
    var time = await showTimePicker(
        context: context,
        initialTime: timeOfDay);

    if (time != null) {
      setState(() {
        _timeController.text = "${time.hour}:${time.minute}";
      });
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
            const Text("Reservation Details",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5,),
            // body
            for(var row in tablerows)
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                margin: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(15)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Table " + row['tabnum'],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text("Chairs: " + row['tabchairs'],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text("Position: " + row['tabposition'],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: TextField(
                              controller: _dateController,
                              obscureText: false,
                              readOnly: true,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Date",
                              ),
                              onTap: (){
                                _selectDate(context);
                              },
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: TextField(
                              controller: _timeController,
                              obscureText: false,  readOnly: true,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Time",
                              ),
                              onTap: (){
                                displayTimePicker(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          value: isChecked,
                          onChanged: (bool? value) {
                            if(!isChecked){
                              totalPrice = 0;
                              if(foodrows.length > 0) {
                                for (var foodrow in foodrows) {
                                  foodids[int.parse(foodrow['foodid'])] = "0";
                                  foodlist[int.parse(foodrow['foodid'])] = false;
                                }
                              }
                            }
                            setState(() {
                              isChecked = value!;
                            });
                          },
                        ),
                        const SizedBox(width: 5,),
                        const Text("With food?",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            if(isChecked)
              Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: const Text("Food List",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
            if(isChecked)
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.25,
                padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if(foodrows.length == 0)
                        const Text("No foods exists"),
                      if(foodrows.length > 0)
                        for(var foodrow in foodrows)
                          Container(
                            margin: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            decoration: BoxDecoration(
                                color: Colors.amberAccent,
                                borderRadius: BorderRadius.circular(10),
                                border: const Border(bottom: BorderSide(width:1, color:Colors.white))
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Checkbox(
                                      checkColor: Colors.white,
                                      value: foodlist[int.parse(foodrow['foodid'])],
                                      onChanged: (bool? value) {
                                        foodlist[int.parse(foodrow['foodid'])] = value!;
                                        foodids[int.parse(foodrow['foodid'])] = (value!) ? "1" : "0";
                                        if(value!) {
                                          totalPrice += int.parse(foodrow['price']);
                                        }
                                        if(!value!){
                                          totalPrice -= int.parse(foodrow['price']);
                                        }
                                        setState(() {
                                          print(foodids);
                                          print(foodlist);
                                        });
                                      },
                                    ),
                                    const SizedBox(width: 5,),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.4,
                                      child: Text((foodrow['foodname'] == null) ? "" : foodrow['foodname'],
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    const SizedBox(width: 5,),
                                    Text((foodrow['price'] == null) ? "0" : foodrow['price'] + " SAR",
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.2,
                                      child: DropdownButton<int>(
                                        value: foodQuantity[int.parse(foodrow['foodid'])] ?? 1,
                                        onChanged: (int? newValue) {
                                          setState(() {foodQuantity[int.parse(foodrow['foodid'])] = newValue!;
                                          });
                                        },
                                        items: List.generate(10, (index) => index + 1)
                                            .map((int value) {
                                          return DropdownMenuItem<int>(
                                            value: value,
                                            child: Text(value.toString()),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    Text(
                                      'Quantity: ${foodQuantity[int.parse(foodrow['foodid'])] ?? 1}',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text("Type: ",
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                    ),
                                    Text((foodrow['foodtype'] == null ? "" : foodTypesMap[int.parse(foodrow['foodtype'].toString())] ?? ""))
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text("Calories :",
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                    ),
                                    Text((foodrow['calories'] == null) ? "": foodrow['calories'])
                                  ],
                                ),
                              ],
                            ),
                          ),
                    ],
                  ),
                ),
              ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.fromLTRB(50, 2, 50, 2),
              decoration: const BoxDecoration(
                  color: Colors.orangeAccent
              ),
              child: Text("Total = $totalPrice"),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              margin: const EdgeInsets.fromLTRB(50, 20, 50, 20),
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(onPressed: () {
                reserveTable(tableid);
              }, child: const Text('Reserve',
                style: TextStyle(color: Colors.black, fontSize: 20),),
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
            dashBoard(userid: userid, username: username, roleid:roleid,  rows:rows, lang:lang)));
  }

  void reserveTable(tableid) {
    if(!isChecked){
      foodids = {};
    }
    String selectedfoods = foodids.toString();
    String dateandtime = _dateController.text + " " + _timeController.text;

    Map<String, dynamic> posts = {"act": "reserve", "foodlist":selectedfoods, "tableid":tableid,
      "dateandtime": dateandtime, "userid": userid};
    dbservices.doPost("reserve", posts).then((result) {
      Map<String, dynamic> res = jsonDecode(result);
      var block = res['response'];
      if (block['status'] == "done") {
        var rows = block['rows']; // user profile data

        Navigator.push(context,
            MaterialPageRoute(builder: (context) =>
                dashBoard(userid: userid, username: username, roleid: roleid,
                  rows: rows, lang: lang,)));
      }
    });
  }

}
