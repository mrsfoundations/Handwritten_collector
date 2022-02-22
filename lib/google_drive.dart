import 'dart:io';
import 'package:googleapis/drive/v3.dart' as gdrive;
import 'package:googleapis_auth/auth_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DriveService {
  var clientId = "Use Your Google ClientId";

  List<String> _scopes = [gdrive.DriveApi.driveScope];

  getHttpClient() async {
    return await clientViaUserConsent(ClientId(clientId), _scopes, prompt);
  }

  prompt(String url) {
    launch(url);
  }

  upload(file) async {
    try {
      var isDeleted = false;
      var client = await getHttpClient();
      var drive = gdrive.DriveApi(client);

      for (var item in file) {
        var res = await drive.files.create(
          gdrive.File(),
          uploadMedia: gdrive.Media(item.openRead(), item.lengthSync()),
        );
        var data = res.toJson();
        if (data.isNotEmpty) {
          isDeleted = true;
        } else {
          isDeleted = false;
        }
      }

      if (isDeleted) {
        final directory = await getExternalStorageDirectory();
        final myDir = Directory(directory.path);
        myDir.delete(recursive: true);
      }
    } catch (error) {
      print(error);
    }
  }
}
