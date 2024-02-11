// Define the User model class:

class UserModel {
  final String name;
  final String email;
  final String uid;
  final String? photoUrl; // Allow photoUrl to be null

  const UserModel({
    required this.name,
    required this.email,
    required this.uid,
    this.photoUrl,
  });

  // Factory constructor for JSON deserialization:
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    name: json['name'],
    email: json['email'],
    uid: json['uid'],
    photoUrl: json['photoUrl'], // Handle null values correctly
  );

  // Method to convert the User object to a JSON map:
  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'uid': uid,
    'photoUrl': photoUrl, // Include photoUrl even if null
  };
}
