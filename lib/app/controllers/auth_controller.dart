import 'package:crud_app/app/core/const/keys.dart';
import 'package:crud_app/app/data/models/user_model.dart';
import 'package:crud_app/app/data/repositories/auth/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final _authRepository = Get.find<AuthRepository>();
  final _secureStorage = Get.find<FlutterSecureStorage>();

  User? userAccount;

  @override
  void onReady() async {
    await Future.delayed(
      // Durasi splashscreen minimal 2 detik

      const Duration(seconds: 2),
      () async {
        // step 1: Ambil token dari local storage
        final token = await _secureStorage.read(key: Keys.token);

        // step 2: Cek jika `token` tidak null, artinya user sudah login
        if (token != null) {
          // Ambil data User dari secure storage
          final tempUserId = await _secureStorage.read(key: Keys.id) ?? '';
          print("isi dari user id: $tempUserId");
          userAccount = User(
            userId: int.parse(tempUserId),
            // name: await _secureStorage.read(key: Keys.name) ?? '',
            email: await _secureStorage.read(key: Keys.email) ?? '',
            accessToken: await _secureStorage.read(key: Keys.token) ?? '',
          );

          Get.offAllNamed('/home');
        } else {
          // Kondisi ketika `token` null, artinya user belum login
          Get.offAllNamed('/login');
        }
      },
    );

    super.onReady();
  }

  /// Fungsi untuk menyimpan token dan user profile ke secure storage
  Future<void> _setStorage() async {
    try {
      if (userAccount != null) {
        await _secureStorage.write(
            key: Keys.id, value: userAccount!.userId.toString());
        // await _secureStorage.write(key: Keys.name, value: userAccount!.name);
        await _secureStorage.write(key: Keys.email, value: userAccount!.email);
        await _secureStorage.write(
            key: Keys.token, value: userAccount!.accessToken);
      }
    } catch (e) {
      print('Error saving data to secure storage: $e');
      rethrow;
    }
  }

  /// Fungsi untuk menghapus data User dari secure storage
  Future<void> _clearStorage() async {
    await _secureStorage.delete(key: Keys.id);
    await _secureStorage.delete(key: Keys.email);
    await _secureStorage.delete(key: Keys.token);

    // Logging to verify data is cleared
    print('User data cleared from storage.');
  }

  Future<Map<String, dynamic>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      // step 1: Login ke API
      print('Attempting to login with email: $email');
      userAccount = await _authRepository.login(
        email: email,
        password: password,
      );

      // Tambahkan log untuk memeriksa nilai userAccount
      print(
          'Login successful, received user account: ${userAccount.toString()}');

      // step 2: Hit API login dan simpan data User ke secure storage
      await _setStorage();
      Future.delayed(Duration(seconds: 3));
      return {
        'success': true,
        'message': 'Login with email success',
      };
    } on DioError catch (e) {
      String errorMessage = 'Login failed. Please try again.';
      if (e.response != null) {
        if (e.response?.data['message'] == '\nEmail not found') {
          errorMessage = 'Email tidak terdaftar';
        } else if (e.response?.data['message'] == 'Wrong password') {
          errorMessage = 'Password salah';
        }
      }
      print('Login failed: ${e.response?.data}');
      return {
        'success': false,
        'message': errorMessage,
      };
    } catch (e) {
      print('Login failed: $e');
      return {
        'success': false,
        'message': 'Login failed. Please try again. $e',
      };
    }
  }

  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      await _authRepository.register(
        fullName: fullName,
        email: email,
        password: password,
      );

      await _setStorage();

      return {
        'success': true,
        'message': 'Register new account success',
      };
    } catch (e) {
      print('Registration failed: $e');
      return {
        'success': false,
        'message': 'Register new account failed. Please try again.',
      };
    }
  }

  Future<Map<String, dynamic>> logout() async {
    try {
      // step 1: Hapus data User pada local storage
      await _clearStorage();
      await _secureStorage.deleteAll();
      // step 2: Return result
      return {
        'success': true,
        'message': 'Logout success',
      };
    } catch (e) {
      print('Logout failed: $e');
      return {
        'success': false,
        'message': 'Logout failed. Please try again. $e',
      };
    }
  }
}
