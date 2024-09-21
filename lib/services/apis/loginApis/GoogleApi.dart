
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoogleApi {
  static final GoogleApi _instance=GoogleApi._();

  GoogleApi._();

  factory GoogleApi(){
    return _instance;
  }

  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    if (googleAuth == null) return null;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential).then((userCredential) {
      print(userCredential.user);
      print(userCredential.additionalUserInfo);
      print(userCredential.credential);
      return userCredential.user;
    });
  }
}
