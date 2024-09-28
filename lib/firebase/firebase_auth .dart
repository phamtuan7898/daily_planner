import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> signInWithEmail(String email, String password) async {
  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    print('User signed in: ${userCredential.user}');
  } catch (e) {
    print('Error: $e');
  }
}
