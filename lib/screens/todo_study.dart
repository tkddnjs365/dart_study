import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_flutter/screens/todo_add_task.dart';

class TodoStudy extends StatefulWidget {
  const TodoStudy({super.key});

  @override
  State<TodoStudy> createState() => _TodoStudyState();
}

class _TodoStudyState extends State<TodoStudy> {
  List<String> todoList = [];

  @override
  void initState() {
    super.initState();
    getLocalData(); // 앱 시작 시 저장된 데이터 불러오기
  }

  void addTodo({required String todoText}) {
    setState(() {
      todoList.insert(0, todoText);
    });
    writeLocalData();
    Navigator.pop(context); // Todo List 입력창 닫기
  }

  void writeLocalData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setStringList('todoList', todoList);
  }

  void getLocalData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<String>? localTodoList = prefs.getStringList('todoList');

    if (localTodoList != null) {
      setState(() {
        todoList = localTodoList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(child: Text('Drawer')),
      appBar: AppBar(
        title: Text('TODO Study'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: Container(
                      height: 250,
                      child: TodoAddTask(addTodo: addTodo),
                    ),
                  );
                },
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(todoList[index]),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          todoList.remove(todoList[index]);
                          writeLocalData();
                          Navigator.pop(context); // Todo List 입력창 닫기
                        });
                      },
                      child: Text('삭제!'),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
