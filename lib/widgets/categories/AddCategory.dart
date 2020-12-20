import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:wardrobe/data/Garment.dart';
import 'package:wardrobe/data/GarmentSQL.dart';
import 'package:wardrobe/data/QueryHelper.dart';
import 'package:wardrobe/utils/consts.dart';
import '../../utils/UpperCaseTextFormatter.dart';
import '../../utils/consts.dart';

class AddCategory extends StatefulWidget {

  @override
  _AddCategoryState createState() =>
      new _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final categoryNameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Register a new Category to Wardrobe"),
        ),
        body: new Center(
            child: new Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: new Column(children: [
                  new Container(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: new TextField(
                      controller: categoryNameController,
                      // onChanged: (text) {
                      //   sizeOfGarments = text.toUpperCase();
                      // },
                      keyboardType: TextInputType.text,
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          labelText:
                              'New category name'), // "garments" should be automatic
                    ),
                  ),
                  new Container(
                      child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new Container(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: new RaisedButton(
                            onPressed: () async {
                              await _saveCategory();
                              Navigator.pop(context);

                              return showDialog(
                                context: context,
                                builder: (context) {
                                  return new AlertDialog(
                                    // Retrieve the text the user has typed in using our
                                    // TextEditingController
                                    content: new Text(
                                        "You added ${categoryNameController.text} category"),
                                  );
                                },
                              );
                            },
                            child: new Text('Save',
                                style: new TextStyle(color: Colors.white)),
                            color: Colors.green,
                          )),
                      new Container(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: new RaisedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: new Text('Cancel',
                                style: new TextStyle(color: Colors.white)),
                            color: Colors.red,
                          ))
                    ],
                  )),
                ]))));
  }

  Future _saveCategory() async {
    // var box = Hive.box("${selectedGarmentCategory}");
    // var currentGarment = box.get("${sizeOfGarments}_${selectedSex}");
    // var currentQuantity = currentGarment == null ? 0 : currentGarment.quantity;
    // box.put("${sizeOfGarments}_${selectedSex}", new Garment(
    //     sex: selectedSex,
    //     size: sizeOfGarments,
    //     quantity: currentQuantity + numberOfGarments,
    //     categeory: selectedGarmentCategory));
    var db = ClothesDB.get();
    await db.insertCategory(categoryNameController.text);
    setState(() {});
  }
}
