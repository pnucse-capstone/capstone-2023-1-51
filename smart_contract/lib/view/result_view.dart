import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_contract/provider/file_provider.dart';
import 'package:smart_contract/view/pie_chart.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultView extends StatefulWidget {
  const ResultView({super.key});

  @override
  State<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  @override
  void initState() {
    super.initState();
    // widget 이 모두 렌더링된 이후에 data 를 받아옴

    // widget 이 렌더링되기 전에 data 를 받아오면
    // build 중 setState 가 호출될 가능성이 있기 때문에 반드시 widget build 가 완료되고 데이터를 받아와야 함
    Future.microtask(() {
      context.read<FileProvider>().getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final fileProvider = Provider.of<FileProvider>(context);
    double probability = fileProvider.data.probability!;
    Map<String, dynamic> fileData = fileProvider.fileData;

    String url1 = "https://scsfg.io/hackers/reentrancy/";
    String url2 = "https://github.com/ConsenSys/ethereum-developer-tools-list/blob/master/README_Korean.md";
    return Scaffold(
      appBar: AppBar(
        title: Text("분석 결과"),
        backgroundColor: Colors.grey[800],
      ),
      body:
        Container(
          color: Colors.white54,
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 50,
              ),
              Row(
                children: <Widget>[
                  const SizedBox(
                    width: 50,
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.black12,
                      height: 300, // 원하는 높이 설정
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center, // 중앙 정렬을 위한 설정
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.all(20), // 상단 패딩
                            child: Text(
                              '취약점 확률',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                          ),
                          Expanded(
                            // 확장하여 남은 공간을 모두 차지하도록 함
                            child: Container(
                              alignment:
                                  Alignment.center, // Container 내부의 중앙 정렬
                              child: Padding(
                                // Padding 위젯 추가
                                padding:
                                    EdgeInsets.only(bottom: 20), // 아래쪽 패딩 설정
                                child: CustomPaint(
                                  size: Size(250, 250), // 그래프의 크기
                                  painter: PieChart(
                                      percentage: probability,
                                      textScaleFactor: 0.8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.black12,
                      height: 300,
                      child: SingleChildScrollView(
                        // Column을 SingleChildScrollView로 감쌉니다.
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Text(
                                "Code Section",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                "${fileProvider.data.code}", // 여기에 파일 제공자의 데이터 코드를 표시합니다.
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: <Widget>[
                  const SizedBox(
                    width: 50,
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                        height: 220, // 원하는 높이 설정
                        child: Column(children: <Widget>[
                          Expanded(
                            child: Container(
                              color: Colors.black12,
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    const Text(
                                      "분석 결과 (확률, 취약점 종류)",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20, // 예를 들어, 폰트 크기
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "${fileProvider.data.result}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    const Text(
                                      "전체 코드에서 취약점 함수의 위치",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Begin line: ${fileProvider.data.startIndex}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      "End line: ${fileProvider.data.endIndex}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                        ])),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 220, // 원하는 높이 설정
                      color: Colors.black12,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(
                                height: 15,
                              ),
                              const Text(
                                "파일 정보",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                "\n\n${formatFileData(fileData)}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              )
                            ]),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.black12,
                      height: 220, // 원하는 높이 설정
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(
                              height: 15,
                            ),
                            const Text(
                              "참고자료\n",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            // 첫 번째 링크
                            InkWell(
                              child: Text(
                                "${url1}", // 표시할 첫 번째 URL 텍스트.
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              onTap: () => _launchURL(url1),
                            ),

                            SizedBox(height: 10),

                            InkWell(
                              child: Text(
                                "$url2", // 표시할 두 번째 URL 텍스트.
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              onTap: () => _launchURL(url2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                ],
              ),
            ],
          ),
        ),

    );
  }

  String formatFileData(Map<String, dynamic> fileData) {
    return fileData.entries
        .map((entry) => '${entry.key}: ${entry.value}')
        .join('\n\n');
  }
}

void _launchURL(String url) async =>
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
