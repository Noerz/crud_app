// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
    final int userId;
    final String email;
    final String accessToken;

    User({
        required this.userId,
        required this.email,
        required this.accessToken,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["userId"],
        email: json["email"],
        accessToken: json["accessToken"],
    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
        "email": email,
        "accessToken": accessToken,
    };

    @override
    String toString() {
        return 'User(userId: $userId, email: $email, accessToken: $accessToken)';
    }
}

