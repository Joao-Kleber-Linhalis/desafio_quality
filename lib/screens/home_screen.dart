import 'package:desafio_quarkus/components/search_bar_component.dart';
import 'package:desafio_quarkus/components/task_list_component.dart';
import 'package:desafio_quarkus/constants.dart';
import 'package:desafio_quarkus/models/task_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController textEditingController = TextEditingController();
  String statusFilter = "Todas";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<TaskList>(
      context,
      listen: false,
    ).loadTasks().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Desafio Quality",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w400,
            color: Pallete.white,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  SearchBarComponent(
                    onChanged: (value) {
                      setState(() {});
                    },
                    textEditingController: textEditingController,
                    borderRadius: 100,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Tarefas",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildTaskStatus(status: 'Todas'),
                      _buildTaskStatus(status: 'Completas'),
                      _buildTaskStatus(status: 'Não Feitas'),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: TaskListComponent(
                      status: statusFilter,
                      filter: textEditingController.text,
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Widget _buildTaskStatus({required String status}) {
    bool selected = status == statusFilter;
    return InkWell(
      onTap: () {
        setState(() {
          statusFilter = status;
        });
      },
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * 0.28,
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Pallete.statusFilter,
          border: selected ? Border.all(color: Pallete.orange, width: 2) : null,
        ),
        child: Text(
          status,
          style: TextStyle(
            color: selected ? Colors.white : Pallete.greyLight,
            fontSize: 18,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
