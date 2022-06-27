import 'package:moody/structs/team.dart';

class Invitation {
  int teamid = 0;
  String teamname = "_";
  bool active = false;

  Invitation(int id, String name) {
    this.teamid = id;
    this.teamname = name;
  }

  bool isActive() {
    return active;
  }

  toggleActive() {
    active = !active;
  }

  static List<Invitation> getSimpleInvitation(List invitations) {
    var toReturn = <Invitation>[];
    for (var element in invitations) {
      toReturn.add(Invitation(element["id"], element["name"]));
    }
    return toReturn;
  }
}
