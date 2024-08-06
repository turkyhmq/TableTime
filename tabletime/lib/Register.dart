import 'dart:async';
import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Login.dart';
import 'dbase/dbservices.dart';

// Boolean variable to track if password icon is focused or not
bool isPasswordIconFocused = true;

class Register extends StatefulWidget {
  String lang;
  var rows;

  Register({Key? key, required this.lang, required this.rows}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState(this.lang, this.rows);
}

enum SingingCharacter { select, owner, user }

class _RegisterState extends State<Register> {
  String lang;
  var rows;

  _RegisterState(this.lang, this.rows);

  // Text controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  SingingCharacter? _character = SingingCharacter.select;

  @override
  void initState() {
    super.initState();
  }

  // Password visibility
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Column(
            children: [
              // Logo
              Container(
                margin: const EdgeInsets.fromLTRB(0, 50, 0, 10),
                width: MediaQuery.of(context).size.width * 0.65,
                height: MediaQuery.of(context).size.height * 0.25,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/logo.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                child: const Text(
                  'Signup',
                  style: TextStyle(fontSize: 35, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              // Body
              Container(
                decoration: const BoxDecoration(),
                child: Column(
                  children: [
                    // Full Name TextField
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
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: "fullname",
                          icon: Padding(
                            padding: EdgeInsets.only(top: 1.0, left: 5),
                            child: Icon(Icons.person_rounded),
                          ),
                        ),
                      ),
                    ),
                    // Mobile TextField
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
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: "Mobile",
                          icon: Padding(
                            padding: EdgeInsets.only(top: 1.0, left: 5),
                            child: Icon(Icons.mobile_screen_share_sharp),
                          ),
                        ),
                      ),
                    ),
                    // Email TextField
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
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: "Email",
                          icon: Padding(
                            padding: EdgeInsets.only(top: 1.0, left: 5),
                            child: Icon(Icons.email_outlined),
                          ),
                        ),
                      ),
                    ),
                    // Username TextField
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
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: "Username",
                          icon: Padding(
                            padding: EdgeInsets.only(top: 1.0, left: 5),
                            child: Icon(Icons.account_box),
                          ),
                        ),
                      ),
                    ),
                    // Password TextField
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: 80, // Increase height to accommodate helper text
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        color: const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _passwordController,
                            obscureText: !_passwordVisible,
                            onChanged: (value) {
                              // Check password conditions here
                              // Update the UI accordingly based on conditions
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Password",
                              icon: const Padding(
                                padding: EdgeInsets.only(top: 2.0, left: 5),
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
                                  // Update the state i.e. toggle the state of passwordVisible variable
                                  setState(() {
                                    (_passwordVisible == true)
                                        ? _passwordVisible = false
                                        : _passwordVisible = true;
                                  });
                                },
                              ),
                            ),
                          ),
                          // Helper Text for Password Conditions
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Tooltip(
                              message: "Password must contain:\n- At least 8 characters.\n- At least one number.\n- At least one uppercase and one lowercase letter.\n- At least one special character.",
                              child: Text(
                                "Password must contain:\n- At least 8 characters.\n- At least one number.\n- At least one uppercase and one lowercase letter.\n- At least one special character.",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Radio Buttons for User Role
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: 40,
                      child: Row(
                        children: <Widget>[
                          // Owner
                          Radio<SingingCharacter>(
                            value: SingingCharacter.owner,
                            groupValue: _character,
                            onChanged: (SingingCharacter? value) {
                              setState(() {
                                _character = value;
                                print(value);
                              });
                            },
                            activeColor: (_character == SingingCharacter.owner) ? Colors.red : null, // Set active color to red if this option is selected
                          ),
                          const Text(
                            "Owner",
                            style: TextStyle(color: Colors.black),
                          ),
                          const SizedBox(
                            width: 50,
                          ),
                          // Customer
                          Radio(
                            value: SingingCharacter.user,
                            groupValue: _character,
                            onChanged: (SingingCharacter? value) {
                              setState(() {
                                _character = value;
                                print(value);
                              });
                            },
                            activeColor: (_character == SingingCharacter.user) ? Colors.red : null, // Set active color to red if this option is selected
                          ),
                          const Text(
                            "Customer",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),

                    // Register Button
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      margin: const EdgeInsets.fromLTRB(0, 20, 10, 20),
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () {
                          createAccount();
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                    ),
                    // Login Button
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () {
                          back();
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void createAccount() {
    String fullname = _nameController.value.text.toString();
    String mobile = _mobileController.value.text.toString();
    String email = _emailController.value.text.toString();
    String username = _usernameController.value.text.toString();
    String password = _passwordController.value.text.toString();

    // Check if the username already exists
    bool isUsernameExists = checkIfUsernameExists(username);

    if (isUsernameExists) {
      // Show a toast message that the username already exists
      Fluttertoast.showToast(
        msg: "Username already exists",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return; // Exit the function without continuing the registration process
    }

    // Send data for registration
    Map<String, dynamic> posts = {
      "username": username,
      "password": password,
      "fullname": fullname,
      "mobile": mobile,
      "email": email,
      "roleid": _character.toString()
    };
    dbservices.doPost("register", posts).then((result) {
      Map<String, dynamic> res = jsonDecode(result);
      var block = res['response'];
      Fluttertoast.showToast(
          msg: block['msg'],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: (block['status'] == "done") ? Colors.green : Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      if (block['status'] == "done") {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login(lang: lang)));
      }
    });
  }

  void back() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Login(lang: lang)));
  }

  bool checkIfUsernameExists(String username) {
    // Here you can perform a query to check if the username already exists in the database
    // You should execute the necessary query to check the existence of the username here
    // If the username is found, you can return true, otherwise, you can return false
    // This function should return based on the query that suits the type of database you're using
    return false; // Example: By default, let's assume the username doesn't exist
  }
}
