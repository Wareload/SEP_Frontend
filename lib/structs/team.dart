import 'package:flutter/foundation.dart';
import 'package:moody/structs/member.dart';

class Team {
  final String name;
  final int id;
  final List<Member> members;
  int leader;

  Team._(this.name, this.id, this.members, this.leader);

  static Team empty() {
    return Team._("", 0, [], 0);
  }

  //TODO need to implement

  static List<Team> getSimpleTeams(List teams) {
    var toReturn = <Team>[];
    for (var element in teams) {
      toReturn.add(
          Team._(element["name"], element["teamid"], [], element["leader"]));
    }
    return toReturn;
  }

  static List<Team> getSimpleTeamsInvitation(List teams) {
    var toReturn = <Team>[];
    for (var element in teams) {
      toReturn
          .add(Team._(element["name"], element["id"], [], element["leader"]));
    }
    return toReturn;
  }

  static Team getFullTeam(data) {
    String name = data["teamname"];
    int id = int.parse(data["teamid"]);
    List<Member> teamMember = [];
    var member = data["member"];
    for (var element in member) {
      Member m = Member(
          element["userid"],
          element["email"],
          element["firstname"],
          element["lastname"],
          element["tags"].cast<String>(),
          element["leader"]);

      teamMember.add(m);
    }
    return Team._(name, id, teamMember, 0);
  }
}
