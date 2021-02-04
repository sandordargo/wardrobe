import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:wardrobe/data/AuditEntry.dart';
import 'package:wardrobe/data/Category.dart';
import 'package:wardrobe/data/Garment.dart';
import 'package:wardrobe/data/GarmentSQL.dart';
import 'package:wardrobe/data/QueryHelper.dart';
import 'package:wardrobe/utils/consts.dart';
import '../../utils/UpperCaseTextFormatter.dart';
import '../../utils/consts.dart';

class EditCategory extends StatefulWidget {
  Category category;
  EditCategory(this.category);

  @override
  _EditCategoryState createState() => new _EditCategoryState(this.category);
}

class _EditCategoryState extends State<EditCategory> {
  TextEditingController categoryNameController;

  Category category;
  _EditCategoryState(this.category) {
    categoryNameController = new TextEditingController(text: category.name);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Edit Category to Wardrobe"),
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
                              Future<bool> categoryAlreadyExist =
                                  ClothesDB.get().doesCategoryExist(
                                      categoryNameController.text);
                              categoryAlreadyExist.then((value) {
                                if (value) {
                                  return showDialog(
                                    context: context,
                                    builder: (context) {
                                      return new AlertDialog(
                                        // Retrieve the text the user has typed in using our
                                        // TextEditingController
                                        content: new Text(
                                            "${categoryNameController.text} already exists"),
                                      );
                                    },
                                  );
                                } else {
                                  String oldCategory = category.name;
                                  category.name = categoryNameController.text;
                                  _saveCategory(oldCategory);
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
                                }
                              });


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

  Future _saveCategory(String oldCategory) async {
    var db = ClothesDB.get();
    await db.insertAuditEntry(new AuditEntry("UPDATE", "CATEGORIES",
        values: "CATEGORY: $oldCategory -> ${categoryNameController.text}"));
    await db.updateCategory(category);
    setState(() {});
  }
}
