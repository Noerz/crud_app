import 'package:crud_app/app/controllers/auth_controller.dart';
import 'package:crud_app/app/data/models/note_model.dart';
import 'package:crud_app/app/data/repositories/note/note_repository.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final NoteRepository repository = Get.find<NoteRepository>();
  final _authController = Get.find<AuthController>();

  final RxList<Note> notes = <Note>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    
  }

  Future<void> fetchNotes() async {
    try {
      isLoading.value = true;
      final noteList = await repository.getNotes();
      notes.assignAll(noteList);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void addNote(String title, String content) async {
    try {
      isLoading.value = true;
      final result = await repository.createNote(
        title: title,
        content: content,
      );

      if (result['success']) {
        fetchNotes();
        Get.snackbar('Success', 'Note created successfully');
      } else {
        Get.snackbar('Error', result['message']);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void updateNote(int idNote, String title, String content) async {
    try {
      isLoading.value = true;
      final result = await repository.updateNote(
        idNote: idNote,
        title: title,
        content: content,
      );

      if (result['success']) {
        fetchNotes();
        Get.snackbar('Success', 'Note updated successfully');
      } else {
        Get.snackbar('Error', result['message']);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void deleteNote(int idNote) async {
    try {
      isLoading.value = true;
      final result = await repository.deleteNote(idNote: idNote);

      if (result['success']) {
        fetchNotes();
        Get.snackbar('Success', 'Note deleted successfully');
      } else {
        Get.snackbar('Error', result['message']);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>> logout() async {
    return await _authController.logout();
  }
}
