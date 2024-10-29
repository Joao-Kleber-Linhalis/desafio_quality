import 'package:desafio_quality/components/task_tile_component.dart';
import 'package:desafio_quality/constants.dart';
import 'package:desafio_quality/models/task.dart';
import 'package:desafio_quality/models/task_list.dart';
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
              Text(
                "Sem tarefas ${status.toLowerCase()}",
                textAlign: TextAlign.center,
                style: const TextStyle(
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
