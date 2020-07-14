import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/modal/files_entity.dart';
import 'package:todo_app/res/app_constants.dart';
import 'dart:convert';

abstract class FileRepository {
  Future<int> getImportantCount();
  Future<List<FilesEnitity>> loadImpoartantFiles();
  Future<List<FilesEnitity>> getFilesFromFolder(String folderSlug);
  Future<bool> deleteFile(String slug);
  Future<bool> toogleImpoartant(String slug);
  Future<bool> addFile(
      String title, String contentbody, String folderSlug, String folderName);

  Future<bool> updateFile(String title, String contentbody, String folderSlug,
      String folderName, String slug);
}

class FileRepositoryImpl extends FileRepository {
  @override
  Future<int> getImportantCount() async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    String value = await storage.read(
      key: "jwt_token",
    );
    return http.get(AppConstants.apiEndpoint + "file/count/important",
        headers: {"Authorization": "Bearer " + value}).then((response) {
      if (response.statusCode == 200) {
        int jsonResponse = json.decode(response.body);
        return jsonResponse;
      } else {
        throw Exception();
      }
    });
  }

  @override
  Future<List<FilesEnitity>> getFilesFromFolder(String folderSlug) async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    String value = await storage.read(
      key: "jwt_token",
    );
    print(folderSlug);
    return http.get(
        AppConstants.apiEndpoint + "file/list/folder?folderSlug=" + folderSlug,
        headers: {"Authorization": "Bearer " + value}).then((response) {
      print(response);
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);

        List<FilesEnitity> list = List();
        list = (jsonResponse as List)
            .map((data) => new FilesEnitity.fromJson(data))
            .toList();
        return list;
      } else {
        throw Exception();
      }
    });
  }

  @override
  Future<bool> addFile(String title, String contentbody, String folderSlug,
      String folderName) async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    String value = await storage.read(
      key: "jwt_token",
    );
    Map data = {
      "title": title,
      "folderSlug": folderSlug,
      "contentbody": contentbody,
      "isImportant": false,
      "folderTitle": folderName
    };
    String body = json.encode(data);
    return http
        .post(AppConstants.apiEndpoint + "file/add",
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer " + value
            },
            body: body)
        .then((response) {
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    });
  }

  @override
  Future<bool> deleteFile(String slug) async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    String value = await storage.read(
      key: "jwt_token",
    );
    return http.post(AppConstants.apiEndpoint + "file/delete?slug=" + slug,
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

  @override
  Future<bool> updateFile(String title, String contentbody, String folderSlug,
      String folderName, String slug) async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    String value = await storage.read(
      key: "jwt_token",
    );
    Map data = {
      "title": title,
      "folderSlug": folderSlug,
      "contentbody": contentbody,
      "isImportant": false,
      "folderTitle": folderName,
      "slug": slug
    };
    String body = json.encode(data);
    return http
        .post(AppConstants.apiEndpoint + "file/update",
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer " + value
            },
            body: body)
        .then((response) {
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    });
  }

  @override
  Future<bool> toogleImpoartant(String slug) async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    String value = await storage.read(
      key: "jwt_token",
    );
    return http.post(
        AppConstants.apiEndpoint + "file/toogle/important?slug=" + slug,
        headers: {"Authorization": "Bearer " + value}).then((response) {
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    });
  }

  @override
  Future<List<FilesEnitity>> loadImpoartantFiles() async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    String value = await storage.read(
      key: "jwt_token",
    );
    return http.get(AppConstants.apiEndpoint + "file/list/important?",
        headers: {"Authorization": "Bearer " + value}).then((response) {
      print(response);
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);

        List<FilesEnitity> list = List();
        list = (jsonResponse as List)
            .map((data) => new FilesEnitity.fromJson(data))
            .toList();
        return list;
      } else {
        throw Exception();
      }
    });
  }
}
