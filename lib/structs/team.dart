import 'package:flutter/foundation.dart';
import 'package:moody/structs/member.dart';

class Team {
  final String name;
  final int id;
  final List<Member> _members;

  Team._(this.name, this.id, this._members);

//TODO need to implement

  static getSimpleTeams(List teams) {
    var toReturn = <Team>[];
    for (var element in teams) {
      toReturn.add(Team._(element["name"], element["teamid"], []));
    }
    return toReturn;
  }
}
