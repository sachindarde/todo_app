import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:todo_app/modal/error_helper.dart';
import 'package:todo_app/modal/user.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/res/app_constants.dart';
import 'dart:convert';

abstract class UserRepository {
  Future<bool> isSignedIn();
  Future<User> authenticatUser();
  Future<ErrorHelper> signInUser(String email, String password);
  Future<ErrorHelper> signUpUser(
      String email, String name, String avatar, String password);
}

class UserRepositoryImpl extends UserRepository {
  @override
  Future<bool> isSignedIn() async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    String value = await storage.read(
      key: "jwt_token",
    );
    return value != null;
  }

  @override
  Future<User> authenticatUser() async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    String value = await storage.read(
      key: "jwt_token",
    );
    return http.get(AppConstants.apiEndpoint + "user/me",
        headers: {"Authorization": "Bearer " + value}).then((response) {
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        User user = User.fromJson(jsonResponse);
        return user;
      } else {
        throw Exception();
      }
    });
  }

  @override
  Future<ErrorHelper> signUpUser(
      String email, String name, String avatar, String password) {
    Map data = {
      "username": email,
      "name": name,
      "avatar": avatar,
      "password": password
    };
    String body = json.encode(data);
    return http
        .post(AppConstants.apiEndpoint + "signup",
            headers: {"Content-Type": "application/json"}, body: body)
        .then((response) async {
      if (response.statusCode == 200) {
        FlutterSecureStorage storage = FlutterSecureStorage();
        var jsonResponse = json.decode(response.body);
        await storage.write(key: "jwt_token", value: jsonResponse["token"]);
        return ErrorHelper(isError: false);
      } else if (response.statusCode == 401) {
        return ErrorHelper(isError: true, error: "UNAUTHORIZED");
      } else if(response.statusCode==406){
        return ErrorHelper(isError: true, error: "ALREADY EXISTS");
      }
    }).catchError(
            (error) => ErrorHelper(isError: true, error: error.toString()));
  }

  @override
  Future<ErrorHelper> signInUser(String email, String password) {
    Map data = {"username": email, "password": password};
    String body = json.encode(data);
    return http
        .post(AppConstants.apiEndpoint + "login",
            headers: {"Content-Type": "application/json"}, body: body)
        .then((response) async {
          print(response.statusCode);
      if (response.statusCode == 200) {
        FlutterSecureStorage storage = FlutterSecureStorage();
        var jsonResponse = json.decode(response.body);
        await storage.write(key: "jwt_token", value: jsonResponse["token"]);
        return ErrorHelper(isError: false);
      } else if (response.statusCode == 401) {
        return ErrorHelper(isError: true, error: "UNAUTHORIZED");
      } else {
        return ErrorHelper(isError: true, error: "UNKNOWN");
      }
    }).catchError(
            (error) => ErrorHelper(isError: true, error: "Connection refused"));
    ;
  }
}
