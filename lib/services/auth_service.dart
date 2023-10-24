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
    print(user!.displayName);
  }

  static Future<void> signup(
    User user,
    String institution,
    String address,
    String country,
  ) async {
    // final signup = await Firebase.initializeApp(
    //   name: 'userSignup',
    //   options: Firebase.app().options,
    // );

    //final auth = FirebaseAuth.instanceFor(app: signup);

    _currentResearcher = toResearcher(
      user,
      user.uid,
      user.email,
      user.displayName,
      institution,
      address,
      country,
    );
    await saveResearcher(_currentResearcher!);
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
        'name': researcher.name,
        'institution': researcher.institution,
        'address': researcher.address,
        'country': researcher.country,
      },
    );
  }

  static Researcher toResearcher(
    User user, [
    String? id,
    String? email,
    String? name,
    String? institution,
    String? address,
    String? country,
  ]) {
    return Researcher(
      id: user.uid,
      email: user.email!,
      name: user.displayName!,
      institution: institution ?? '',
      address: address ?? '',
      country: country ?? '',
    );
  }

  static Future<bool> researcherExists(User? user) async {
    try {
      final docRef =
          FirebaseFirestore.instance.collection('researchers').doc(user!.uid);

      final doc = await docRef.get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }
}
