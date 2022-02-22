import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

class WritePreviewPage extends StatelessWidget {
  final Uint8List imgBytes;
  WritePreviewPage({
    Key key,
    @required this.imgBytes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController();
    onSubmit() {
      Navigator.pop(context, _controller.value.text.trim());
    }

    Future openDialog() => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("File name"),
            content: TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Enter file name",
              ),
              controller: _controller,
              onSubmitted: (_) {
                onSubmit();
              },
            ),
            actions: [
              TextButton(
                onPressed: () {
                  onSubmit();
                },
                child: Text("Save"),
              ),
            ],
          ),
        );

    Future storeSignature(BuildContext context) async {
      try {
        var fileName = await openDialog();
        if (fileName.length == 0) {
          return;
        }
        final directory = (await getExternalStorageDirectory()).path;
        print(directory);

        File imgFile = new File('$directory/$fileName.png');

        imgFile.writeAsBytes(imgBytes).then(
            (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    "Saved Successfully",
                  ),
                  duration: Duration(milliseconds: 500),
                  backgroundColor: Colors.green,
                )));
      } catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Failed to save',
          ),
          duration: Duration(milliseconds: 1000),
          backgroundColor: Colors.red,
        ));
      }
      Navigator.pop(context);
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: CloseButton(),
        title: Text('Save'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () => storeSignature(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: Image.memory(
          imgBytes,
        ),
      ),
    );
  }
}
