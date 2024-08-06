import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'forgetPassword.dart';
import 'main.dart';
import 'dashBoard.dart';
import 'Register.dart';
import 'dbase/dbservices.dart';

class Login extends StatefulWidget {
  String lang = 'en';

  Login({Key? key, required this.lang,  }) : super(key: key);

  @override
  _LoginState createState() => _LoginState(this.lang,);
}

class _LoginState extends State<Login> {
  String lang;

  _LoginState(this.lang);

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
  }

  // password visiablity
  bool _passwordVisible = false;
  var roleid = 0;

  // text boxes
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: ListView(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 50, 0, 10),
                width: MediaQuery.of(context).size.width * 0.65,
                height: MediaQuery.of(context).size.height * 0.25,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/logo.png'),
                      fit: BoxFit.contain
                  ),
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                  ),
                  child: Column(
                    children: [
                      // body
                      Container(
                        height: MediaQuery.of(context).size.height * 0.55,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            const Text("Login",
                              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: MediaQuery.of(context).size.height * 0.07,
                              margin: const EdgeInsets.fromLTRB(0, 10, 0, 15),
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              decoration: BoxDecoration(
                                border: Border.all(width: 1, color: Colors.black),
                                color: const Color(0xFFEEEEEE),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: TextField(
                                controller: _usernameController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Username",
                                  icon: Padding(
                                    padding: EdgeInsets.only(top: 1.0),
                                    child: Icon(Icons.supervised_user_circle),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: MediaQuery.of(context).size.height * 0.07,
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              decoration: BoxDecoration(
                                border: Border.all(width: 1, color: Colors.black),
                                color: const Color(0xFFEEEEEE),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: TextField(
                                controller: _passwordController,
                                obscureText: !_passwordVisible,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Password",
                                  icon: const Padding(
                                    padding: EdgeInsets.only(top: 2.0),
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
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) =>
                                        forgetPassword( lang:lang, )));
                              },
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(0, 15, 0, 20),
                                child: const Text("Forget password?",
                                  style:  TextStyle(fontSize: 22, decoration: TextDecoration.underline),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                dologin();
                              },
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                width: MediaQuery.of(context).size.width * 0.7,
                                decoration: BoxDecoration(
                                  color: Colors.orangeAccent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text("Login",
                                  style: TextStyle(color: Colors.black, fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                back();
                              },
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                width: MediaQuery.of(context).size.width * 0.7,
                                decoration: BoxDecoration(
                                  color: Colors.orangeAccent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text('Back',
                                  style: TextStyle(color: Colors.black, fontSize: 22),
                                  textAlign: TextAlign.center,
                                ),
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
    );
  }


  void dologin() {
    String username = _usernameController.text.toString();
    String password = _passwordController.text.toString();

    Map<String, dynamic> posts = {"act":"login", "username":username, "password":password};
    dbservices.doPost("login", posts).then((result) {
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
        String userid = block['userid'];
        String roleid = block['roleid']; // Admin, Provider, Requester, Cistomerservice
        var rows = block['rows'];

          Navigator.push(context,
              MaterialPageRoute(builder: (context) =>
                  dashBoard(userid: userid, username: username, roleid:roleid,  rows:rows, lang:lang)));
      }
    });
  }

  void back() {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) =>
            MyHomePage(lang:lang)),
        ModalRoute.withName('/'));
  }

}

