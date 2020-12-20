import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wardrobe/data/AuditEntry.dart';
import 'package:wardrobe/data/Category.dart';
import 'package:wardrobe/data/GarmentSQL.dart';
import 'package:wardrobe/data/QueryHelper.dart';
import 'package:wardrobe/utils/consts.dart';
import 'utils/UpperCaseTextFormatter.dart';
import 'utils/consts.dart';


class AddGarment extends StatefulWidget {
  var defaultGarmentCategory;
  AddGarment({this.defaultGarmentCategory});
  @override
  _AddGarmentState createState() => new _AddGarmentState(this.defaultGarmentCategory);
}

class _AddGarmentState extends State<AddGarment> {
  static String lastAddedSex = "";
  _AddGarmentState(defaultGarmentCategory) {
    selectedGarmentCategory = defaultGarmentCategory;
  }
  final numberOfGarmentsController = new TextEditingController();
  final sizeOfGarmentsController = new TextEditingController();

  int numberOfGarments = 0;
  String sizeOfGarments = "";
  var selectedGarmentCategory = garmentCategories[0];
  var selectedSex = lastAddedSex.isNotEmpty ? lastAddedSex : garmentSex[0];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(
        title: new Text("Register one or more garments to Wardrobe"),
    ),
    body: new Center(
    child: new Container(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: new Column(children: [
    new FutureBuilder(
    future: ClothesDB.get().getCategories(),
    builder: (context, snapshot) {
      if (snapshot.hasData && snapshot.data.isNotEmpty) {
        return new Container(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: new DropdownButton<String>(
              value: selectedGarmentCategory,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String newValue) {
                setState(() {
                  selectedGarmentCategory = newValue;
                });
              },
              items: snapshot.data
                  .map<DropdownMenuItem<String>>((Category value) {
                return DropdownMenuItem<String>(
                  value: value.name,
                  child: Text(value.name),
                );
              }).toList(),
            ));
      }
      return CircularProgressIndicator();
    }),
      new Container(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: new DropdownButton<String>(
            value: selectedSex,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String newValue) {
              setState(() {
                selectedSex = newValue;
              });
            },
            items: garmentSex
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          )),
      new Container(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: new TextField(
          inputFormatters: [UpperCaseTextFormatter()],
          controller: sizeOfGarmentsController,
          onChanged: (text) {
            sizeOfGarments = text.toUpperCase();
          },
          keyboardType: TextInputType.text,
          decoration: new InputDecoration(
              border: InputBorder.none,
              labelText: 'Size of garments to register?'), // "garments" should be automatic
        ),
      ),
      new Container(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: new TextField(
          controller: numberOfGarmentsController,
          onChanged: (text) {
            numberOfGarments = int.parse(text);
          },
          keyboardType: TextInputType.number,
          decoration: new InputDecoration(
              border: InputBorder.none,
              labelText: 'How many garments to register?'), // "garments" should be automatic
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
                      await _saveGarments();
                      Navigator.pop(context);

                      return showDialog(
                        context: context,
                        builder: (context) {
                          return new AlertDialog(
                            // Retrieve the text the user has typed in using our
                            // TextEditingController
                            content:
                            new Text("You added ${numberOfGarments} of size ${sizeOfGarments} of categery ${selectedGarmentCategory}"),
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
    ])
    )
    )
    );
  }


  Future _saveGarments() async {
    // var box = Hive.box("${selectedGarmentCategory}");
    // var currentGarment = box.get("${sizeOfGarments}_${selectedSex}");
    // var currentQuantity = currentGarment == null ? 0 : currentGarment.quantity;
    // box.put("${sizeOfGarments}_${selectedSex}", new Garment(
    //     sex: selectedSex,
    //     size: sizeOfGarments,
    //     quantity: currentQuantity + numberOfGarments,
    //     categeory: selectedGarmentCategory));
    var db = ClothesDB.get();


    await db.upsertGarment(new GarmentSQL(id: 42, category: selectedGarmentCategory, quantity: numberOfGarments, size: sizeOfGarments, sex: selectedSex));
    await db.insertAuditEntry(new AuditEntry("INSERT", "CLOTHES",
        values: "CATEGORY: ${selectedGarmentCategory}, QUANTITY: ${numberOfGarments}, SIZE: ${sizeOfGarments}, SEX: ${selectedSex}"));
    lastAddedSex = selectedSex;
    setState(() {

    });
  }
  
}