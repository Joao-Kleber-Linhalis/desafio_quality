import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:desafio_quality/components/task_form_component.dart';
import 'package:desafio_quality/constants.dart';
import 'package:desafio_quality/models/task.dart';
import 'package:desafio_quality/models/task_list.dart';
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

    Future<void> _addEventToCalendar() async {
      final event = Event(
        title: widget.task.taskText,
        startDate: widget.task.date ?? DateTime.now(),
        endDate: widget.task.date ?? DateTime.now(),
        location: widget.task.place,
      );
      await Add2Calendar.addEvent2Cal(event);
    }

    Future<void> _deleteProduct() async {
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

    _taskFormModal(BuildContext context) {
      showModalBottomSheet(
        backgroundColor: Pallete.backgroundColor,
        context: context,
        builder: (_) {
          return TaskFormComponent(
            task: widget.task,
          );
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: () async {
          await widget.task.toggleDone();
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
          child: Row(
            mainAxisSize: MainAxisSize.min, // ajusta o tamanho do Row
            children: [
              Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  color: Pallete.blue,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: IconButton(
                  color: Pallete.white,
                  iconSize: 18,
                  onPressed: () {
                    _taskFormModal(context);
                  },
                  icon: const Icon(Icons.edit),
                ),
              ),
              const SizedBox(width: 8),
              // Botão para adicionar ao calendário
              Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  color: Pallete.green,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: IconButton(
                  color: Pallete.white,
                  iconSize: 18,
                  onPressed: () async {
                    await _addEventToCalendar();
                  },
                  icon: const Icon(Icons.calendar_month_rounded),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  color: Pallete.red,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: IconButton(
                  color: Pallete.white,
                  iconSize: 18,
                  onPressed: () async {
                    await _deleteProduct();
                  },
                  icon: const Icon(Icons.delete),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
