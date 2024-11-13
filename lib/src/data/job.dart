import 'package:cloud_firestore/cloud_firestore.dart'
    show FieldValue, Timestamp;
import 'package:equatable/equatable.dart';

/// Model class for documents in the jobs collection
class Job extends Equatable {
  const Job({required this.title, required this.company, this.createdDate});
  final String title;
  final String company;
  final DateTime? createdDate;

  factory Job.fromMap(Map<String, dynamic> map) {
    return Job(
      title: map['title'] as String,
      company: map['company'] as String,
      createdDate: map['createdDate'] != null
          ? (map['createdDate'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap([FieldValue? timestamp]) {
    return {
      'title': title,
      'company': company,
      if (timestamp != null && createdDate == null) 'createdDate': timestamp,
      if (createdDate != null) 'createdDate': Timestamp.fromDate(createdDate!),
    };
  }

  @override
  List<Object?> get props => [title, company, createdDate];
}
