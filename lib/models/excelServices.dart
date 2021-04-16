import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';

class ExcelSheet {
  var excel;
  String classCode;
  String fileName;

  String createNewExcel(String classCode) {
    fileName = classCode + DateTime.now().toString();
    excel = Excel.createExcel();
    List<String> dataList = [
      "Name",
      "Email",
      "Date Time of joining and leaving",
      "Action"
    ];
    excel.insertRowIterables(
        '$fileName.xlsx', dataList, 0); //row counting starts from 0
    for (var table in excel.tables.keys) {
      print(table);
      print(excel.tables[table].maxCols);
      print(excel.tables[table].maxRows);
      for (var row in excel.tables[table].rows) {
        print("$row");
      }
    }
    excel.encode().then((onValue) {
      File(join("/storage/emulated/0/Pardon Us/$fileName.xlsx"))
        ..createSync(recursive: true)
        ..writeAsBytesSync(onValue);
    });

    return fileName;
  }

  insertRow({String name, List<String> dataList, int index}) {
    excel.insertRowIterables('$name.xlsx', dataList, index);
  }

  String saveFile(String name) {
    excel.encode().then((onValue) {
      File(join("/storage/emulated/0/Pardon Us/$name.xlsx"))
        ..createSync(recursive: true)
        ..writeAsBytesSync(onValue);
    });
    return "/storage/emulated/0/Pardon Us/$name.xlsx";
  }
}
