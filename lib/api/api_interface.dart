import 'package:moody/structs/invitation.dart';
import 'package:moody/structs/profile.dart';
import 'package:moody/structs/team.dart';

abstract class ApiInterface {
  //account
  /// try to login
  Future<bool> login(String email, String password);

  ///try to register
  Future<bool> register(
      String email, String password, String firstname, String lastname);

  ///logout
  Future<void> logout();

  ///check if currently logged in
  Future<void> isLoggedIn();

  //profile
  ///get profile of current user
  Future<Profile> getProfile();

  ///update profile of current user
  Future<Profile> adjustProfile(Profile profile);

  //team
  ///create new team by name
  Future<Team> createTeam(String name);

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

}
