import 'package:flutter/material.dart';
import 'package:webconnect/theme_color.dart';

class SearchContactView extends StatefulWidget {
  final List<Map<String, String>> contacts;
  const SearchContactView({super.key, required this.contacts});

  @override
  State<SearchContactView> createState() => _SearchContactViewState();
}

class _SearchContactViewState extends State<SearchContactView> {
  ThemeColor _themeColor = ThemeColor();

  // 검색어를 저장할 변수
  String searchQuery = '';

  // 검색된 결과를 저장할 리스트
  List<Map<String, String>> filteredContacts = [];

  @override
  void initState() {
    filteredContacts = widget.contacts;
    super.initState();
  }

  // 검색어에 맞게 연락처를 필터링하는 함수
  void filterContacts(String query) {
    final filtered =
        widget.contacts.where((contact) {
          final name = contact['name']?.toLowerCase() ?? '';
          final number = contact['number']?.toLowerCase() ?? '';
          final searchLower = query.toLowerCase();

          // 이름 또는 번호에 검색어가 포함되면 해당 연락처를 표시
          return name.contains(searchLower) || number.contains(searchLower);
        }).toList();

    setState(() {
      searchQuery = query;
      filteredContacts = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Column(
            children: [
              Container(
                height: 44,
                padding: EdgeInsets.fromLTRB(21, 0, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        padding: EdgeInsets.all(4),
                        child: Image.asset('assets/images/close.png'),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Container(
                          height: 44,
                          child: TextField(
                            onChanged: filterContacts,
                            decoration: InputDecoration(
                              hintText: '이름 또는 번호로 검색하세요.',
                              hintStyle: TextStyle(fontSize: 15),
                              prefixIcon: Icon(
                                Icons.search,
                                color: _themeColor.themeColor,
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                ), // 커서 밑줄 색상
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                ), // 비활성 상태에서 밑줄 색상
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: filteredContacts.length,
                            itemBuilder: (context, index) {
                              final contact = filteredContacts[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.pop(context, {
                                    'name': contact['name'],
                                    'number': contact['number'],
                                  });
                                },
                                child: Container(
                                  height: 60,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: ListTile(
                                          title: Text(
                                            contact['name'] ?? '',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                            ),
                                          ),
                                          subtitle: Text(
                                            contact['number'] ?? '',
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          16,
                                          0,
                                          16,
                                          0,
                                        ),
                                        child: Container(
                                          height: 0.1,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
