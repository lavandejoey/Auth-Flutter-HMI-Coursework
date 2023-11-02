import "dart:convert";
import "package:http/http.dart" as http;
import "user.dart";

class UserDb {
  // String mstrHostUrl = "http://192.168.3.8:1211/r";
  String mstrHostUrl = "https://JoshuaZiyiLIU.com/r";
  String mstrUsername = "Joshua";
  static const Map<String, String> mmapHeader = {
    "User-Agent": "Android 14.0.1",
    "Accept": "*/*",
    "Accept-Encoding": "gzip, deflate",
    "Connection": "keep-alive",
    "Content-Type": "application/json",
    "Authorization":
        "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTY5ODg1MTMzNCwianRpIjoiNWM3OTE5NjctYWNhZC00MzY1LTkxZGUtZmUyMDFhMzY5ZWZmIiwidHlwZSI6ImFjY2VzcyIsInN1YiI6InRlc3QiLCJuYmYiOjE2OTg4NTEzMzQsImNzcmYiOiJhODk3ZjdmMS1mMzc5LTRhNmYtOWI0Zi03YjkyNzI2MGUwM2EifQ.iHQMhQTNwunLYLjKBFd4v8bRNQsIwd2Y6rqduvKCSY8",
  };
  User? muserCurrentUser;
  bool mbLoggedIn = false;

  Future<User?> insertUser(User user) async {
    final Uri uriUrl = Uri.parse("$mstrHostUrl/db/user");
    final jsonUser = jsonEncode(user.toMap());
    final responseGetUser =
        await http.put(uriUrl, headers: mmapHeader, body: jsonUser);

    if (responseGetUser.statusCode == 200) {
      Map<String, dynamic> mapResponseData = jsonDecode(responseGetUser.body);
      Map<String, dynamic> mapUser = mapResponseData["user"];
      return User.fromMap(mapUser);
    } else {
      return null;
    }
  }

  // enquiry user
  Future<User?> getUser({String? uid, String? username, String? email}) async {
    String getArgs = "?";
    if (uid != null) {
      getArgs += "uid=$uid";
    }
    if (username != null) {
      getArgs += "${getArgs.isEmpty ? "" : "&"}username=$username";
    }
    if (email != null) {
      getArgs += "${getArgs.isEmpty ? "" : "&"}email=$email";
    }

    final Uri uriUrl = Uri.parse("$mstrHostUrl/db/user$getArgs");
    final responseGetUser = await http.get(uriUrl, headers: mmapHeader);

    if (responseGetUser.statusCode == 200) {
      Map<String, dynamic> mapResponseData = jsonDecode(responseGetUser.body);
      if (mapResponseData.containsKey("users") &&
          (mapResponseData["users"] as List).isNotEmpty) {
        Map<String, dynamic> mapUser = mapResponseData["users"][0];
        return User.fromMap(mapUser);
      }
    }
    return null;
  }

  // updateUser
  Future<bool> updateUser(User user) async {
    final Uri uriUrl = Uri.parse("$mstrHostUrl/db/user");
    final jsonUser = jsonEncode(user.toMap());
    final responseUpdateUser =
        await http.put(uriUrl, headers: mmapHeader, body: jsonUser);

    if (responseUpdateUser.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<User?> authUser(
      String? username, String? email, String password) async {
    final Uri uriUrl = Uri.parse("$mstrHostUrl/db/auth");
    final Map<String, dynamic> mapBody = {
      "username": username ?? "",
      "email": email ?? "",
      "password": password,
      "with_token": true
    };
    final responseAuthUser =
        await http.post(uriUrl, headers: mmapHeader, body: jsonEncode(mapBody));

    if (responseAuthUser.statusCode == 200) {
      Map<String, dynamic> mapResponseData = jsonDecode(responseAuthUser.body);
      if (mapResponseData.containsKey("user")) {
        muserCurrentUser = User.fromMap(mapResponseData["user"]);
        mbLoggedIn = true;
        return muserCurrentUser;
      }
    } else {
      return null;
    }
  }

  void logOut() {
    muserCurrentUser = null;
    mbLoggedIn = false;
  }

  // getUserCount
  Future<int> getUserCount() async {
    final Uri uriUrl = Uri.parse("$mstrHostUrl/db/user-count");
    final responseGetUserCount = await http.get(uriUrl, headers: mmapHeader);

    if (responseGetUserCount.statusCode == 200) {
      Map<String, dynamic> mapResponseData =
          jsonDecode(responseGetUserCount.body);
      return mapResponseData["count"];
    } else {
      return -1;
    }
  }
}
