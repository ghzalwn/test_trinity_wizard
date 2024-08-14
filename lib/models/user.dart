import 'dart:convert';

class User {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? dob;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.dob,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        dob: json["dob"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "dob": dob,
      };
}

List<User> parseCustomers(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<User>((json) => User.fromJson(json)).toList();
}
