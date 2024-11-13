import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart' hide Job;
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/firestore_repo.dart';
import '../data/job.dart';
import '../routing/app_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Jobs'), actions: [
        IconButton(
          icon: const Icon(Icons.person),
          onPressed: () => context.goNamed(AppRoute.profile.name),
        )
      ]),
      body: const JobsListView(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          final user = ref.read(firebaseAuthProvider).currentUser;
          final faker = Faker();
          final title = faker.job.title();
          final company = faker.company.name();
          ref
              .read(firestoreRepoProvider)
              .addJob(uid: user!.uid, title: title, company: company);
        },
      ),
    );
  }
}

class JobsListView extends ConsumerWidget {
  const JobsListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firestoreRepo = ref.watch(firestoreRepoProvider);
    final user = ref.watch(firebaseAuthProvider).currentUser;
    return FirestoreListView<Job>(
      query: firestoreRepo.jobsQuery(uid: user!.uid),
      errorBuilder: (context, error, stackTrace) =>
          Center(child: Text('$error')),
      itemBuilder: (BuildContext context, QueryDocumentSnapshot<Job> doc) {
        final job = doc.data();
        return Dismissible(
          key: Key(doc.id),
          background: const ColoredBox(color: Colors.red),
          onDismissed: (_) =>
              firestoreRepo.deleteJob(uid: user.uid, jobId: doc.id),
          child: ListTile(
            title: Text(job.title),
            subtitle: Text(job.company),
            onTap: () {
              final faker = Faker();
              final title = faker.job.title();
              final company = faker.company.name();
              final user = ref.read(firebaseAuthProvider).currentUser;
              firestoreRepo.updateJob(
                jobId: doc.id,
                uid: user!.uid,
                title: title,
                company: company,
              );
            },
          ),
        );
      },
    );
  }
}
