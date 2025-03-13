import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:labtracking/models/researcher.dart';

class AuthService {
  static Researcher? _currentResearcher;

  // static final _researcherStream =
  //     Stream<Researcher?>.multi((controller) async {
  //   final authChanges = FirebaseAuth.instance.authStateChanges();
  //   await for (final User? user in authChanges) {
  //     if (user == null) {
  //       _currentResearcher = null;
  //       controller.add(null);
  //       print("DESLOGADO");
  //     } else {
  //       try {
  //         // Fetch researcher data from Firestore
  //         final doc = await FirebaseFirestore.instance
  //             .collection('researchers')
  //             .doc(user.uid)
  //             .get();

  //         if (doc.exists) {
  //           final data = doc.data()!;
  //           // Pass optional arguments from Firestore
  //           _currentResearcher = toResearcher(
  //             user,
  //             id: data['id'] ?? user.uid,
  //             email: data['email'] ?? user.email!,
  //             name: data['name'] ?? user.displayName!,
  //             institution: data['institution'] ?? '',
  //             type: data['type'] ?? 'observer',
  //           );
  //           print("STREAM ${_currentResearcher!.email}");
  //         } else {
  //           _currentResearcher = null;
  //           print("Researcher document not found for ${user.uid}");
  //         }
  //       } catch (e) {
  //         print("Error fetching researcher data: $e");
  //         _currentResearcher = null;
  //       }
  //     }
  //     controller.add(_currentResearcher);
  //   }
  // });
  static final _researcherStream =
      Stream<Researcher?>.multi((controller) async {
    final authChanges = FirebaseAuth.instance.authStateChanges();
    await for (final User? user in authChanges) {
      if (user == null) {
        _currentResearcher = null;
        controller.add(null);
        print("DESLOGADO");
      } else {
        try {
          // Check if researcher exists by email
          final exists = await researcherExists(user);
          if (exists) {
            // Fetch researcher data using email
            final data = await getResearcher(user);
            if (data != null) {
              _currentResearcher = toResearcher(
                user,
                id: data['id'] ?? user.uid,
                email: data['email'] ?? user.email!,
                name: data['name'] ?? user.displayName!,
                institution: data['institution'] ?? '',
                type: data['type'] ?? 'observer',
              );
              print("STREAM ${_currentResearcher!.email}");
            } else {
              _currentResearcher = null;
              print("Researcher data not found for ${user.email}");
            }
          } else {
            _currentResearcher = null;
            print("Researcher not found for ${user.email}");
          }
        } catch (e) {
          print("Error in researcher stream: $e");
          _currentResearcher = null;
        }
      }
      controller.add(_currentResearcher);
    }
  });
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

  // static Future<void> signup(
  //   User user,
  //   String institution,
  //   String country,
  //   String type,
  // ) async {
  //   _currentResearcher = toResearcher(
  //     user,
  //     user.uid,
  //     user.email,
  //     user.displayName,
  //     institution,
  //     country,
  //     type,
  //   );
  //   await saveResearcher(_currentResearcher!);
  // }

  static Future<void> logout(
      FirebaseAuth auth, GoogleSignIn googleSignIn) async {
    await googleSignIn.signOut();
    await auth.signOut();
    print("deslogado");
  }

  // static Future<void> saveResearcher(Researcher researcher) async {
  //   final store = FirebaseFirestore.instance;
  //   final docRef = store.collection('researchers').doc(researcher.id);

  //   await docRef.set(
  //     {
  //       'id': researcher.id,
  //       'email': researcher.email,
  //       'name': researcher.name,
  //       'institution': researcher.institution,
  //       //'address': researcher.address,
  //       //'country': researcher.country,
  //       'type': researcher.type,
  //     },
  //   );
  // }

  static Future<void> saveResearcher2(Researcher researcher) async {
    try {
      // Cria uma referência para a coleção "researchers" no Firestore
      CollectionReference researchers =
          FirebaseFirestore.instance.collection('researchers');

      // Adiciona o Researcher no Firestore, mas sem o campo 'id'
      DocumentReference docRef = await researchers.add({
        'name': researcher.name,
        'email': researcher.email,
        'institution': researcher.institution,
        'type': researcher.type,
      });

      // Agora buscamos o documento pelo 'email' para pegar o 'id'
      QuerySnapshot snapshot = await researchers
          .where('email', isEqualTo: researcher.email) // Busca pelo email
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Se encontramos o documento, pegamos o ID
        String documentId = snapshot.docs.first.id;

        // Agora atualizamos o campo 'id' do documento com o ID gerado
        await docRef.update({'id': documentId});

        print('Researcher ID updated successfully: $documentId');
      } else {
        print('Researcher not found by email.');
      }
    } catch (e) {
      print('Error saving or updating researcher: $e');
    }
  }

  static Researcher toResearcher(
    User user, {
    String? id,
    String? email,
    String? name,
    String? institution,
    String? type,
  }) {
    return Researcher(
      id: id ?? user.uid,
      email: email ?? user.email!,
      name: name ?? user.displayName!,
      institution: institution ?? '',
      type: type ?? 'observer',
    );
  }

  static Future<bool> researcherExists(User? user) async {
    if (user == null || user.email == null) return false;

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('researchers')
          .where('email', isEqualTo: user.email!) // Query by email field
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking researcher: $e');
      throw e;
    }
  }

  static Future<Map<String, dynamic>?> getResearcher(User? user) async {
    if (user == null || user.email == null) return null;

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('researchers')
          .where('email', isEqualTo: user.email!)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) return null;
      return querySnapshot.docs.first.data(); // Return first matching doc
    } catch (e) {
      print('Error fetching researcher: $e');
      throw e;
    }
  }
}
