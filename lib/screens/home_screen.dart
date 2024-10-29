import 'package:desafio_quality/components/search_bar_component.dart';
import 'package:desafio_quality/components/task_form_component.dart';
import 'package:desafio_quality/components/task_list_component.dart';
import 'package:desafio_quality/constants.dart';
import 'package:desafio_quality/models/auth.dart';
import 'package:desafio_quality/models/task_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController textEditingController = TextEditingController();
  String statusFilter = "Todas";
  bool _isLoading = true;
  late Animation<double> _animation;
  late AnimationController _animationController;
  bool isMenuOpen = false;

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
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
  }

  _taskFormModal(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Pallete.backgroundColor,
      context: context,
      builder: (_) {
        return const TaskFormComponent();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Text(
            "Desafio Quality",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w400,
              color: Pallete.white,
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      _buildTaskStatus(status: 'Não Feitas'),
                      _buildTaskStatus(status: 'Completas'),
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: FloatingActionBubble(
          items: <Bubble>[
            Bubble(
              icon: Icons.add,
              iconColor: Pallete.white,
              title: "Adicionar",
              titleStyle: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              bubbleColor: Pallete.orange,
              onPress: () => _taskFormModal(context),
            ),
            Bubble(
              icon: Icons.exit_to_app,
              iconColor: Pallete.white,
              title: "Deslogar",
              titleStyle: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              bubbleColor: Pallete.orange,
              onPress: () async {
                await Provider.of<Auth>(context, listen: false).logout();
              },
            ),
          ],
          // animation controller
          animation: _animation,

          // Onpress abre o menu do bubble
          onPress: () {
            _animationController.isCompleted
                ? _animationController.reverse()
                : _animationController.forward();
            setState(() {
              isMenuOpen = !isMenuOpen;
            });
          },

          iconColor: Pallete.white,

          iconData: isMenuOpen ? Icons.close : Icons.menu,
          backGroundColor: Pallete.orange,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
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
