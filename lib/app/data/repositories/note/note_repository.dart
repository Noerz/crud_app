import 'package:crud_app/app/data/models/note_model.dart';

abstract class NoteRepository {
  Future<List<Note>> getNotes();

  Future<Map<String, dynamic>> createNote({
    required String title,
    required String content,
  });

  Future<Map<String, dynamic>> updateNote({
    required int idNote,
    required String title,
    required String content,
  });

  Future<Map<String, dynamic>> deleteNote({
    required int idNote,
  });
}
