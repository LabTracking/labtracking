import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static login(FirebaseAuth auth, GoogleSignIn googleSignIn) async {
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) return null;

    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential? userCredential =
        await auth.signInWithCredential(credential);

    User? user = userCredential.user;
    print(user!.email);
  }

  static Future<void> logout(FirebaseAuth auth, GoogleSignIn googleUser) async {
    await googleUser.signOut();
    await auth.signOut();
    print("deslogado");
  }
}
