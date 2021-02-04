import 'dart:io';

import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:path_provider/path_provider.dart';

import 'Category.dart';
import 'QueryHelper.dart';
import '../utils/consts.dart';


class DataExporter {

  void export() async {
    String csv = await getClothesAsCSV();
    saveFile(csv);
    sendEmail(csv);
  }

  void sendEmail(String csv) async {
    String body = """Hi there,
this email includes a generated csv with all the clothes, you uploaded into Wardrobe app.
Open it in as a spreadsheet in Excel or similar to be able to use it.
Cheers,
Sandor""";
    final Email email = Email(
      body: body,
      subject: 'Wardrobe data export',
      recipients: [],
      attachmentPaths: [await getFilePath()],
    );
    try {
      FlutterEmailSender.send(email);
    } catch (error) {
      print("Problem occurred while sending email: $error");
    }
  }

  Future<String> getClothesAsCSV() async {
    List<String> sizes = await ClothesDB.get().getSizes();
    String csvHeader = "category name,${sizes.join(',')}\n";
    String csv = csvHeader;

    List<Category> categories = await ClothesDB.get().getCategoriesWithClothes();
    for (var category in categories) {
      for (var sex in garmentSex) {
        var line = "${category.name}-$sex,";
        var lineHasClothes = false;
        for (var size in sizes) {
          int quantity = await ClothesDB.get()
              .getQuantityForCategoryAndSex(category.name, sex, size);
          if (quantity > 0) {
            lineHasClothes = true;
          }
          line += quantity.toString() + ',';
        }
        line = line.substring(0, line.length-1);
        line += '\n';
        if (lineHasClothes) {
          csv += line;
        }
      }
    }
    return csv;
  }

  Future<String> getFilePath() async {
    Directory appDocumentsDirectory = await getExternalStorageDirectory();
    String appDocumentsPath = appDocumentsDirectory.path;
    final DateTime now = DateTime.now();
    String date = "${now.year}-${now.month}-${now.day}";
    String filePath = '$appDocumentsPath/clothes_${date}.csv';
    return filePath;
  }

  void saveFile(String content) async {
    File file = File(await getFilePath());
    file.writeAsString(content);
  }
}