import 'package:flutter/cupertino.dart';
import 'package:smart_contract/repository/file_repository.dart';

import '../model/data.dart';

class FileProvider extends ChangeNotifier{

  final FileRepository fileRepository;

  FileProvider({required this.fileRepository});

  late Data data;

  late Map<String, dynamic> fileData;

  double probability = 0.0;
  // view 는 data 를 구독함
  // data 가 바뀌면 widget 이 다시 build 됨
  // List<TestModel> data = [];
  //
  //
  Future<void> getData() async {
    // server 에서 data 를 받아옴
    //List<TestModel> fetch = await testRepository.fetchData();

    // widget 이 구독 중인 data 에 server 에서 받아온 data 로 다시 넣어줌
    //data = fetch;
    probability = 70.7;

    // data 가 바뀌었음을 notify
    notifyListeners();

  }

  Future<void>test() async {
   data  = await fileRepository.test();
  }

  Future<void> fileRead() async {
    fileData = await fileRepository.fileRead();
  }
}