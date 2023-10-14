import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:labtracking/models/researcher.dart';

class AuthService {
  static Researcher? _currentResearcher;

  static final _researcherStream = Stream<Researcher?>.multi(
    (controller) async {
      final authChanges = FirebaseAuth.instance.authStateChanges();
      await for (final researcher in authChanges) {
        _currentResearcher =
            researcher == null ? null : toResearcher(researcher);
        controller.add(_currentResearcher);
        _currentResearcher == null
            ? "DESLOGADO"
            : print("STREAM " + _currentResearcher!.email);
      }
    },
  );

  @override
  Researcher? get currentResearcher {
    return _currentResearcher;
  }

  @override
  Stream<Researcher?> get researcherChanges {
    return _researcherStream;
  }

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

  static Future<void> signup(User user) async {
    final signup = await Firebase.initializeApp(
      name: 'userSignup',
      options: Firebase.app().options,
    );

    if (user != null) {
      _currentResearcher = toResearcher(user, user.uid, user.email);
      await saveResearcher(_currentResearcher!);
    }
  }

  static Future<void> logout(FirebaseAuth auth, GoogleSignIn googleUser) async {
    await googleUser.signOut();
    await auth.signOut();
    print("deslogado");
  }

  static Future<void> saveResearcher(Researcher researcher) async {
    final store = FirebaseFirestore.instance;
    final docRef = store.collection('researchers').doc(researcher.id);

    await docRef.set(
      {
        'id': researcher.id,
        'email': researcher.email,
      },
    );
  }

  static Researcher toResearcher(User user, [String? id, String? email]) {
    return Researcher(
      id: user.uid,
      email: user.email!,
    );
  }
}
