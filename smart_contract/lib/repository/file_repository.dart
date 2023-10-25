import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'package:smart_contract/model/data.dart';

class FileRepository {

    static const String url = 'http://localhost:8000/file/';

    static final FileRepository _singleton = FileRepository._internal(Client());

    final Client _client;

    factory FileRepository() {
      return _singleton;
    }

    FileRepository._internal(this._client);

    String _fileContent = "";

    Data data = Data();

    Future<Map<String, dynamic>> fileRead() async {
      Map<String, dynamic> fileData = {};

      try {
        FilePickerResult? result = await FilePicker.platform.pickFiles();
        if (result != null && result.files.isNotEmpty) {
          PlatformFile file = result.files.first;
          String fileName = file.name;
          String? fileExtension = file.extension;
          double fileSize = file.size / 1024; // KB 단위로 파일 크기 변환

          fileData = {
            'fileName': fileName,
            'fileExtension': fileExtension,
            'fileSizeKB': fileSize,
          };

          if (file.bytes != null) {
            Uint8List fileBytes = file.bytes!;
            _fileContent = String.fromCharCodes(fileBytes);
            // 이 부분에서 'data' 객체는 이전에 정의되어야 합니다.
            // 'data'가 현재 컨텍스트에 없으므로 이 부분을 적절히 수정해야 합니다.
            data.code = _fileContent; // 'data' 객체가 무엇인지 확인이 필요합니다.
          }
        }
      } on PlatformException catch (e) {
        // 파일 선택 중 발생한 플랫폼 예외 처리
        debugPrint("파일 선택 오류: $e");
        // 사용자에게 알림 표시 또는 다른 적절한 동작 수행
      } catch (e) {
        // 다른 예외 처리
        debugPrint("파일 읽기 오류: $e");
        rethrow; // 오류를 다시 던져 호출자가 처리할 수 있도록 합니다.
      }

      return fileData;
    }


    Future<Data> test() async{
      Uri uri = Uri.parse(url);

      if (_fileContent.isEmpty) {
        debugPrint("Error: _fileContent is empty.");
        throw Exception("파일을 선택하세요");
      }

      // http request
      Response response = await _client.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: json.encode(data.toJson()),

      );

      debugPrint(response.body);

      Map<String, dynamic> responseData = jsonDecode(utf8.decode(response.bodyBytes));

      Data result = Data.fromJson(responseData);


      return result;
    }

}