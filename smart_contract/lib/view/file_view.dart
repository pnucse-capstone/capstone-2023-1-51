import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/file_provider.dart';
import '../repository/file_repository.dart';
import 'analysis_view.dart';
import 'package:permission_handler/permission_handler.dart';

class FileView extends StatefulWidget {
  FileRepository fileRepository = FileRepository();
  FileView({super.key});

  @override
  State<FileView> createState() => _FileViewState();
}

class _FileViewState extends State<FileView> {


  @override
  Widget build(BuildContext context) {
    final fileProvider = Provider.of<FileProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('파일 선택'),
          backgroundColor: Colors.grey[800],
        ),
        body: Center(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 200, // 버튼의 너비
                height: 80,
                child: ElevatedButton(
                  onPressed: () async {
                    //await _requestStoragePermission();
                    await fileProvider.fileRead();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey[800], // 버튼의 배경색
                    onPrimary:
                        Colors.amberAccent, // 버튼의 foreground 색상 (텍스트, 아이콘의 색상)
                    // 추가적으로, 버튼의 다른 스타일 속성들도 여기에서 설정할 수 있습니다.
                  ),
                  child: const Text(
                    '파일 선택',
                    style: TextStyle(
                      // 여기서 텍스트 색상을 변경합니다.
                      fontWeight: FontWeight.bold,
                      fontSize: 20, // 예를 들어, 폰트 크기
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 200, // 버튼의 너비
                height: 80,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AnalysisView()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey[800], // 버튼의 배경색
                    onPrimary:
                        Colors.amberAccent, // 버튼의 foreground 색상 (텍스트, 아이콘의 색상)
                    // 추가적으로, 버튼의 다른 스타일 속성들도 여기에서 설정할 수 있습니다.
                  ),
                  child: const Text(
                    '분석',
                    style: TextStyle(
                      // 여기서 텍스트 색상을 변경합니다.
                      fontWeight: FontWeight.bold,
                      fontSize: 20, // 예를 들어, 폰트 크기
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> _requestStoragePermission() async {
    // 저장소 권한 상태 확인
    var status = await Permission.storage.status;
    if (status.isDenied) {
      // 처음으로 권한을 요청하거나, 이전에 거부되었을 경우
      Map<Permission, PermissionStatus> statuses = await [Permission.storage].request();
      print(statuses[Permission.storage]);
    }

    if (status.isPermanentlyDenied) {
      // 사용자가 '다시 묻지 않음'을 선택하고 권한을 거부한 경우
      // 사용자를 앱 설정 페이지로 안내
      openAppSettings();
    }

    if (status.isGranted) {
      return;
    }
  }


}
