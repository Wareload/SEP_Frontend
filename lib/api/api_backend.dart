import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:moody/api/api_interface.dart';
import 'package:moody/api/exception/invalid_permission_exception.dart';
import 'package:moody/api/exception/user_feedback_exception.dart';
import 'package:moody/structs/invitation.dart';
import 'package:moody/structs/profile.dart';
import 'package:moody/structs/team.dart';
import 'package:moody/validator/validator.dart';
import 'package:moody/widgets/widgets.dart';

class ApiBackend implements ApiInterface {
  //api path
  final String pathUrl = "https://api.bugsbunnies.de";

  //account routes
  final String pathAccountLogin = "/account/login";
  final String pathAccountRegister = "/account/register";
  final String pathAccountLogout = "/account/logout";
  final String pathAccountIsLoggedIn = "/account/isLoggedIn";

  //team routes
  final String pathTeamGetTeams = "/team/getTeams";
  final String pathTeamCreateTeam = "/team/createTeam";
  final String pathTeamDeleteTeam = "/team/deleteTeam";
  final String pathTeamGetTeam = "/team/getTeam";
  final String pathTeamGetInvitations =
      "/team/getInvitations"; //TODO need to implement
  final String pathTeamLeaveTeam = "/team/leaveTeam"; //TODO need to implement
  final String pathTeamRemoveTeamMember =
      "/team/removeTeamMember"; //TODO need to implement
  final String pathTeamPromoteTeamMember =
      "/team/promoteTeamMember"; //TODO need to implement
  final String pathTeamAddTeamMember =
      "/team/addTeamMember"; //TODO need to implement
  final String pathTeamAcceptInvitationTeamMember =
      "/team/acceptInvitation"; //TODO need to implement

  //profile routes
  final String pathProfileGetProfile =
      "/profile/getProfile"; //TODO need to implement
  final String pathProfileAdjustProfile =
      "/profile/adjustProfile"; //TODO need to implement

  //mood routes
  final String pathGetTimer = "/mood/getTimer"; //TODO need to implement
  final String pathSetMood = "/mood/setMood";
  final String pathGetPersonalMood = "/mood/getPersonalMood";
  final String pathGetTeamMood = "/mood/getTeamMood"; //TODO need to implement

  //http data
  final int timeout = 3; //in seconds

  //only for testing purpose if needed
  final bool allowBadCertificate = false;

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

