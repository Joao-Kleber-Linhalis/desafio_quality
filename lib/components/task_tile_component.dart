import 'package:desafio_quarkus/constants.dart';
import 'package:desafio_quarkus/models/task.dart';
import 'package:desafio_quarkus/models/task_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskTileComponent extends StatefulWidget {
  final Task task;
  const TaskTileComponent({super.key, required this.task});

  @override
  State<TaskTileComponent> createState() => _TaskTileComponentState();
}

class _TaskTileComponentState extends State<TaskTileComponent> {
  @override
  Widget build(BuildContext context) {
    final msg = ScaffoldMessenger.of(context);
    void _deleteProduct() async {
      try {
        await Provider.of<TaskList>(context, listen: false)
            .deleteTask(widget.task);
      } catch (error) {
        msg.showSnackBar(SnackBar(
          content: Text(error.toString()),
          duration: const Duration(seconds: 10),
        ));
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: () {
          widget.task.toggleDone();
          setState(() {});
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: widget.task.isDone ? Pallete.green : Pallete.white,
            width: 1,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tileColor: Pallete.black,
        leading: Icon(
          widget.task.isDone
              ? Icons.check_box_sharp
              : Icons.check_box_outline_blank_sharp,
          color: widget.task.isDone ? Pallete.green : Pallete.white,
        ),
        title: Text(
          widget.task.taskText,
          style: TextStyle(
            fontSize: 16,
            color: widget.task.isDone ? Pallete.green : Pallete.white,
            decoration: widget.task.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: widget.task.hasSubtitle()
            ? Text(
                widget.task.subtitle(),
                style: TextStyle(
                  fontSize: 14,
                  color: widget.task.isDone ? Pallete.green : Pallete.white,
                  decoration:
                      widget.task.isDone ? TextDecoration.lineThrough : null,
                ),
              )
            : null,
        trailing: Container(
          padding: const EdgeInsets.all(0),
          margin: const EdgeInsets.symmetric(vertical: 12),
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            color: Pallete.red,
            borderRadius: BorderRadius.circular(5),
          ),
          child: IconButton(
            color: Pallete.white,
            iconSize: 18,
            onPressed: () {
              _deleteProduct();
            },
            icon: const Icon(
              Icons.delete,
            ),
          ),
        ),
      ),
    );
  }
}
