import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HivedbStudy extends StatefulWidget {
  const HivedbStudy({super.key});

  @override
  State<HivedbStudy> createState() => _HivedbStudyState();
}

class _HivedbStudyState extends State<HivedbStudy> {
  // Hive 데이터베이스 박스 - 'hiveBox'라는 이름으로 저장소 생성
  final _mybox = Hive.box('hiveBox');

  // 화면에 표시할 데이터 리스트 (Map의 리스트 형태)
  List myData = [];

  var myText = TextEditingController(); // 항목 입력을 위한 텍스트 컨트롤러
  var myValue = TextEditingController(); // 값 입력을 위한 텍스트 컨트롤러

  @override
  void initState() {
    super.initState();
    getItem();
  }

  @override
  void dispose() {
    // 메모리 누수 방지를 위해 컨트롤러 해제
    myText.dispose();
    myValue.dispose();
    super.dispose();
  }

  // 데이터 추가
  Future<void> addItem(data) async {
    await _mybox.add(data);
    await getItem();
  }

  // 데이터 가져오기
  Future<void> getItem() async {
    final updatedData = _mybox.keys.map((e) {
      var res = _mybox.get(e);
      return {'key': e, 'title': res['title'], 'value': res['value']};
    }).toList();

    // 상태 업데이트 - 이걸 해야 화면이 새로고침됨
    setState(() {
      myData = updatedData;
    });
  }

  // 데이터 삭제
  Future<void> _deleteItem(int key) async {
    await _mybox.delete(key);
    await getItem();

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('항목이 삭제되었습니다')));
    }
  }

  // 데이터 수정
  Future<void> _updateItem(int key, String newTitle, String newValue) async {
    Map<String, String> updatedData = {'title': newTitle, 'value': newValue};

    await _mybox.put(key, updatedData); // put으로 수정
    await getItem();

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('항목이 수정되었습니다.')));
    }
  }

  // 저장 버튼 클릭 시 호출되는 함수
  void onSave() {
    if (myText.text.trim().isEmpty || myValue.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('모든 필드를 입력해주세요')));
      return;
    }

    Map<String, String> data = {'title': myText.text, 'value': myValue.text};

    addItem(data);
    myText.clear();
    myValue.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  // AppBar 빌더
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Hive DB Study'),
      centerTitle: true,
      actions: [
        // 새로고침 버튼 - 데이터를 다시 불러오기
        IconButton(icon: const Icon(Icons.refresh), onPressed: getItem),
      ],
    );
  }

  // 메인 화면 빌더
  Widget _buildBody() {
    return Column(
      children: [
        const SizedBox(height: 30),

        // 항목 입력 필드
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: TextField(
            decoration: const InputDecoration(
              hintText: '항목',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.5),
              ),
            ),
            controller: myText, // 컨트롤러 연결
          ),
        ),

        const SizedBox(height: 20),

        // 값 입력 필드
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: TextField(
            decoration: const InputDecoration(
              hintText: '값',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.5),
              ),
            ),
            controller: myValue, // 컨트롤러 연결
          ),
        ),

        const SizedBox(height: 20),

        // 저장 버튼
        ElevatedButton.icon(
          onPressed: onSave,
          icon: const Icon(Icons.save),
          label: const Text("Save"),
        ),

        const SizedBox(height: 20),

        // 데이터 리스트 뷰
        Expanded(child: _buildBodyListView()),
      ],
    );
  }

  // 리스트 뷰 빌더
  Widget _buildBodyListView() {
    return ListView.builder(
      itemCount: myData.length, // 데이터 개수
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: ListTile(
            // 수정 버튼 ( 왼쪽 )
            leading: IconButton(
              icon: const Icon(
                Icons.change_circle,
                color: Colors.blue,
                size: 30,
              ),
              // 수정 다이얼로그 호출 (현재 데이터를 매개변수로 전달)
              onPressed: () => _showUpdateDialog(
                myData[index]['key'],
                myData[index]['title'],
                myData[index]['value'],
              ),
            ),

            // 삭제 버튼 ( 오른쪽 )
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red, size: 30),
              onPressed: () => _deleteItem(myData[index]['key']),
            ),

            // 메인 텍스트 (제목)
            title: Text("${myData[index]['title']}"),
            // 서브 텍스트 (값)
            subtitle: Text("${myData[index]['value']}"),
          ),
        );
      },
    );
  }

  // 수정 다이얼로그
  Future<void> _showUpdateDialog(
    int key,
    String currentTitle,
    String currentValue,
  ) async {
    // 수정할 텍스트 컨트롤러 초기화 ( 현재 값으로 초기화 )
    var newTitleController = TextEditingController(text: currentTitle);
    var newValueController = TextEditingController(text: currentValue);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('항목 수정'),
          content: SizedBox(
            width: double.maxFinite, // 가로 최대 크기
            height: 120, // 높이 고정
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 항목 입력 필드
                TextField(
                  controller: newTitleController,
                  decoration: const InputDecoration(labelText: '수정 항목'),
                ),

                // 값 입력 필드
                TextField(
                  controller: newValueController,
                  decoration: const InputDecoration(labelText: '수정 값'),
                ),
              ],
            ),
          ),

          // 다이얼로그 하단 버튼
          actions: [
            // 취소 버튼
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기

                // 컨트롤러 메모리 해제
                newTitleController.dispose();
                newValueController.dispose();
              },
              child: const Text('취소'),
            ),

            // 저장 버튼
            ElevatedButton(
              onPressed: () {
                String newTitle = newTitleController.text.trim();
                String newValue = newValueController.text.trim();

                // 입력 검증
                if (newTitle.isNotEmpty && newValue.isNotEmpty) {
                  _updateItem(key, newTitle, newValue); // 수정 함수 호출
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                } else {
                  // 에러 메시지 표시
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('모든 필드를 입력해주세요')),
                  );
                }

                // 컨트롤러 메모리 해제
                newTitleController.dispose();
                newValueController.dispose();
              },
              child: const Text('저장'),
            ),
          ],
        );
      },
    );
  }
}
