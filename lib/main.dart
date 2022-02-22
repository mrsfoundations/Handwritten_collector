import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'google_drive.dart';
import 'verify_page.dart';
import 'write_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Handwritten_script';

  @override
  Widget build(BuildContext context) {
    pickAndUploadFile() async {
      final directory = await getExternalStorageDirectory();
      final myDir = Directory(directory.path);
      List<FileSystemEntity> _images;
      _images = myDir.listSync(recursive: true, followLinks: false);

      await DriveService().upload(_images);
    }

    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Write'),
                Tab(text: 'Verify'),
              ],
            ),
            title: Text('Handwritten_script'),
            actions: [
              IconButton(
                icon: Icon(Icons.upload_rounded),
                onPressed: () {
                  pickAndUploadFile();
                },
              )
            ],
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              WritePage(),
              VerifyPage(),
            ],
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      title: title,
      theme: ThemeData(
        primaryColor: Colors.red,
      ),
    );
  }
}
