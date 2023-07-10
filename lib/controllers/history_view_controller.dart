import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/writing_entry/writing_entry_model.dart';

class HistoryViewController {
  /// Singleton constructor
  static final HistoryViewController _instance =
      HistoryViewController._internal();

  factory HistoryViewController() => _instance;

  HistoryViewController._internal();

  /// Attributes
  final _db = FirebaseFirestore.instance;
  final _uid = FirebaseAuth.instance.currentUser!.uid;
  final _writingEntries = <WritingEntryModel>[];

  /// Methods
  Stream<QuerySnapshot<Map<String, dynamic>>> get historyStream => _db
      // .collection('users')
      // .doc(_uid)
      // .collection('notes')
      // .orderBy('timestamp', descending: true)
      // .snapshots();
      .collection('writing-temp')
      .doc(_uid)
      .collection('entries')
      .orderBy('timestamp', descending: true)
      .snapshots();

  /// Make historyStream from Stream<QuerySnapshot<Map<String, dynamic>>> to
  /// Stream<WritingModelEntry>
  Stream<List<WritingEntryModel>> get writingEntriesStream =>
      historyStream.map((event) {
        _writingEntries.clear();
        for (QueryDocumentSnapshot<Map<String, dynamic>> element
            in event.docs) {
          log(
            '${element.data()}',
            name: 'HistoryViewController:writingEntriesStream',
          );
          _writingEntries.add(WritingEntryModel.fromDocument(element.data()));
        }
        return _writingEntries;
      });
}
