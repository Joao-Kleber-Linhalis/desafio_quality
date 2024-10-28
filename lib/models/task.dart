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


}
