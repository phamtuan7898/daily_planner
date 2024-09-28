import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAccount {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential; // Trả về userCredential nếu đăng nhập thành công
    } catch (e) {
      print('Đăng nhập không thành công: $e');
      return null; // Trả về null nếu có lỗi
    }
  }

  Future<UserCredential?> register(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential; // Trả về userCredential nếu đăng ký thành công
    } catch (e) {
      print('Đăng ký không thành công: $e');
      return null; // Trả về null nếu có lỗi
    }
  }
}
