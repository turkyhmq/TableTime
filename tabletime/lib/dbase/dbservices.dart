import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class dbservices {
  static const String Server = '192.168.1.4';
  static const String Folder = '/tabletime/';
  //static const String Folder = '/';
  static const String scripts = 'scripts.php';
  // ignore: constant_identifier_names
  static const ROOT = 'http://' + Server + Folder + scripts;
  static Future<String> doPost(String action, Map<String,dynamic> posts) async {
    try {
      var map = Map<String, dynamic>();
      map['act'] = action;
      // fetch fields and values
      posts.forEach((key, value) {
        map[key] = value;
      });
      print(ROOT);
      print("Action: " + action);
      print('Posts: ' + posts.toString());
      final http.Response response = await http.post(Uri.parse(ROOT), body: map);
      String result = "";
      print('Response: ${response.body}');
      if (200 == response.statusCode) {
        result = response.body;
      }else{
        result = 'cannot connect to database server.';
      }
      return result;
    } catch (e) {
      print(e);
      return 'error cannot open http link'; // return an empty list on exception/error
    }
  }

}