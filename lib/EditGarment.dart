import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wardrobe/data/GarmentSQL.dart';
import 'data/AuditEntry.dart';
import 'data/QueryHelper.dart';

class EditGarment extends StatefulWidget {
  GarmentSQL garment;
  EditGarment(this.garment);

  @override
  _EditGarmentState createState() =>
      new _EditGarmentState(garment: this.garment);
}

class _EditGarmentState extends State<EditGarment> {
  TextEditingController numberOfGarmentsController;

  GarmentSQL garment;

  _EditGarmentState({this.garment}) {
    numberOfGarmentsController =
        new TextEditingController(text: garment.quantity.toString());
  }

  void _saveGarments(GarmentSQL garment, int oldQuantity) {
    var db = ClothesDB.get();
    db.insertAuditEntry(new AuditEntry("UPDATE", "CLOTHES",
        values: "CATEGORY: ${garment.category}, QUANTITY: $oldQuantity -> ${garment.quantity}, "
            "SIZE: ${garment.size}, SEX: ${garment.sex}"));
    db.updateGarment(garment);
  }

  Widget makeNonChangeableWidget(String label, String value) {
    return new Container(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: new RichText(
        text: new TextSpan(
          style: new TextStyle(fontSize: 20.0, color: Colors.black),
          children: <TextSpan>[
            new TextSpan(text: '$label: '),
            new TextSpan(
                text: value, style: new TextStyle(fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Edit ${garment.category}, size ${garment.size}"),
        ),
        body: new Center(
            child: new Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: new Column(children: [
                  makeNonChangeableWidget('Category', garment.category),
                  makeNonChangeableWidget('Sex', garment.sex),
                  makeNonChangeableWidget('Size', garment.size),
                  new Container(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: new TextField(
                      controller: numberOfGarmentsController,
                      keyboardType: TextInputType.number,
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          labelText:
                              'How many garments to register?'), // "garments" should be automatic
                    ),
                  ),
                  new Container(
                      child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new Container(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: new RaisedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              int oldQuantity = garment.quantity;
                              garment.quantity =
                                  int.parse(numberOfGarmentsController.text);
                              _saveGarments(garment, oldQuantity);
                              return showDialog(
                                context: context,
                                builder: (context) {
                                  return new AlertDialog(
                                    content: new Text(
                                        "You added ${numberOfGarmentsController.text} of size ${garment.size} of categery ${garment.category}"),
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
}