  //Account

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
        throw UserFeedbackException("Ungültige Eingaben");
      case 409:
        throw UserFeedbackException("E-Mail exestiert bereits");
    }
    throw UserFeedbackException("Server Fehler");
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
    } catch (e) {}
    return false;
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

  //Profile

  @override
  Future<Profile> adjustProfile(Profile profile) {
    // TODO: implement adjustProfile
    throw UnimplementedError();
  }

  @override
  Future<Profile> getProfile() async {
    // TODO: implement getProfile
    http.Response response;
    try {
      response = await http.post(Uri.parse(pathUrl + pathProfileGetProfile),
          headers: _headers, body: {}).timeout(Duration(seconds: timeout));
    } catch (e) {
      throw UserFeedbackException("Server error$e");
    }
    switch (response.statusCode) {
      case 200:
        //var teams = <Team>[];
        var body = json.decode(response.body);
        var email = body["email"];
        var firstname = body["firstname"];
        var lastname = body["lastname"];
        var tags = body["tags"];
        Profile profile = new Profile(email, firstname, lastname, tags);
        await updateCookie(response);
        return profile;
      case 401:
        throw InvalidPermissionException("Unauthorized");
      default:
        throw UserFeedbackException("Server Fehler");
    }
    throw UnimplementedError();
  }

  //Team

  @override
  Future<void> removeTeamMember(int teamId, int userId) {
    // TODO: implement removeTeamMember
    throw UnimplementedError();
  }

  @override
  Future<Team> getTeam(int id) async {
    http.Response response;
    try {
      response = await http
          .post(Uri.parse(pathUrl + pathTeamGetTeam),
              body: {"teamid": id.toString()}, headers: _headers)
          .timeout(Duration(seconds: timeout));
    } catch (e) {
      throw UserFeedbackException("Server Error");
    }
    switch (response.statusCode) {
      case 200:
        var body = json.decode(response.body);
        var team = Team.getFullTeam(body);
        updateCookie(response);
        return team;
      case 400:
        throw UserFeedbackException("Ungültige Eingaben");
      case 401:
        throw InvalidPermissionException("Keine Berechtigung");
    }
    throw UserFeedbackException("Server Fehler");
  }

  @override
  Future<List<Team>> getTeams() async {
    http.Response response;
    try {
      response = await http.post(Uri.parse(pathUrl + pathTeamGetTeams),
          headers: _headers, body: {}).timeout(Duration(seconds: timeout));
    } catch (e) {
      throw UserFeedbackException("Server error");
    }
    switch (response.statusCode) {
      case 200:
        var teams = <Team>[];
        var body = json.decode(response.body);
        teams = Team.getSimpleTeams(body["teams"]);
        await updateCookie(response);
        teams.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        return teams;
      case 401:
        throw InvalidPermissionException("Unauthorized");
      default:
        throw UserFeedbackException("Server Fehler");
    }
  }

  @override
  Future<void> acceptInvitation(int teamId) async {
    http.Response response;
    try {
      response = await http
          .post(Uri.parse(pathUrl + pathTeamAcceptInvitationTeamMember),
              body: {"teamid": teamId.toString()}, headers: _headers)
          .timeout(Duration(seconds: timeout));
    } catch (e) {
      throw UserFeedbackException("Server Error");
    }
    switch (response.statusCode) {
      case 200:
        updateCookie(response);
        return;
      case 400:
        throw UserFeedbackException("Ungültige Eingaben");
      case 401:
        throw InvalidPermissionException("Keine Berechtigung");
    }
    throw UserFeedbackException("Server Fehler");
  }

  @override
  Future<String> addTeamMember(int teamId, String email) async {
    http.Response response;
    try {
      response = await http
          .post(Uri.parse(pathUrl + pathTeamAddTeamMember),
              body: {"teamId": teamId.toString(), "userEmail": email},
              headers: _headers)
          .timeout(Duration(seconds: timeout));
    } catch (e) {
      throw UserFeedbackException("Server Error");
    }
    switch (response.statusCode) {
      case 200:
        updateCookie(response);
        return "Erfolgreich eingeladen";
      case 400:
        return "Ungültige Eingabe";
        throw UserFeedbackException("Ungültige Eingaben");
      case 401:
        return "Keine Berechtigung!";
        throw InvalidPermissionException("Keine Berechtigung");
    }
    return "Server Fehler";
    throw UserFeedbackException("Server Fehler");
  }

  @override
  Future<void> createTeam(String name) async {
    //TODO need to specify invalid params
    if (!Validator.isText45(name)) {
      throw UserFeedbackException("Ungültiger Teamname");
    }
    http.Response response;
    try {
      response = await http
          .post(Uri.parse(pathUrl + pathTeamCreateTeam),
              body: {"teamname": name}, headers: _headers)
          .timeout(Duration(seconds: timeout));
    } catch (e) {
      throw UserFeedbackException("Server Error");
    }
    switch (response.statusCode) {
      case 200:
        updateCookie(response);
        return;
      case 400:
        throw UserFeedbackException("Ungültige Eingaben");
      case 401:
        throw InvalidPermissionException("Keine Berechtigung");
    }
    throw UserFeedbackException("Server Fehler");
  }

  @override
  Future<String> deleteTeam(int id) async {
    http.Response response;
    try {
      response = await http
          .post(Uri.parse(pathUrl + pathTeamDeleteTeam),
              body: {"teamid": id.toString()}, headers: _headers)
          .timeout(Duration(seconds: timeout));
    } catch (e) {
      throw UserFeedbackException("Server Error");
    }
    switch (response.statusCode) {
      case 200:
        updateCookie(response);
        return "Erfolgreich gelöscht";
      case 400:
        throw UserFeedbackException("Ungültige Eingaben");
      case 401:
        return "Keine Berechtigung";
        throw InvalidPermissionException("Keine Berechtigung");
    }
    return "Keine Berechtigung";
    throw UserFeedbackException("Server Fehler");
  }

  @override
  Future<List<Invitation>> getInvitations() async {
    http.Response response;
    try {
      response = await http.post(Uri.parse(pathUrl + pathTeamGetInvitations),
          headers: _headers, body: {}).timeout(Duration(seconds: timeout));
    } catch (e) {
      throw UserFeedbackException("Server error");
    }
    switch (response.statusCode) {
      case 200:
        var invitations = <Invitation>[];
        try {
          String rightresponse = response.body;
          final replaced1 = rightresponse.replaceAll('[', '');

          final replaced2 = replaced1.replaceFirst("]", '');

          print(replaced2);
          var body = json.decode(rightresponse);
          invitations = Invitation.getSimpleInvitation(body);
          invitations.toString();
        } catch (e) {
          print(e);
        }

        await updateCookie(response);
        //invitations.sort((a, b) => a.teamname.toLowerCase().compareTo(b.teamname.toLowerCase()));
        return invitations;
      case 401:
        throw InvalidPermissionException("Unauthorized");
      default:
        throw UserFeedbackException("Server Fehler");
    }
    throw UnimplementedError();
  }

  @override
  Future<void> promoteTeamLeader(int teamId, int userId) {
    // TODO: implement promoteTeamLeader
    throw UnimplementedError();
  }

  @override
  Future<void> leaveTeam(int teamId) async {
    http.Response response;
    try {
      response = await http
          .post(Uri.parse(pathUrl + pathTeamLeaveTeam),
              body: {"teamid": teamId.toString()}, headers: _headers)
          .timeout(Duration(seconds: timeout));
    } catch (e) {
      throw UserFeedbackException("Server Error");
    }
    switch (response.statusCode) {
      case 200:
        updateCookie(response);
        return;
      case 400:
        throw UserFeedbackException("Ungültige Eingaben");
      case 401:
        throw InvalidPermissionException("Keine Berechtigung");
    }
    throw UserFeedbackException("Server Fehler");
  }

  //Mood

  //submit Mood
  @override
  Future<void> setMood(int teamId, int mood, String note) async {
    http.Response response;
    try {
      response = await http
          .post(Uri.parse(pathUrl + pathSetMood),
              body: {
                "teamid": teamId.toString(),
                "mood": mood.toString(),
                "note": note,
              },
              headers: _headers)
          .timeout(Duration(seconds: timeout));
    } catch (e) {
      print(e);
      throw UserFeedbackException("Server Error");
    }
    switch (response.statusCode) {
      case 200:
        updateCookie(response);
        return;
      case 400:
        throw UserFeedbackException("Ungültige Eingaben");
      case 401:
        throw InvalidPermissionException("Keine Berechtigung");
    }
    throw UserFeedbackException("Server Fehler");
  }

  //returns your Personal mood for the selected period
  @override
  Future<List<MoodObject>> getPersonalMood(
      int teamid, String startDate, String endDate) async {
    print("Teamid:${teamid} Startdate:${startDate} ENDDATE:${endDate}");
    http.Response response;
    try {
      response = await http
          .post(Uri.parse(pathUrl + pathGetPersonalMood),
              body: {
                "teamid": teamid.toString(),
                "startDate": startDate,
                "endDate": endDate,
                /* "startDate": '"$startDate"',
                "endDate": '"$endDate"',*/
              },
              headers: _headers)
          .timeout(Duration(seconds: timeout));
      print(response.body);
    } catch (e) {
      print(e);
      throw UserFeedbackException("Server Error");
    }
    switch (response.statusCode) {
      case 200:
        var moodobjects = <MoodObject>[];
        var body = json.decode(response.body);
        moodobjects = MoodObject.getSimpleMoodObjects(body["moods"]);
        await updateCookie(response);
        return moodobjects;
      case 400:
        print(response.request);
        print(response.body);
        print(response.statusCode);
        throw UserFeedbackException("Ungültige Eingaben");
      case 401:
        throw InvalidPermissionException("Keine Berechtigung");
    }
    throw UserFeedbackException("Server Fehler");
  }

  @override
  Future<List<MoodObject>> getTeamMood(
      int teamid, String startDate, String endDate) async {
    print("Teamid:${teamid} Startdate:${startDate} ENDDATE:${endDate}");
    http.Response response;
    try {
      response = await http
          .post(Uri.parse(pathUrl + pathGetTeamMood),
              body: {
                "teamid": teamid.toString(),
                "startDate": startDate,
                "endDate": endDate,
                /* "startDate": '"$startDate"',
                "endDate": '"$endDate"',*/
              },
              headers: _headers)
          .timeout(Duration(seconds: timeout));
      print(response.body);
    } catch (e) {
      print(e);
      throw UserFeedbackException("Server Error");
    }
    switch (response.statusCode) {
      case 200:
        var moodobjects = <MoodObject>[];
        var body = json.decode(response.body);
        moodobjects = MoodObject.getSimpleMoodObjects(body["moods"]);
        await updateCookie(response);
        return moodobjects;
      case 400:
        print(response.request);
        print(response.body);
        print(response.statusCode);
        throw UserFeedbackException("Ungültige Eingaben");
      case 401:
        throw InvalidPermissionException("Keine Berechtigung");
    }
    throw UserFeedbackException("Server Fehler");
  }

  /*
    @override
  Future<List<Team>> getTeams() async {
    http.Response response;
    try {
      response = await http.post(Uri.parse(pathUrl + pathTeamGetTeams),
          headers: _headers, body: {}).timeout(Duration(seconds: timeout));
    } catch (e) {
      throw UserFeedbackException("Server error");
    }
    switch (response.statusCode) {
      case 200:
        var teams = <Team>[];
        var body = json.decode(response.body);
        teams = Team.getSimpleTeams(body["teams"]);
        await updateCookie(response);
        teams.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        return teams;
      case 401:
        throw InvalidPermissionException("Unauthorized");
      default:
        throw UserFeedbackException("Server Fehler");
    }
  }
   */

  ///returns your moodstatus if you can submit a mood or if you have to wait
  @override
  Future<bool> getMoodTimer(int teamid) async {
    http.Response response;
    try {
      response = await http
          .post(Uri.parse(pathUrl + pathGetTimer),
              body: {"teamid": teamid.toString()}, headers: _headers)
          .timeout(Duration(seconds: timeout));
    } catch (e) {
      throw UserFeedbackException("Server Error");
    }
    switch (response.statusCode) {
      case 200:
        updateCookie(response);
        return true;
      case 400:
        throw UserFeedbackException("Ungültige Eingaben");
      case 401:
        throw InvalidPermissionException("Keine Berechtigung");
      case 409:
        return false;
    }
    throw UserFeedbackException("Server Fehler");
  }

//general helper
  ///update cookie persistent
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

class Mood {
  late int teamid;
  late int mood;
  late String date;

  Mood(int teamid, int mood, String date) {
    this.teamid = teamid;
    this.mood = mood;
    this.date = date;
  }
}
