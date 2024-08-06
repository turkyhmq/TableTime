import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tabletime/restaurants.dart';
import 'dbase/dbservices.dart';
import 'package:http/http.dart' as http;

class newRestaurant extends StatefulWidget {
  String lang;
  String userid;
  String username;
  String roleid;
  var rows;

  newRestaurant({Key? key, required this.userid, required this.username, required this.roleid,
      required this.rows,
      required this.lang})
      : super(key: key);

  @override
  _newRestaurantState createState() =>
      _newRestaurantState(this.userid, this.username, this.roleid, this.rows, this.lang);
}

class _newRestaurantState extends State<newRestaurant> {
  String lang;
  String userid;
  String username;
  String roleid;
  var rows;

  _newRestaurantState(this.userid, this.username, this.roleid, this.rows, this.lang);

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
  }

  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _telController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _imgPathController = TextEditingController();

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
               const Text("New Restaurant",
              style: TextStyle(fontSize: 20),
                 textAlign: TextAlign.center,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 40,
                margin: const EdgeInsets.fromLTRB(50, 0, 50, 15),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Name",
                    icon: Padding(
                      padding: EdgeInsets.only(top: 1.0, left: 5,),
                      child: Icon(Icons.restaurant),
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 40,
                margin: const EdgeInsets.fromLTRB(50, 0, 50, 15),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Description",
                    icon: Padding(
                      padding: EdgeInsets.only(top: 1.0, left: 5,),
                      child: Icon(Icons.description_outlined),
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
                margin: const EdgeInsets.fromLTRB(50, 0, 50, 15),
                width: MediaQuery.of(context).size.width * 0.7,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextField(
                  controller: _telController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Phone",
                    icon: Padding(
                      padding: EdgeInsets.only(top: 1.0, left: 5,),
                      child: Icon(Icons.mobile_screen_share_sharp),
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
                  controller: _addressController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Address",
                    icon: Padding(
                      padding: EdgeInsets.only(top: 1.0, left: 5,),
                      child: Icon(Icons.streetview),
                    ),
                  ),
                ),
              ),
              // upload image
              GestureDetector(
                onTap: (){
                  chooseImage();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  padding: EdgeInsets.all(10),
                  margin: const EdgeInsets.fromLTRB(50, 0, 50, 15),
                  decoration: BoxDecoration(
                      color: Color(0xFFEFE9E1),
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: Text("Upload Image"),
                ),
              ),
              if(_viewimg)
                Container(
                  margin: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Image(
                    image: NetworkImage(imagePath) as ImageProvider,
                    fit: BoxFit.fill,
                  ),
                ),
              // Button Register
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                margin: const EdgeInsets.fromLTRB(50, 10, 50, 15),
                decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(onPressed: () {
                  saveRest();
                }, child: const Text('Save',
                  style: TextStyle(color: Colors.black, fontSize: 20),),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                margin: const EdgeInsets.fromLTRB(50, 10, 50, 15),
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

  void saveRest() {
    String restname = _nameController.text;
    String descr = _descriptionController.text;
    String email = _emailController.text;
    String phone = _telController.text;
    String address = _addressController.text;
    String restimg = _imgPathController.text;

    Map<String, dynamic> posts = {"act": "saveRest", "restname":restname, "descr":descr,
      "email": email, "phone":phone, "address":address, "restimg":restimg, "userid": userid};
    dbservices.doPost("saveRest", posts).then((result) {
      Map<String, dynamic> res = jsonDecode(result);
      var block = res['response'];
      if (block['status'] == "done") {
        var rows = block['rows']; // user profile data

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) =>
                Restaurants(userid: userid, username: username,  roleid: roleid, rows: rows, lang: lang,)));
      }
    });
  }


  /*
  Upload image
   */
  String imagePath = "";
  bool _viewimg = false;

  Future<String?> uploadImage(filepath) async {
    String url = dbservices.ROOT;
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['act'] = 'upload';
    request.fields['userid'] = userid;
    request.fields['foldername'] = "restimgs";
    request.files.add(await http.MultipartFile.fromPath('image', filepath));

    var res = await request.send();
    var response = await http.Response.fromStream(res);
    print("response" + response.body);

    Map<String, dynamic> upldres = jsonDecode(response.body);
    var upblock = upldres['response'];
    if(upblock['status'] == "done"){
      imagePath = upblock['newimgname'];
      _imgPathController.text = imagePath;
      setState(() {
        _viewimg = true;
      });
    }
    return res?.reasonPhrase;
  }

  XFile? pickedFile;
  final ImagePicker _picker = ImagePicker();
  Future<void> chooseImage() async {
    try {
      pickedFile = await _picker.pickImage(
        source: ImageSource.gallery, maxWidth: 1024, maxHeight: 750,
        imageQuality: 100,
      );
      setState(() {
        saveImage();
      });
    } catch (e) {
      setState(() {
        print(e);
      });
    }
  }

  Future<void> saveImage() async {
    var res = await uploadImage(pickedFile?.path);
  }
/*
End upload
*/

}
