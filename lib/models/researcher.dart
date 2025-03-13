class Researcher {
  final String? id;
  final String name;
  // final String firstName;
  // final String lastName;
  final String institution;
  //final String country;
  final String email;
  final String type;
  //String? orcid;

  Researcher({
    this.id,
    required this.name,
    // required this.firstName,
    // required this.lastName,
    required this.institution,
    //required this.country,
    required this.email,
    required this.type,
  });
  Map<String, dynamic> toMap() {
    print('Type in toMap(): $type'); // Debug print
    return {
      'id': id,
      'name': name,
      'email': email,
      'type': type,
      'institution': institution,
    };
  }
}
