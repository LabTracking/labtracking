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
      await for (final User? user in authChanges) {
        _currentResearcher = user == null ? null : toResearcher(user);
        controller.add(_currentResearcher);
        if (_currentResearcher == null) {
          print("DESLOGADO");
        } else {
          print("STREAM " + _currentResearcher!.email);
        }
      }
    },
  );

  Researcher? get currentResearcher {
    return _currentResearcher;
  }

  Stream<Researcher?> get researcherChanges {
    return _researcherStream;
  }

  static Future<Researcher?> login(
      FirebaseAuth auth, GoogleSignIn googleSignIn) async {
    try {
      GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) return null;

      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        print(user.displayName);
        return toResearcher(user); // Retorne o pesquisador
      }
    } catch (e) {
      print('Error during Google Sign-In: $e');
    }
    return null; // Retorna null se o login falhar
  }

  static Future<void> signup(
    User user,
    String institution,
    String address,
    String country,
  ) async {
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

  static Future<void> logout(
      FirebaseAuth auth, GoogleSignIn googleSignIn) async {
    await googleSignIn.signOut();
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
      id: id ?? user.uid, // Usar id fornecido ou o uid do usuário
      email:
          email ?? user.email!, // Usar o email fornecido ou o email do usuário
      name: name ??
          user.displayName!, // Usar o nome fornecido ou o nome do usuário
      institution: institution ?? '',
      address: address ?? '',
      country: country ?? '',
    );
  }

  static Future<bool> researcherExists(User? user) async {
    if (user == null) return false; // Adicione verificação para user nulo
    try {
      final docRef =
          FirebaseFirestore.instance.collection('researchers').doc(user.uid);

      final doc = await docRef.get();
      return doc.exists;
    } catch (e) {
      print('Error checking if researcher exists: $e');
      throw e;
    }
  }
}
