import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show
        FilteringTextInputFormatter,
        LengthLimitingTextInputFormatter,
        TextInputFormatter;
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:webconnect/search_contact_view.dart';
import 'package:webconnect/snack.dart';
import 'package:webconnect/theme_color.dart';

class InfomationContact extends StatefulWidget {
  final Function(String, String) onValueChanged;
  const InfomationContact({super.key, required this.onValueChanged});

  @override
  State<InfomationContact> createState() => _InfomationContactState();
}

class _InfomationContactState extends State<InfomationContact> {
  ThemeColor _themeColor = ThemeColor();
  List<Map<String, String>> contactList = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  Future<void> getContacts() async {
    contactList.clear();

    if (await FlutterContacts.requestPermission()) {
      List<Contact> contacts = await FlutterContacts.getContacts(
        withProperties: true,
      );

      for (var contact in contacts) {
        contactList.add({
          'name': contact.displayName,
          'number':
              contact.phones.isNotEmpty ? contact.phones.first.number : '없음',
        });
      }

      setState(() {
        if (contactList.isNotEmpty) {
          contact(contactList);
        }
      });
    } else {
      print("연락처 접근 권한이 거부됨");
    }
  }

  contact(list) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchContactView(contacts: list),
        fullscreenDialog: true,
      ),
    );

    if (result != null) {
      final Map<String, dynamic> data = result;
      print('Returned result: $data');

      nameController.clear();
      numberController.clear();

      Snack().showTopSnackBar(context, '연락처 정보를 가져 왔습니다.');

      setState(() {
        nameController.text = data['name'];
        numberController.text = data['number'];
      });

      updateInfo();
    }
  }

  void updateInfo() {
    widget.onValueChanged(nameController.text, numberController.text);
  }

  //대쉬를 포함하는 010 휴대폰 번호 포맷 검증 (010-1234-5678)
  bool isValidPhoneNumberFormat(String number) {
    return RegExp(r'^010-?([0-9]{4})-?([0-9]{4})$').hasMatch(number);
  }

  @override
  void dispose() {
    nameController.dispose();
    numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: Column(
        children: [
          TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: _themeColor.themeColor,
              minimumSize: Size(MediaQuery.of(context).size.width, 35),
            ),
            onPressed: getContacts,
            child: Text(
              '주소록에서 가져오기',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Color.fromRGBO(240, 240, 240, 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 30,
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Row(
                    children: [
                      Text('성명', style: TextStyle(fontSize: 16)),
                      Expanded(child: Container()),
                      Container(
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black, width: 0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.fromLTRB(8, 0, 0, 8),
                        child: TextField(
                          controller: nameController,
                          decoration: InputDecoration(border: InputBorder.none),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  height: 30,
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Row(
                    children: [
                      Text('전화번호', style: TextStyle(fontSize: 16)),
                      Expanded(child: Container()),
                      Container(
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black, width: 0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.fromLTRB(8, 0, 0, 8),
                        child: TextField(
                          controller: numberController,
                          inputFormatters: [
                            FilteringTextInputFormatter
                                .digitsOnly, // only numbers
                            NumberFormatter(), // auto append hypen when input text
                            LengthLimitingTextInputFormatter(20), //max 13
                          ],
                          maxLines: 1,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(border: InputBorder.none),
                          onChanged: (value) {
                            updateInfo();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 35,
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '* 성명, 전화번호는 필수 정보입니다.',
                    style: TextStyle(color: Colors.black.withAlpha(150)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex <= 3) {
        if (nonZeroIndex % 3 == 0 && nonZeroIndex != text.length) {
          buffer.write('-'); // Add double spaces.
        }
      } else {
        if (nonZeroIndex % 7 == 0 &&
            nonZeroIndex != text.length &&
            nonZeroIndex > 4) {
          buffer.write('-');
        }
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}
