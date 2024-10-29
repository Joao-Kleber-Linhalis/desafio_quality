import 'package:desafio_quality/models/base/base_model.dart';
import 'package:desafio_quality/models/task_list.dart';
import 'package:desafio_quality/service/firebase_service.dart';
import 'package:desafio_quality/shared/collections_name.dart';
import 'package:desafio_quality/shared/tools.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class Task extends BaseModel<Task> with ChangeNotifier {
  final String? id;
  final String taskText;
  final DateTime? date;
  final String? place;
  final String userId;
  bool isDone;

  Task({
    this.id,
    required this.taskText,
    required this.userId,
    this.date,
    this.place = "",
    this.isDone = false,
  });

  factory Task.empty() {
    return Task(
      id: "",
      userId: '',
      date: null,
      place: "",
      isDone: false,
      taskText: "",
    );
  }

  Task copyWith({
    String? id,
    String? taskText,
    DateTime? date,
    String? place,
    String? userId,
    bool? isDone,
  }) {
    return Task(
      id: id ?? this.id,
      taskText: taskText ?? this.taskText,
      place: place ?? this.place,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      isDone: isDone ?? this.isDone,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "userId": userId,
      "taskText": taskText,
      "date": date != null ? Timestamp.fromDate(date!) : null,
      "place": place,
      "isDone": isDone,
    };
  }

  @override
  Task fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return Task.empty();
    }
    return Task(
      id: map["id"] ?? "",
      userId: map["userId"],
      date: map['date'] != null ? Tools.toDate(map['date']) : null,
      place: map["place"] ?? "",
      isDone: map["isDone"],
      taskText: map["taskText"],
    );
  }

  void _toggleDone() {
    isDone = !isDone;
    notifyListeners();
  }

  bool hasSubtitle() {
    if (date != null || (place != null && place!.trim().isNotEmpty)) {
      return true;
    }
    return false;
  }

  String subtitle() {
    String subtitle = "";
    if (date != null) {
      subtitle = Tools.formatDateToString(date!);
    }
    if (place != null && place!.trim().isNotEmpty) {
      if (subtitle.isNotEmpty) {
        subtitle += " - ";
      }
      subtitle += place!;
    }
    return subtitle;
  }

  Future<void> toggleDone() async {
    try {
      _toggleDone();
      await FirebaseService.update(
          collection: CollectionsName.taskCollection, id: id!, data: this);
    } catch (_) {
      _toggleDone();
    }
  }
}
