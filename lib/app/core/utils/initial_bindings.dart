import 'package:crud_app/app/controllers/auth_controller.dart';
import 'package:crud_app/app/data/repositories/auth/auth_repository.dart';
import 'package:crud_app/app/data/repositories/note/note_repository.dart';
import 'package:crud_app/app/data/repositories_impl/auth/auth_repository_impl.dart';
import 'package:crud_app/app/data/repositories_impl/note/note_repository_imp.dart';
import 'package:crud_app/app/modules/home/controllers/home_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import 'dio_utils.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() async {
    Get.put<Dio>(
      DioUtils.initDio(
        dotenv.env['BASE_URL'] ?? const String.fromEnvironment('BASE_URL'),
      ),
      permanent: true,
    );

    Get.put<FlutterSecureStorage>(
      const FlutterSecureStorage(
        aOptions: AndroidOptions(
          encryptedSharedPreferences: true,
        ),
        iOptions: IOSOptions(
          accessibility: KeychainAccessibility.first_unlock,
        ),
      ),
    );

    Get.put<AuthRepository>(
      AuthRepositoryImpl(
        client: Get.find<Dio>(),
        storage: Get.find<FlutterSecureStorage>(),
      ),
    );
    Get.put<NoteRepository>(
      NoteRepositoryImpl(
        client: Get.find<Dio>(),
        storage: Get.find<FlutterSecureStorage>(),
      ),
    );

    // Inisialisasi controller global (injection wajib diletakkan diakhir)
    Get.put(AuthController(), permanent: true);
    Get.put(HomeController(), permanent: true);
  }
}
