import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Login.dart';
import 'dashBoard.dart';
import 'dbase/dbservices.dart';

class profile extends StatefulWidget {
  String lang;
  String userid;
  String username;
  String roleid;
  var rows;

  profile({Key? key, required this.userid, required this.username, required this.roleid,
      required this.rows,
      required this.lang})
      : super(key: key);

  @override
  _profileState createState() =>
      _profileState(this.userid, this.username, this.roleid, this.rows, this.lang);
}

class _profileState extends State<profile> {
  String lang;
  String userid;
  String username;
  String roleid;
  var rows;

  _profileState(this.userid, this.username, this.roleid, this.rows, this.lang);

  // password visiablity
  bool _passwordVisible = false;

  // text boxes
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    var profilerows = rows[0];
    var row = profilerows[0];
    _nameController.text = row['fullname'];
    _mobileController.text = (row['mobile'] != "") ? row['mobile'] : "";
    _emailController.text = row['email'];
    _usernameController.text = row['username'];
    _passwordController.text = row['password'];
  }


  int _selectedIndex = 1;
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
          textDirection:TextDirection.ltr,
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
              Text("Profile",
              style: TextStyle(fontSize: 20),
              ),

              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 40,
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "fullname",
                    icon: Padding(
                      padding: EdgeInsets.only(top: 1.0, left: 5,),
                      child: Icon(Icons.person_rounded),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                width: MediaQuery.of(context).size.width * 0.7,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextField(
                  controller: _mobileController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Mobile",
                    icon: Padding(
                      padding: EdgeInsets.only(top: 1.0, left: 5,),
                      child: Icon(Icons.mobile_screen_share_sharp),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                width: MediaQuery.of(context).size.width * 0.7,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Email",
                    icon: Padding(
                      padding: EdgeInsets.only(top: 1.0, left: 5,),
                      child: Icon(Icons.email_outlined),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                width: MediaQuery.of(context).size.width * 0.7,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Username",
                    icon: Padding(
                      padding: EdgeInsets.only(top: 1.0, left: 5,),
                      child: Icon(Icons.account_box),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                width: MediaQuery.of(context).size.width * 0.7,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextField(
                  controller: _passwordController,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Password",
                    icon: const Padding(
                      padding: EdgeInsets.only(top: 2.0, left: 5,),
                      child: Icon(Icons.lock),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        (_passwordVisible == false)
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: const Color(0xFF000000),
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          (_passwordVisible == true)
                              ? _passwordVisible = false
                              : _passwordVisible = true;
                        });
                      },
                    ),
                  ),
                ),
              ),
              // Button Register
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                margin: const EdgeInsets.fromLTRB(0, 20, 10, 20),
                decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(onPressed: () {
                  updateProfile();
                }, child: const Text('Update',
                  style: TextStyle(color: Colors.black, fontSize: 20),),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: () { Navigator.pop(context); },
                  child: const Text('Back',
                    style: TextStyle(color: Colors.black, fontSize: 20),
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


  void gohome() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) =>
            dashBoard(userid: userid, username: username, roleid:roleid,  rows:rows, lang:lang)));
  }


  void updateProfile() {
    String fullname = _nameController.value.text.toString();
    String mobile = _mobileController.value.text.toString();
    String email = _emailController.value.text.toString();
    String username = _usernameController.value.text.toString();
    String password = _passwordController.value.text.toString();

    Map<String, dynamic> posts = { "username":username, "password":password,
      "fullname":fullname, "mobile":mobile, "email": email};
    dbservices.doPost("updateprofile", posts).then((result) {
      Map<String, dynamic> res = jsonDecode(result);
      var block = res['response'];
      Fluttertoast.showToast(
          msg: block['msg'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: (block['status'] == "done") ? Colors.green : Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      if (block['status'] == "done") {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Login(lang:lang, )));
      }
    });
  }

}
