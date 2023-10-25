import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:smart_contract/view/result_view.dart';
import '../provider/file_provider.dart';
import '../repository/file_repository.dart';

class AnalysisView extends StatefulWidget {
  FileRepository fileRepository = FileRepository();
  @override
  State<AnalysisView> createState() => _AnalysisViewState();
}

class _AnalysisViewState extends State<AnalysisView> {
  @override
  Widget build(BuildContext context) {
    final fileProvider = Provider.of<FileProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loading Page'),
        backgroundColor: Colors.grey[800],

      ),
      body: Container(
          color: Colors.white10,
          child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // 세로 축을 기준으로 중앙 정렬합니다.

                children: <Widget>[

              Container(
                  child: Center(
                    child: FutureBuilder<void>(
                      future: fileProvider.test(),
                      builder:
                          (BuildContext context, AsyncSnapshot<void> snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              if (snapshot.hasError) {
                                // 에러가 있을 경우 에러 메시지만 출력.
                                return Text('Error: ${snapshot.error}');
                              }

                              // Future가 성공적으로 완료되었을 때 실행되는 코드.
                              // 분석 완료되었으므로 "분석 보기" 버튼을 표시합니다.
                              return SizedBox(
                                  width: 200, // 버튼의 너비
                                  height: 80,
                                  child: ElevatedButton(
                                onPressed: () {
                                  // 버튼이 눌리면, ChartView 화면으로 이동합니다.
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ResultView()),
                                  );

                                },style: ElevatedButton.styleFrom(
                                    primary: Colors.grey[800], // 버튼의 배경색
                                    onPrimary: Colors.amberAccent, // 버튼의 foreground 색상 (텍스트, 아이콘의 색상)
                                    // 추가적으로, 버튼의 다른 스타일 속성들도 여기에서 설정할 수 있습니다.
                                  ),
                                child: const Text('분석 보기',
                                  style: TextStyle(
                                    // 여기서 텍스트 색상을 변경합니다.
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20, // 예를 들어, 폰트 크기
                                  ),), // 버튼에 표시될 텍스트
                              ),);
                            }

                            else if(snapshot.connectionState == ConnectionState.waiting){
                              // Future가 아직 완료되지 않았을 때 실행되는 코드
                              return  Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    AnimatedTextKit(
                                      animatedTexts: [
                                        TypewriterAnimatedText(
                                          '분석중', // 애니메이션 텍스트 내용
                                          textStyle: const TextStyle(
                                            fontSize: 25.0, // 텍스트 크기
                                            fontWeight: FontWeight.bold,
                                          ),
                                          speed: const Duration(milliseconds: 200), // 타이핑 속도 설정
                                        ),
                                      ],
                                      totalRepeatCount: 4, // 애니메이션 반복 횟수 설정, 무한 반복을 원한다면 'repeatForever' 사용
                                      pause: const Duration(milliseconds: 1000), // 애니메이션 사이의 대기 시간 설정
                                      displayFullTextOnTap: true, // 탭 할 때 전체 텍스트 표시 여부
                                      stopPauseOnTap: true, // 탭하여 애니메이션 일시 정지 여부
                                    ),
                                    SizedBox(height: 20), // 텍스트와 스피너 사이의 간격
                                    const SpinKitThreeBounce(
                                      color: Colors.amberAccent,
                                      size: 70.0,
                                    ),
                                  ]
                              );
                            }
                            else{
                              return Text("");
                            }
                          },
                    ),
                  )
              )
            ],
          )
          )
      ),
    );
  }
}
