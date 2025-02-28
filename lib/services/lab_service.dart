import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class LabService {
  static StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      _labsStreamSubscription;

  static Stream<List<Map<String, dynamic>>> labsStream(String userEmail) {
    final store = FirebaseFirestore.instance;

    final snapshots = store
        .collection('labs')
        .where('members', arrayContains: userEmail)
        .orderBy('labName', descending: true)
        .snapshots();

    print(snapshots);

    // Subscribe to the snapshots
    return Stream<List<Map<String, dynamic>>>.multi(
      (controller) {
        _labsStreamSubscription = snapshots.listen(
          (snapshot) {
            List<Map<String, dynamic>> lista = snapshot.docs.map(
              (doc) {
                final data = doc.data();
                data['id'] = doc.id; // Add document ID to data
                return data;
              },
            ).toList();
            controller.add(lista); // Add the list to the controller
            print(lista);
          },
          onError: (error) {
            controller.addError(error); // Handle any errors
          },
        );
      },
    );
  }

  static void stopLabsStream() {
    // Cancel the stream subscription if it exists
    if (_labsStreamSubscription != null) {
      _labsStreamSubscription!.cancel();
      _labsStreamSubscription = null; // Reset the subscription variable
    }
  }

  static Future<void> saveLab(
    String labName,
    List<String> labLeaders,
    String? createdBy,
    List<dynamic>? members,
  ) async {
    final store = FirebaseFirestore.instance;

    await store.collection('labs').add(
      {
        'labName': labName,
        'leaderName': labLeaders,
        'createdBy': createdBy,
        'members': members,
      },
    );
  }
}
