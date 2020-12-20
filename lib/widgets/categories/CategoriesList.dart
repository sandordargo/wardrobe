import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wardrobe/EditGarment.dart';
import 'package:wardrobe/data/Category.dart';

import 'package:wardrobe/data/GarmentSQL.dart';
import 'package:wardrobe/data/QueryHelper.dart';
import 'package:wardrobe/widgets/categories/AddCategory.dart';
import 'package:wardrobe/widgets/categories/EditCategory.dart';

import '../../utils/consts.dart';
import '../MainDrawer.dart';

class CategoriesList extends StatefulWidget {
  @override
  _CategoriesListState createState() => new _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  var selectedGarmentCategory = garmentCategories[0];

  void _addCategory() {
    Navigator.push(
      context,
      new MaterialPageRoute(
          builder: (context) =>
              new AddCategory()),
    ).then(onGoBack);
  }

  void _editCategory(Category category) {
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new EditCategory(category)),
    ).then(onGoBack);
  }

  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  void _deleteSize(_confirmDelete) {
    setState(() {
      ClothesDB.get().deleteCategory(_confirmDelete);
    });
  }

  _confirmDelete(BuildContext context, Category category) {
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
        _deleteSize(category);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Are you sure?"),
      content: Text(
          "You are about to delete ${category.name}."),
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

  Widget _makeGarmentListWidget() {
    return new Expanded(
        child: FutureBuilder<List>(
      future: ClothesDB.get().getCategories(),
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

  Widget _buildRow(Category category) {
    return ListTile(
        onTap: () {
          _editCategory(category);
        },
        title: Text("${category.name}"),
        trailing: new Column(children: [
          new Container(
            child: new IconButton(
              icon: new Icon(Icons.delete),
              onPressed: () {
                _confirmDelete(context, category);
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
      body: new Column(children: [
        _makeGarmentListWidget(),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCategory,
        tooltip: 'Add Category',
        child: Icon(Icons.add),
      ),
    );
  }
}
