class User {
  final int id;
  final String firstName;
  final String lastName;
  final String username;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      username: json['username'],
    );
  }
}
