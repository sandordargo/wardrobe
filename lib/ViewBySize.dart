import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wardrobe/EditGarment.dart';
import 'package:wardrobe/ViewByCategory.dart';
import 'package:wardrobe/ViewBySize.dart';
import 'package:wardrobe/data/GarmentSQL.dart';
import 'package:wardrobe/data/QueryHelper.dart';

import 'AddGarment.dart';
import 'data/AuditEntry.dart';
import 'utils/consts.dart';
import 'widgets/MainDrawer.dart';

class ViewBySize extends StatefulWidget {
  @override
  _ViewBySizeState createState() => new _ViewBySizeState();
}

class _ViewBySizeState extends State<ViewBySize> {
  var selectedSize = "";

  void _addGarment() {
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new AddGarment()),
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

  Color _getColorFor(GarmentSQL garment) {
    switch (garment.sex) {
      case "boy":
        return Colors.lightBlueAccent;
      case "girl":
        return Colors.pinkAccent;
      case "unisex":
        return Colors.green;
      default:
        return Colors.transparent;
    }
  }

  void _deleteSize(GarmentSQL garment) {
    setState(() {
      ClothesDB.get().insertAuditEntry(new AuditEntry("DELETE", "CLOTHES",
          values: "CATEGORY: ${garment.category}, QUANTITY: ${garment.quantity}, SIZE: ${garment.size}, SEX: ${garment.sex}"));
      ClothesDB.get().deleteGarment(garment);
    });
    showDialog(
        context: context,
        builder: (context) {
          return new AlertDialog(
            title: new Text("You want to delete $garment"),
          );
        });
  }

  showAlertDialog(BuildContext context, garment) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        Navigator.of(context).pop();
        _deleteSize(garment);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text(
          "Would you like to continue learning how to use Flutter alerts?"),
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

  FutureBuilder<List> makeWidgets2() {

    return FutureBuilder<List>(
      future: ClothesDB.get().getClothesBySize(selectedSize),
      initialData: List(),
      builder: (context, snapshot) {
        print('nnn');
        print(snapshot.data);
        print(selectedSize);
        if (snapshot.hasData && snapshot.data.isNotEmpty && selectedSize.isNotEmpty) {
          print("selectedSize");
          print(selectedSize);
          print(snapshot.data);
          print("selectedSizeend");
          return new ListView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: snapshot.data.length,
            itemBuilder: (context, i) {
              return _buildRow(snapshot.data[i]);
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildRow(GarmentSQL garment) {
    // return new ListTile(
    //   title: new Text("${fruit.size} ${fruit.category} ${fruit.quantity}"),
    // );
    print("br");
    print(garment);
    print(garment.category);
    print(garment.sex);
    return ListTile(
        tileColor: _getColorFor(garment),
        onTap: () {
          print('tapped');
          _editGarment(garment);
          // Navigator.push(
          //   context,
          //   new MaterialPageRoute(builder: (context) => new
          //   EditGarment(garment)),
          // );
        },
        leading: Text("${garment.sex}"),
        title: Text(
            "${garment.category} Size ${garment.size}: ${garment.quantity} items"),
        // subtitle: Text(contact.age.toString()),
        trailing: new Column(children: [
          new Container(
            child: new IconButton(
              icon: new Icon(Icons.delete),
              onPressed: () {
                print('delete');
                // _deleteSize(box, box.keyAt(index));
                showAlertDialog(context, garment);
              },
            ),
//              margin: const EdgeInsets.symmetric(horizontal: 0.5)
          ),
        ]));
  }

  // List<String> fetchSizes() {
  //   var sizes = ClothesDB.get().getSizes();
  //   return sizes;
  // }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: new MainDrawer(),
      appBar: new AppBar(
        title: new Text("View ${selectedSize} size"),
      ),
      body:
          // new Container(child: makeWidgets2()),
      new FutureBuilder(


                future: ClothesDB.get().getSizes(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {

                    print("snapshot.data");
                    print(snapshot.data);
                    // setState(() {
                    if (selectedSize.isEmpty) {
                      selectedSize = snapshot.data[0];
                    }
                    // });

                    return new Column(children: [
                    new DropdownButton<String>(
                      value: selectedSize,
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
                          selectedSize = newValue;
                        });
                      },
                      items: snapshot.data
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                      new Expanded(child: makeWidgets2()),
                    ]);
                  }

                  return CircularProgressIndicator();
                }),
        //       new Container(
        //           padding: const EdgeInsets.only(bottom: 8.0),
        //           child: new DropdownButton<String>(
        //             value: selectedSize,
        //             icon: Icon(Icons.arrow_downward),
        //             iconSize: 24,
        //             elevation: 16,
        //             style: TextStyle(color: Colors.deepPurple),
        //             underline: Container(
        //               height: 2,
        //               color: Colors.deepPurpleAccent,
        //             ),
        //             onChanged: (String newValue) {
        //               setState(() {
        //                 selectedSize = newValue;
        //               });
        //             },
        //             items: fetchSizes()
        //                 .map<DropdownMenuItem<String>>((String value) {
        //               return DropdownMenuItem<String>(
        //                 value: value,
        //                 child: Text(value),
        //               );
        //             }).toList(),
        //           )),
        //
        //     ])
        // ),
        // new Expanded(child: makeWidgets2()),
      // ]),
      floatingActionButton: FloatingActionButton(
        onPressed: _addGarment,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
