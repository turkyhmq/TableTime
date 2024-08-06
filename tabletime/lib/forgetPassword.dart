import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Login.dart';
import 'dbase/dbservices.dart';

class forgetPassword extends StatefulWidget {
  String lang;

  forgetPassword({Key? key, required this.lang,  }) : super(key: key);

  @override
  _forgetPasswordState createState() => _forgetPasswordState(this.lang, );
}

class _forgetPasswordState extends State<forgetPassword> {
  String lang;

  _forgetPasswordState(this.lang,);

  var langfile = {};

  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Directionality(
        textDirection:  TextDirection.ltr,
        child: Column(
          children: [
        // header
            Container(
              width: MediaQuery.of(context).size.width * 0.65,
              height: MediaQuery.of(context).size.height * 0.30,
              margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/logo.png'),
                    fit: BoxFit.fill
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
              child: const Text( "Forget password",
            style: TextStyle(fontSize: 35, color: Colors.black),
            textAlign: TextAlign.center,),
        ),
        // Body
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.07,
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
              decoration: BoxDecoration(
                color: const Color(0xFFEEEEEE),
                border: Border.all(width: 1, color: Colors.grey),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Email",
                  icon: Padding(
                    padding: EdgeInsets.only(top: 1.0, left: 10),
                    child: Icon(Icons.email),
                  ),
                ),
              ),
            ),
          Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Column(
            children: [
              GestureDetector(
                onTap: (){
                  // send password

                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.orangeAccent,
                  ),
                  child: const Text("Send",
                    style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  //back
                  Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.orangeAccent,
                  ),
                  child: const Text('Back',
                    style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    )
    )
    );
  }

  void login() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) =>
            Login(lang:lang, )));
  }
}
