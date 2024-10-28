import 'package:desafio_quarkus/components/task_tile_component.dart';
import 'package:desafio_quarkus/constants.dart';
import 'package:desafio_quarkus/models/task.dart';
import 'package:desafio_quarkus/models/task_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskListComponent extends StatelessWidget {
  final String status;
  final String filter;

  const TaskListComponent(
      {super.key, required this.status, required this.filter});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskList>(context);
    final List<Task> listTask = provider.taskListWithFilter(
      status: status,
      filter: filter,
    );
    return listTask.isEmpty
        ? Column(
            children: [
              Image.asset(
                ImagesPath.noTasksImage,
                fit: BoxFit.contain,
              ),
              const Text(
                "Sem Tarefas\nTente cadastrar uma nova!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          )
        : ListView.builder(
            itemCount: listTask.length,
            itemBuilder: (context, index) => TaskTileComponent(
              task: listTask[index],
            ),
          );
  }
}
