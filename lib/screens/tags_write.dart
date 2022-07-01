import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moody/api/api.dart';
import 'package:moody/route/route_generator.dart';
import 'package:moody/structs/profile.dart';
import 'package:moody/widgets/settings.dart';
import 'package:moody/widgets/widgets.dart';

import '../structs/team.dart';

class TagsWrite extends StatefulWidget {
  const TagsWrite({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TagsWriteState();
}

class _TagsWriteState extends State<TagsWrite> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController tagsController = TextEditingController();

  Profile _profile = new Profile("email", "firstname", "lastname", []);
  int runs = 0;
  @override
  Widget build(BuildContext context) {
    var args = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    _profile = args['profile'];
    if (runs <= 1) {
      runs++;
      firstNameController.text = _profile.firstname;
      lastNameController.text = _profile.lastname;
      String _1 = _profile.tags.toString().replaceAll(RegExp('\\['), '');
      String _2 = _1.replaceAll(RegExp('\\]'), '');
      String tagsToString = _2.replaceAll(RegExp(' '), '');

      tagsController.text = tagsToString;
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(child: LayoutBuilder(builder: (builder, constraints) {
          return CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Widgets.getNavBarWithoutProfile(
                            constraints, _back, "Profil bearbeiten"),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                "Vorname:",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Widgets.getSmallInputField(firstNameController,
                                TextInputType.name, constraints, "Vorname"),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                "Nachname:",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Widgets.getSmallInputField(lastNameController,
                                TextInputType.name, constraints, "Nachname"),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                "Tags:",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Widgets.getSmallInputField(
                                tagsController,
                                TextInputType.name,
                                constraints,
                                "BSP: Backend,Java,Minecraft"),
                          ],
                        ),
                        Widgets.getButtonStyleOrange(() => {updateProfile()},
                            constraints, "Profil abspeichern"),
                        SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        })));
  }

  Future<void> updateProfile() async {
    Profile newProfile = _profile;
    newProfile.firstname = firstNameController.text;
    newProfile.lastname = lastNameController.text;
    List<String> tags = tagsController.text.split(",");
    print(newProfile.tags);
    newProfile.tags = tags;
    //newProfile
    try {
      var response = await Api.api.adjustProfile(newProfile);
    } catch (e) {
      print(e);
    }
    Navigator.pushReplacementNamed(context, RouteGenerator.profileOverview);
  }

  void _renderNew() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  void _back() {
    Navigator.pop(context);
  }

  textWidgetCentered(String text) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
