class Profile {
  String email = "";
  String firstname = "";
  String lastname = "";
  List<dynamic> tags = [];

  Profile(String email, String firstname, String lastname, List<dynamic> tags) {
    this.email = email;
    this.firstname = firstname;
    this.lastname = lastname;
    this.tags = tags; //TODO: Add Tag function
  }

  static Profile empty() {
    return Profile("email", "firstname", "lastname", []);
  }

  String getFullName() {
    return firstname + " " + lastname;
  }

  //TODO need to implement
}
