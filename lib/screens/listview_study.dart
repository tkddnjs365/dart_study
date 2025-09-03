import 'package:flutter/material.dart';
import 'package:study_flutter/navigator_study.dart';
import 'package:study_flutter/screens/calculator.dart';
import 'package:study_flutter/screens/onboarding_study.dart';

class ItemList {
  final String name;
  final IconData icon;
  final String description;
  final Widget screen;

  const ItemList({
    required this.name,
    required this.icon,
    required this.description,
    required this.screen,
  });
}

// 데이터 관리 클래스
class ItemListRepository {
  static const List<ItemList> _itemLists = [
    ItemList(
      name: 'OnBoard',
      icon: Icons.bookmark_add_rounded,
      description: 'OnBoarding 화면으로 이동 하는 List View 입니다.',
      screen: OnboardingStudy(),
    ),
    ItemList(
      name: '계산기',
      icon: Icons.calculate,
      description: '계산기 화면으로 이동 하는 List View 입니다.',
      screen: CalculatorScreen(),
    ),
  ];

  // 리스트 반환
  static List<ItemList> get allItemListData => _itemLists;
}

/* List View Study Main 위젯 */
class ListviewStudy extends StatefulWidget {
  const ListviewStudy({super.key});

  @override
  State<ListviewStudy> createState() => _ListviewStudyState();
}

class _ListviewStudyState extends State<ListviewStudy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildListViewAppBar(), body: _buildListViewBody());
  }

  /* List View 의 AppBar 위젯 */
  PreferredSizeWidget _buildListViewAppBar() {
    return AppBar(
      title: const Text('ListView', style: TextStyle(color: Colors.grey)),
      backgroundColor: Colors.white,
      elevation: 0,
      foregroundColor: Colors.grey,
    );
  }

  /* List View 의 Body 위젯 */
  Widget _buildListViewBody() {
    final itemList = ItemListRepository.allItemListData;
    double width = MediaQuery.of(context).size.width * 0.6;

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: itemList.length,
      itemBuilder: (context, index) {
        final item = itemList[index];

        return GestureDetector(
          onTap: () => _showPopup(context, item),
          child: Card(
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Icon(itemList[index].icon, size: 50),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(
                        itemList[index].name,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),

                      SizedBox(
                        width: width,
                        child: Text(
                          itemList[index].description,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /* 팝업 다이얼로그 표시 */
  void _showPopup(BuildContext context, ItemList resData) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              children: [
                // 상단 컨텐츠 (확장 가능한 영역)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 아이콘
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Icon(
                            resData.icon,
                            size: 80,
                            color: Colors.blue.shade600,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // name
                        Text(
                          resData.name,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 15),

                        // Description
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              resData.description,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[800],
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 하단 고정 버튼들
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    border: Border(
                      // 경계 선 추가
                      top: BorderSide(color: Colors.grey.shade200, width: 1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // 이동 버튼
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            NavigatorStudy.slideReplaceTo(
                              context,
                              resData.screen,
                            );
                          },
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('이동'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Close 버튼
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close),
                          label: const Text('Close'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[700],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
