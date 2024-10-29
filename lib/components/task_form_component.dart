import 'package:desafio_quality/components/form_field_component.dart';
import 'package:desafio_quality/constants.dart';
import 'package:desafio_quality/models/auth.dart';
import 'package:desafio_quality/models/task.dart';
import 'package:desafio_quality/models/task_list.dart';
import 'package:desafio_quality/shared/tools.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskFormComponent extends StatefulWidget {
  const TaskFormComponent({super.key});

  @override
  State<TaskFormComponent> createState() => _TaskFormComponentState();
}

class _TaskFormComponentState extends State<TaskFormComponent> {
  //Controladores de texto gamers
  final _controlTaskText = TextEditingController();
  final _controlTaskPlace = TextEditingController();
  bool isLaoding = false;
  DateTime? _selectedDate;
  final style = const TextStyle(
    fontSize: 25,
    color: Pallete.white,
  );

  _submitform() async {
    setState(() {
      isLaoding = true;
    });
    final taskText = _controlTaskText.text;
    final taskPlace = _controlTaskPlace.text;

    if (taskText.isNotEmpty) {
      final task = Task(
          taskText: taskText,
          userId: Provider.of<Auth>(context, listen: false).userId!,
          date: _selectedDate,
          place: taskPlace);
      await Provider.of<TaskList>(context, listen: false).addTask(task);
      _controlTaskText.clear();
      _controlTaskPlace.clear();
      Navigator.of(context).pop();
    }
    setState(() {
      isLaoding = false;
    });
  }

  _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(), //Data Inicial marcada = hoje
      firstDate: DateTime.now(), //Primeira Data possivel hoje - 1 ano
      lastDate: DateTime.now()
          .add(const Duration(days: 365)), //Ultma Data possivel hoje + 1 ano
      locale: const Locale('pt', 'BR'),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Pallete.backgroundColor,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            //Formulário TaskText
            FormFieldComponent(
              "Tarefa",
              textoDica: "Escreva a Tarefa",
              controlador: _controlTaskText,
              style: style,
            ),
            const SizedBox(
              height: 10,
            ),

            //Formulário Place
            FormFieldComponent(
              "Local",
              textoDica: "Escreva o lugar aonde irá acontecer a tarefa",
              controlador: _controlTaskPlace,
              style: style,
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 70,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'Nenhuma data selecionada!'
                          : 'Data Selecionada: ${Tools.formatDateToString(_selectedDate!)}',
                      style: const TextStyle(color: Pallete.white),
                    ),
                  ),
                  TextButton(
                    onPressed: _showDatePicker,
                    style: TextButton.styleFrom(
                      foregroundColor: Pallete.orange,
                    ),
                    child: const Text(
                      'Selecionar Data',
                      style: TextStyle(
                        color: Pallete.orange,
                      ),
                    ),
                  )
                ],
              ),
            ),
            //Row pra mudar a posição dele
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Botão para adicionar nova transação
                ElevatedButton(
                  onPressed: isLaoding
                      ? null
                      : () async {
                          await _submitform();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Pallete.orange,
                    elevation: 5,
                  ),
                  child: isLaoding
                      ? const CircularProgressIndicator()
                      : const Text(
                          "Nova Tarefa",
                          style: TextStyle(
                            color: Pallete.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
