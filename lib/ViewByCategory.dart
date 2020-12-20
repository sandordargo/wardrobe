import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wardrobe/EditGarment.dart';
import 'package:wardrobe/data/Category.dart';

import 'package:wardrobe/data/GarmentSQL.dart';
import 'package:wardrobe/data/QueryHelper.dart';

import 'AddGarment.dart';
import 'data/AuditEntry.dart';
import 'utils/consts.dart';
import 'widgets/MainDrawer.dart';

class ViewByCategory extends StatefulWidget {
  @override
  _ViewByCategoryState createState() => new _ViewByCategoryState();
}

class _ViewByCategoryState extends State<ViewByCategory> {
  var selectedGarmentCategory = ""; // garmentCategories[0];

  void _addGarment() {
    Navigator.push(
      context,
      new MaterialPageRoute(
          builder: (context) =>
              new AddGarment(defaultGarmentCategory: selectedGarmentCategory)),
    ).then(onGoBack);
  }

  void _editGarment(GarmentSQL garment) {
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new EditGarment(garment)),
    ).then(onGoBack);
  }

  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  void _deleteSize(GarmentSQL garment) {
    setState(() {
      ClothesDB.get().insertAuditEntry(new AuditEntry("DELETE", "CLOTHES",
          values: "CATEGORY: ${garment.category}, QUANTITY: ${garment.quantity}, SIZE: ${garment.size}, SEX: ${garment.sex}"));
      ClothesDB.get().deleteGarment(garment);
    });
  }

  _confirmDelete(BuildContext context, GarmentSQL garment) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      color: Colors.blueGrey,
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      color: Colors.red,
      child: Text("DELETE"),
      onPressed: () {
        Navigator.of(context).pop();
        _deleteSize(garment);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Are you sure?"),
      content: Text(
          "You are about to delete ${garment.quantity} items of size ${garment.size}."),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget _makeCategorySelector(snapshotData) {

    return new Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Column(children: [
          new Container(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: new DropdownButton<String>(
                value: selectedGarmentCategory,
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 4,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    selectedGarmentCategory = newValue;
                  });
                },
                items: snapshotData
                    .map<DropdownMenuItem<String>>((Category value) {
                  return DropdownMenuItem<String>(
                    value: value.name,
                    child: Text(value.name),
                  );
                }).toList(),
              )),
        ]));
  }

  Widget _makeGarmentListWidget() {
    return new Expanded(
        child: FutureBuilder<List>(
      future: ClothesDB.get().getClothesByCategory(selectedGarmentCategory),
      initialData: List(),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? new ListView.builder(
                padding: const EdgeInsets.all(10.0),
                itemCount: snapshot.data.length,
                itemBuilder: (context, i) {
                  return _buildRow(snapshot.data[i]);
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    ));
  }

  Widget _buildRow(GarmentSQL garment) {
    return ListTile(
      tileColor: _getColorFor(garment),
        onTap: () {
          _editGarment(garment);
        },
        leading: Text("${garment.sex}"),
        title: Text("Size ${garment.size}: ${garment.quantity} items"),
        trailing: new Column(children: [
          new Container(
            child: new IconButton(
              icon: new Icon(Icons.delete),
              onPressed: () {
                _confirmDelete(context, garment);
              },
            ),
          ),
        ]));
  }

  Color _getColorFor(GarmentSQL garment) {
    switch (garment.sex) {
      case "boy" : return Colors.lightBlueAccent;
      case "girl": return Colors.pinkAccent;
      case "unisex": return Colors.green;
      default: return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: new MainDrawer(),
      appBar: new AppBar(
        title: new Text(
            "View ${selectedGarmentCategory} category grouped by size"),
      ),
      body:
      new FutureBuilder(
          future: ClothesDB.get().getCategories(),
          builder: (context, snapshot) {
            if (selectedGarmentCategory.isEmpty && snapshot.hasData && snapshot.data.isNotEmpty) {
              selectedGarmentCategory = snapshot.data[0].name;
            }
            if (snapshot.hasData && snapshot.data.isNotEmpty && selectedGarmentCategory.isNotEmpty) {
              return new Column(children: [
                _makeCategorySelector(snapshot.data),
                _makeGarmentListWidget(),
              ]);
            }
        return CircularProgressIndicator();
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: _addGarment,
        tooltip: 'Add Garment',
        child: Icon(Icons.add),
      ),
    );
  }
}
