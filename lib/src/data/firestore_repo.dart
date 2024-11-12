import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'job.dart';

class FirestoreRepo {
  final FirebaseFirestore _firestore;

  FirestoreRepo(this._firestore);

  Future<void> addJob({
    required String uid,
    required String title,
    required String company,
  }) async {
    final jobDoc = await _firestore
        .collection('jobs')
        .add(Job(uid: uid, title: title, company: company).toMap());
    debugPrint(jobDoc.id);
  }

  Query<Job> get jobsQuery => _firestore.collection('jobs').withConverter(
        fromFirestore: (snapshot, options) => Job.fromMap(snapshot.data()!),
        toFirestore: (job, options) => job.toMap(),
      );
}

final firestoreRepoProvider =
    Provider<FirestoreRepo>((ref) => FirestoreRepo(FirebaseFirestore.instance));
