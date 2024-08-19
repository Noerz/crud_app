// To parse this JSON data, do
//
//     final note = noteFromJson(jsonString);

import 'dart:convert';

Note noteFromJson(String str) => Note.fromJson(json.decode(str));

String noteToJson(Note data) => json.encode(data.toJson());

class Note {
    final int idNote;
    final String title;
    final String content;
    final int userId;
    final DateTime createdAt;
    final DateTime updatedAt;

    Note({
        required this.idNote,
        required this.title,
        required this.content,
        required this.userId,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Note.fromJson(Map<String, dynamic> json) => Note(
        idNote: json["idNote"],
        title: json["title"],
        content: json["content"],
        userId: json["user_id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "idNote": idNote,
        "title": title,
        "content": content,
        "user_id": userId,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
    };
}
