import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'job.dart';

class FirestoreRepo {
  final FirebaseFirestore _firestore;

  FirestoreRepo(this._firestore);

  Future<void> addJob({
    required String uid,
    required String title,
    required String company,
  }) async =>
      await _firestore.collection('users/$uid/jobs').add(
          Job(title: title, company: company)
              .toMap(FieldValue.serverTimestamp()));

  Future<void> updateJob({
    required String jobId,
    required String uid,
    required String title,
    required String company,
  }) async =>
      await _firestore.doc('users/$uid/jobs/$jobId').update(Job(
            title: title,
            company: company,
          ).toMap());

  Future<void> deleteJob({required String uid, required String jobId}) async =>
      await _firestore.doc('users/$uid/jobs/$jobId').delete();

  Query<Job> jobsQuery({required String uid}) {
    return _firestore.collection('users/$uid/jobs').withConverter(
          fromFirestore: (snapshot, options) => Job.fromMap(snapshot.data()!),
          toFirestore: (job, options) => job.toMap(),
        );
  }
}

final firestoreRepoProvider =
    Provider<FirestoreRepo>((ref) => FirestoreRepo(FirebaseFirestore.instance));
