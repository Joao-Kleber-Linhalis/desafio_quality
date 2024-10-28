import 'package:desafio_quarkus/models/task.dart';
import 'package:desafio_quarkus/service/firebase_service.dart';
import 'package:desafio_quarkus/shared/collections_name.dart';
import 'package:flutter/material.dart';

class TaskList with ChangeNotifier {
  final String _userId;
  List<Task> _tasks = [];

  List<Task> get tasks => [..._tasks];

  List<Task> get doneTasks => _tasks.where((task) => task.isDone).toList();
  List<Task> get ntoDoneTasks => _tasks.where((task) => !task.isDone).toList();

  TaskList([
    this._userId = '',
    this._tasks = const [],
  ]);

  int get tasksCount {
    return _tasks.length;
  }

  Future<void> loadTasks() async {
    _tasks.clear();
    try {
      _tasks = [
        Task(id: "1", taskText: "teste", userId: '1'),
        Task(id: "2", taskText: "teste2", userId: '1'),
        Task(id: "3", taskText: "teste3", userId: '1'),
        Task(id: "4", taskText: "teste4", userId: '1'),
      ];
      _tasks = await FirebaseService.getListWithCondition(
        collection: CollectionsName.taskCollection,
        field: 'userId',
        isEqualTo: _userId,
        modelEmpty: Task.empty(),
      );
    } on Exception catch (e) {
      print(e);
    }
  }
}
