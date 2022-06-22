class Profile {
  String email = "";
  String firstname = "";
  String lastname = "";
  List<dynamic> tags = [
    "Backend",
    "Coding",
    "User",
    "Hacker",
    "Junkie",
    "Gamer"
  ];

  Profile(String email, String firstname, String lastname, List<dynamic> tags) {
    this.email = email;
    this.firstname = firstname;
    this.lastname = lastname;
    //this.tags=tags; //TODO: Add Tag function
  }

  printData() {
    print(email);
    print(firstname);
    print(lastname);
    print(tags);
  }

  static Profile empty() {
    return Profile("email", "firstname", "lastname", []);
  }

  String getFullName() {
    return firstname + " " + lastname;
  }

  //TODO need to implement
}
