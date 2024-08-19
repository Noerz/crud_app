import 'package:crud_app/app/core/const/endpoints.dart';
import 'package:crud_app/app/core/const/keys.dart';
import 'package:crud_app/app/data/models/note_model.dart';
import 'package:crud_app/app/data/repositories/note/note_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NoteRepositoryImpl extends NoteRepository {
  final Dio client;
  final FlutterSecureStorage storage;

  NoteRepositoryImpl({
    required this.client,
    required this.storage,
  });

  @override
  Future<List<Note>> getNotes() async {
    try {
      final token = await storage.read(key: Keys.token);
      final response = await client.get(
        Endpoints.note,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        var notesData = response.data['data'];

        if (notesData is List) {
          return notesData.map((e) => Note.fromJson(e)).toList();
        } else {
          return [];
        }
      } else {
        throw Exception(response.data['message'] ?? 'Notes not found');
      }
    } on DioError catch (dioError) {
      if (dioError.response != null) {
        throw dioError.response?.data['message'] ?? 'Unknown server error';
      } else {
        throw Exception('Network error: ${dioError.message}');
      }
    } catch (e) {
      throw 'Failed to load notes: $e';
    }
  }

  @override
  Future<Map<String, dynamic>> createNote({
    required String title,
    required String content,
  }) async {
    try {
      final token = await storage.read(key: Keys.token);
      final response = await client.post(
        Endpoints.note,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: {
          'title': title,
          'content': content,
        },
      );

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': response.data['message'],
          'data': response.data['data'],
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Failed to create note',
        };
      }
    } on DioError catch (dioError) {
      if (dioError.response != null) {
        return {
          'success': false,
          'message':
              dioError.response?.data['message'] ?? 'Unknown server error',
        };
      } else {
        return {
          'success': false,
          'message': 'Network error: ${dioError.message}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Create note failed, please try again. $e',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> updateNote({
    required int idNote,
    required String title,
    required String content,
  }) async {
    try {
      final token = await storage.read(key: Keys.token);
      final response = await client.put(
        Endpoints.note,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: {
          'title': title,
          'content': content,
          'idNote':idNote,
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': response.data['message'],
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Update note failed, please try again. $e',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> deleteNote({required int idNote}) async {
    try {
      final token = await storage.read(key: Keys.token);
      final response = await client.delete(
        Endpoints.note,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: {'idNote': idNote},
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': response.data['message'],
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'],
        };
      }
    } on DioError catch (dioError) {
      if (dioError.response != null) {
        return {
          'success': false,
          'message':
              dioError.response?.data['message'] ?? 'Unknown server error',
        };
      } else {
        return {
          'success': false,
          'message': 'Network error: ${dioError.message}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Delete note failed, please try again. $e',
      };
    }
  }
}
