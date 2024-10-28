import 'package:desafio_quarkus/models/base/base_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    this.place,
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

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "userId" : userId,
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
      date: map["date"],
      place: map["place"] ?? "",
      isDone: map["isDone"],
      taskText: map["taskText"],
    );
  }

  void _toggleDone() {
    isDone = !isDone;
    notifyListeners();
  }

  Future<void> toggleDone() async {
    try {
      _toggleDone();

      //firebase update code
    } catch (_) {
      _toggleDone();
    }
  }
}
