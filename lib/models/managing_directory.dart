import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class Directory {
  void createFolder() async {
    if (await Permission.storage.request().isGranted) {
      //String directory = (await getExternalStorageDirectory()).path;
      if (await io.Directory("/storage/emulated/0/Pardon Us").exists() !=
          true) {
        // print(directory);
        print("Directory not exist");
        new io.Directory("/storage/emulated/0/Pardon Us")
            .create(recursive: true);
      } else {
        print("Directory exist");
      }
    }
  }

  Future<bool> download(String link) async {
    try {
      if (await canLaunch(link)) {
        await launch(link);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<PlatformFile> pickFiles() async {
    PlatformFile _file;
    FilePickerResult _result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (_result != null) {
      _file = _result.files.first;
      return _file;
    } else {
      return _file;
    }
  }
}
