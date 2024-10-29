import 'package:desafio_quarkus/models/task.dart';
import 'package:desafio_quarkus/service/firebase_service.dart';
import 'package:desafio_quarkus/shared/collections_name.dart';
import 'package:desafio_quarkus/shared/tools.dart';
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

  List<Task> taskListWithFilter(
      {required String status, required String filter}) {
    List<Task> listTask;
    if (status == "Todas") {
      listTask = _tasks;
    } else if (status == "Completas") {
      listTask = _tasks.where((task) => task.isDone).toList();
    } else {
      listTask = _tasks.where((task) => task.isDone == false).toList();
    }
    if (filter.isNotEmpty) {
      listTask = listTask.where((task) {
        bool matchesText =
            task.taskText.toLowerCase().contains(filter.toLowerCase());
        bool matchesDate = false;
        if (task.date != null) {
          final formattedDate = Tools.formatDateToString(task.date!);
          matchesDate = formattedDate.contains(filter);
        }
        return matchesText || matchesDate;
      }).toList();
    }
    return listTask;
  }

  Future<void> loadTasks() async {
    _tasks.clear();
    try {
      _tasks = await FirebaseService.getListWithCondition<Task>(
        collection: CollectionsName.taskCollection,
        field: 'userId',
        isEqualTo: _userId,
        modelEmpty: Task.empty(),
      );
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> deleteTask(Task task) async {
    int index = _tasks.indexWhere((p) => p.id == task.id);

    if (index >= 0) {
      try {
        final task = _tasks[index];
        await FirebaseService.delete(
          collection: CollectionsName.taskCollection,
          id: task.id!,
        );
        _tasks.remove(task);
        notifyListeners();
      } on Exception catch (e) {
        print(e);
        _tasks.insert(index, task);
        notifyListeners();
      }
    }
  }

  Future<void> addTask(Task task) async {
    try {
      String id = await FirebaseService.insert(
        data: task,
        collection: CollectionsName.taskCollection,
      );
      final taskWithId = task.copyWith(id: id);
      await FirebaseService.update(
        collection: CollectionsName.taskCollection,
        id: taskWithId.id!,
        data: taskWithId,
      );
      await loadTasks();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
