import 'package:moody/structs/invitation.dart';
import 'package:moody/structs/profile.dart';
import 'package:moody/structs/team.dart';

import 'api_backend.dart';

abstract class ApiInterface {
  ApiInterface._();

  static getInstance() {}

  //account
  /// try to login
  Future<void> login(String email, String password);

  ///try to register
  Future<void> register(
      String email, String password, String firstname, String lastname);

  ///logout
  Future<void> logout();

  ///check if currently logged in
  Future<bool> isLoggedIn();

  //profile
  ///get profile of current user
  Future<Profile> getProfile();

  ///update profile of current user
  Future<Profile> adjustProfile(Profile profile);

  //team
  ///create new team by name
  Future<void> createTeam(String name);

  ///delete existing team by id
  Future<void> deleteTeam(int id);

  ///list all teams belonging to the current user
  Future<List<Team>> getTeams();

  ///get more information from a team by id
  Future<Team> getTeam(int id);

  ///promote another user of the team to team leader
  Future<void> promoteTeamLeader(int teamId, int userId);

  ///try to adds a user to a team by user email
  Future<void> addTeamMember(int teamId, String email);

  ///remove team member from team by teamId and userId
  Future<void> removeTeamMember(int teamId, int userId);

  ///leave team by team id when not the teamleader
  Future<void> leaveTeam(int teamId);

  ///accept an pending invitation for a team
  Future<void> acceptInvitation(int teamId);

  ///get all pending invitations for the current user
  Future<List<Invitation>> getInvitations();
//mood

  ///submit your current mood
  Future<void> setMood(int teamId, int mood, String note);

  ///returns your mood for this timeperiod
  Future<void> getPersonalMood(int teamid, String startDate, String endDate);

  //returns Moods for a specific time and for a team
  Future<void> getTeamMood(int teamid, String startDate, String endDate);

  ///returns your moodstatus if you can submit a mood or if you have to wait
  Future<void> getMoodTimer(int teamid);

  ///get more information from a team by id
  Future<List<TeamMoods>> getTeamMoods();
}
