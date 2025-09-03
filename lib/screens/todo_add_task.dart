import 'package:flutter/material.dart';

class TodoAddTask extends StatefulWidget {
  final void Function({required String todoText}) addTodo;

  const TodoAddTask({super.key, required this.addTodo});

  @override
  State<TodoAddTask> createState() => _TodoAddTaskState();
}

class _TodoAddTaskState extends State<TodoAddTask> {
  var todoText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Add task'),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            controller: todoText,
            decoration: InputDecoration(hintText: 'Add Task'),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            widget.addTodo(todoText: todoText.text);
            todoText.clear();
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
