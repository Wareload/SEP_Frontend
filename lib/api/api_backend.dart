import 'package:moody/api/api_interface.dart';
import 'package:moody/structs/invitation.dart';
import 'package:moody/structs/profile.dart';
import 'package:moody/structs/team.dart';

class ApiBackend implements ApiInterface{
  @override
  Future<void> acceptInvitation (int teamId) {
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
  Future<void> isLoggedIn() {
    // TODO: implement isLoggedIn
    throw UnimplementedError();
  }

  @override
  Future<void> leaveTeam(int teamId) {
    // TODO: implement leaveTeam
    throw UnimplementedError();
  }

  @override
  Future<bool> login(String email, String password) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<void> promoteTeamLeader(int teamId, int userId) {
    // TODO: implement promoteTeamLeader
    throw UnimplementedError();
  }

  @override
  Future<bool> register(String email, String password, String firstname, String lastname) {
    // TODO: implement register
    throw UnimplementedError();
  }

  @override
  Future<void> removeTeamMember(int teamId, int userId) {
    // TODO: implement removeTeamMember
    throw UnimplementedError();
  }

}