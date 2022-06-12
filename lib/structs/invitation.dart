import 'package:moody/structs/team.dart';

class Invitation {
  int teamid = 0;
  String teamname = "_";

  Invitation(int id, String name) {
    this.teamid = id;
    this.teamname = name;
  }

  static List<Invitation> getSimpleInvitation(List invitations) {
    print("Here");
    var toReturn = <Invitation>[];
    print("invitations");
    for (var element in invitations) {
      toReturn.add(Invitation(element["id"], element["name"]));
    }
    return toReturn;
  }
}
