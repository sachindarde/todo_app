import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:todo_app/modal/folders_entity.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/res/app_constants.dart';
import 'dart:convert';

abstract class FolderRepository {
  Future<List<FoldersEntity>> getFolders();
  Future<bool> saveFolder(String title, String colorCode);
  Future<bool> deleteFolder(String slug);
}

class FolderRepositoryImpl implements FolderRepository {
  @override
  Future<List<FoldersEntity>> getFolders() async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    String value = await storage.read(
      key: "jwt_token",
    );
    return http.get(AppConstants.apiEndpoint + "folder/list",
        headers: {"Authorization": "Bearer " + value}).then((response) {
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        List<FoldersEntity> list = List();
        list = (jsonResponse as List)
            .map((data) => new FoldersEntity.fromJson(data))
            .toList();
        return list;
      } else {
        throw Exception();
      }
    });
  }

  @override
  Future<bool> saveFolder(String title, String colorCode) async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    String value = await storage.read(
      key: "jwt_token",
    );

    Map data = {"title": title, "colorCode": colorCode};
    String body = json.encode(data);

    return http
        .post(AppConstants.apiEndpoint + "folder/add",
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer " + value
            },
            body: body)
        .then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    });
  }

  @override
  Future<bool> deleteFolder(String slug) async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    String value = await storage.read(
      key: "jwt_token",
    );
    return http.post(AppConstants.apiEndpoint + "folder/delete?slug=" + slug,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + value
        }).then((response) {
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    });
  }
}
