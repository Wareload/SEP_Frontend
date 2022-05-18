import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:moody/api/api_interface.dart';
import 'package:moody/api/exception/user_feedback.dart';
import 'package:moody/structs/invitation.dart';
import 'package:moody/structs/profile.dart';
import 'package:moody/structs/team.dart';
import 'package:moody/structs/validator.dart';

class ApiBackend implements ApiInterface {
  //api path
  final String pathUrl = "http://10.0.1.10:3000";

  //account routes
  final String pathAccountLogin = "/account/login";
  final String pathAccountRegister = "/account/register";
  final String pathAccountLogout = "/account/logout";
  final String pathAccountIsLoggedIn = "/account/isLoggedIn";

  //http data
  final int timeout = 5; //in seconds

  final bool allowBadCertificate = true;

  //session header
  final Map<String, String> _headers = {};

  ApiBackend._();

  ///get instance of ApiBackend
  static Future<ApiBackend> instance() async {
    ApiBackend api = ApiBackend._();
    await api._init();
    return api;
  }

  ///init api backend
  Future<void> _init() async {
    if (allowBadCertificate) {
      HttpOverrides.global = CustomHttpOverride();
    }
    const storage = FlutterSecureStorage();
    await storage.read(key: "cookie").then((value) => {
          if (value != null) {_headers['cookie'] = value}
        });
  }

  @override
  Future<void> acceptInvitation(int teamId) {
    // TODO: implement acceptInvitation
    throw UnimplementedError();
  }

  @override
  Future<void> addTeamMember(int teamId, String email) {
    // TODO: implement addTeamMember
    throw UnimplementedError();
  }

  @override
  Future<Profile> adjustProfile(Profile profile) {
    // TODO: implement adjustProfile
    throw UnimplementedError();
  }

  @override
  Future<Team> createTeam(String name) {
    // TODO: implement createTeam
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTeam(int id) {
    // TODO: implement deleteTeam
    throw UnimplementedError();
  }

  @override
  Future<List<Invitation>> getInvitations() {
    // TODO: implement getInvitations
    throw UnimplementedError();
  }

  @override
  Future<Profile> getProfile() {
    // TODO: implement getProfile
    throw UnimplementedError();
  }

  @override
  Future<Team> getTeam(int id) {
    // TODO: implement getTeam
    throw UnimplementedError();
  }

  @override
  Future<List<Team>> getTeams() {
    // TODO: implement getTeams
    throw UnimplementedError();
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      http.Response response = await http
          .post(Uri.parse(pathUrl + pathAccountIsLoggedIn), headers: _headers)
          .timeout(Duration(seconds: timeout));
      if (response.statusCode == 200) {
        return true;
      }
    } catch(e) {}
      return false;

  }

  @override
  Future<void> leaveTeam(int teamId) {
    // TODO: implement leaveTeam
    throw UnimplementedError();
  }

  @override
  Future<void> login(String email, String password) async {
    if (!(Validator.isEmail(email) && Validator.isPassword(password))) {
      throw UserFeedbackException("E-Mail oder Passwort ist falsch");
    }
    http.Response response;
    try {
      response = await http.post(Uri.parse(pathUrl + pathAccountLogin),
          headers: _headers,
          body: {
            "email": email,
            "password": password
          }).timeout(Duration(seconds: timeout));
    } catch (e) {
      throw UserFeedbackException("Server error");
    }
    switch (response.statusCode) {
      case 200:
        await updateCookie(response);
        return;
      case 400:
        throw UserFeedbackException("Ungültige E-Mail oder Passwort");
      case 401:
        throw UserFeedbackException("E-Mail oder Passwort ist falsch");
      default:
        throw UserFeedbackException("Server Fehler");
    }
  }

  @override
  Future<void> logout() async {
    try {
      http
          .post(Uri.parse(pathUrl + pathAccountLogout), headers: _headers)
          .timeout(Duration(seconds: timeout));
    } finally {
      _headers['cookie'] = "";
      const storage = FlutterSecureStorage();
      await storage.write(key: "cookie", value: _headers['cookie']);
    }
  }

  @override
  Future<void> promoteTeamLeader(int teamId, int userId) {
    // TODO: implement promoteTeamLeader
    throw UnimplementedError();
  }

  @override
  Future<void> register(
      String email, String password, String firstname, String lastname) async {
    //TODO need to specify invalid params
    if (!Validator.isEmail(email)) {
      throw UserFeedbackException("Ungültige E-Mail");
    } else if (!Validator.isPassword(password)) {
      throw UserFeedbackException("Ungültiges Passwort");
    } else if (!Validator.isText45(firstname)) {
      throw UserFeedbackException("Ungültiger Vorname");
    } else if (!Validator.isText45(lastname)) {
      throw UserFeedbackException("Ungültiger Nachname");
    }
    http.Response response;
    try {
      response = await http
          .post(Uri.parse(pathUrl + pathAccountRegister),
              body: {
                "email": email,
                "password": password,
                "firstname": firstname,
                "lastname": lastname
              },
              headers: _headers)
          .timeout(Duration(seconds: timeout));
    } catch (e) {
      throw UserFeedbackException("Server Error");
    }
    switch (response.statusCode) {
      case 200:
        updateCookie(response);
        return;
      case 400:
        throw UserFeedbackException("Invalid request form");
      case 409:
        throw UserFeedbackException("E-Mail exestiert bereits");
    }
    throw UserFeedbackException("Server Fehler");
  }

  @override
  Future<void> removeTeamMember(int teamId, int userId) {
    // TODO: implement removeTeamMember
    throw UnimplementedError();
  }

  Future<void> updateCookie(http.Response response) async {
    var rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      _headers['cookie'] =
          (index == -1) ? rawCookie : rawCookie.substring(0, index);
      const storage = FlutterSecureStorage();
      await storage.write(key: "cookie", value: _headers['cookie']);
    }
  }
}

class CustomHttpOverride extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
