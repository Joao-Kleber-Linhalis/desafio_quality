class Task {
  final String? id;
  final String taskText;
  final DateTime? date;
  final String? place;
  final bool isDone;

  Task({
    this.id,
    required this.taskText,
    this.date,
    this.place,
    this.isDone = false,
  });

  static List<Task> taskList() {
    return [
      Task(id: "1", taskText: "teste"),
      Task(id: "2", taskText: "teste2"),
      Task(id: "3", taskText: "teste3"),
      Task(id: "4", taskText: "teste4"),
    ];
  }
}
