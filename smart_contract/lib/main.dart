import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_contract/provider/file_provider.dart';
import 'package:smart_contract/repository/file_repository.dart';
import 'package:smart_contract/view/file_view.dart';
void main() {

  final FileRepository repository = FileRepository();

  runApp(
    ChangeNotifierProvider(
    create: (context) => FileProvider(fileRepository: repository),
    child: MyApp(),
  ),);
}

class MyApp extends StatelessWidget {
  MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final fileProvider = Provider.of<FileProvider>(context);

    return
      MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
        body: FileView(),
      )
    );
  }
}




