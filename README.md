
### 사용한 라이브러리
* webview_flutter: 웹뷰
* flutter_contacts: 연락처
* file_picker: 파일선택기
* path: 파일 이름 추출
* photo_manager: 이미지 목록
* photo_manager_image_provider: 이미지 목록


### 브릿지 통신 설명
웹 환경에서 채널명으로 브릿지 통신을 한다.

```
  if (window.FlutterChannel) {
        /*
         const exampleData = {
            code: codeText, // 일련번호
            title: titleText, // 제목
            imgCount: imgCount, //최대 선택 이미지 갯수
            fileCount: fileCount, // 최대 선택 파일 갯수
            byte: byte // 첨부 파일 최대 용량(MB)
        };
        */
        const data = {
            code: codeText, // 일련번호
            title: titleText, // 제목
            imgCount: imgCount, //최대 선택 이미지 갯수
            fileCount: fileCount, // 최대 선택 파일 갯수
            byte: byte // 첨부 파일 최대 용량(MB)
        };

         window.FlutterChannel.postMessage(JSON.stringify(data));
    } else {
        console.log("FlutterChannel is not available.");
    }
```


### 소스 설명
* alert.dart : 각종 알림 팝업 모음
* apply_view.dart.dart : 심사 요청 화면. base
* attach_image_files_widget.dart : 이미지, 파일 첨부 위젯
* check_view.dart : 요청 시 데이터 확인용. 테스트 화면
* file_exclustion_selector.dart : 파일 선택 후 첨부파일 갯수 초과시 선택 화면
* image_picker.dart : 이미지 선택화면
* info.dart : 웹에서 넘어온 일련번호, 타이틀 표시 위젯, 화면 상단 부분
* infomation_contact.dart : 연락처 입력 및 가져온 연락처 데이터 노출 위젯
* privacy_view.dart : 약관 보기. 웹뷰
* search_contact_view.dart : 연락처 검색 위젯
* snack.dart : 스낵 메시지 위젯
* theme_color.dart : 사용되는 색상상 정의


