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

  void addTodo({required String todoText}) {
    if (todoList.contains(todoText)) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('중복된 항목입니다!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('확인'),
              ),
            ],
          );
        },
      );
      return;
    }
    setState(() {
      todoList.insert(0, todoText);
    });
    writeLocalData();
    Navigator.pop(context); // Todo List 입력창 닫기
  }

  // 로컬 데이터 저장
  void writeLocalData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setStringList('todoList', todoList);
  }

  // 앱 시작 시 로컬 데이터 불러오기
  void getLocalData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      todoList = (prefs.getStringList('todoList') ?? []).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getLocalData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('TODO Study'), centerTitle: true),
      body: (todoList.isEmpty)
          ? Center(child: Text('데이터 없음', style: TextStyle(fontSize: 20)))
          : ListView.builder(
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(todoList[index]),
                  direction: DismissDirection.startToEnd,
                  background: Container(
                    color: Colors.red,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      todoList.removeAt(index);
                      writeLocalData();
                    });
                  },
                  child: ListTile(
                    title: Text(todoList[index]),
                    onTap: () {
                      _buildShowModalBottomSheet();
                    },
                  ),
                );
              },
            ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  // Floatin Action 버튼
  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: SizedBox(
                height: 250,
                child: TodoAddTask(addTodo: addTodo),
              ),
            );
          },
        );
      },
      backgroundColor: Colors.black,
      child: Icon(Icons.add, color: Colors.white),
    );
  }

  // Show Modal Bottom Sheet 위젯
  Widget _buildShowModalBottomSheet() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            todoList.remove(todoList[0]);
            writeLocalData();
            Navigator.pop(context); // Todo List 입력창 닫기
          });
        },
        child: Text('삭제!'),
      ),
    );
  }
}
