import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirestoreRepo {
  final FirebaseFirestore _firestore;

  FirestoreRepo(this._firestore);

  Future<void> addJob({
    required String uid,
    required String title,
    required String company,
  }) async {
    final jobDoc = await _firestore.collection('jobs').add({
      'uid': uid,
      'title': title,
      'company': company,
    });
    debugPrint(jobDoc.id);
  }

  Query<Map<String, dynamic>> get jobsQuery => _firestore.collection('jobs');
}

final firestoreRepoProvider =
    Provider<FirestoreRepo>((ref) => FirestoreRepo(FirebaseFirestore.instance));
