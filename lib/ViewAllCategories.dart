// https://medium.com/@viveky259259/hive-for-flutter-3-implementation-e825a0a833d3
// https://resocoder.com/2019/09/30/hive-flutter-tutorial-lightweight-fast-database/

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'AddGarment.dart';
import 'utils/consts.dart';

class ViewAllCategories extends StatefulWidget {
  ViewAllCategories({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ViewAllCategoriesState createState() => _ViewAllCategoriesState();
}

class _ViewAllCategoriesState extends State<ViewAllCategories> {
  void openCBox() async {
    await Hive.openBox('Cardigan');
  }
  
  void openBox(var boxName) async {
    await Hive.openBox(boxName);
  }

  void _addGarment() {
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new AddGarment()),
    ).then(onGoBack);
  }

  List<Widget> buildListOfGarments() {
    List<Widget> garments = new List();
    for (var category in garmentCategories) {
      for (var key in Hive.box(category).keys) {
        openBox(key);
        garments.add(Text(
          '${Hive.box(category).get(key)} of size ${key} of category ${category}',
          style: Theme.of(context).textTheme.headline4,
        ));
      }
    }
    return garments;
  }

  FutureOr onGoBack(dynamic value) {
    setState(() {

    });
  }

  List<Widget> makeWidgets() {
    List<Widget> results = new List();
    for (var boxName in garmentCategories) {
      results.add( Expanded(
          child: Center( child:

          ValueListenableBuilder(valueListenable: Hive.box(boxName).listenable(),
            builder: (context, Box box, _) {
              if (box.values.isEmpty) {
                return Text('data is empty');
              } else {
                return ListView.builder(
                  itemCount: box.values.length,
                  itemBuilder: (context, index) {
                    var contact = box.getAt(index);
                    return ListTile(
                      title: Text(contact.toString()),
                    );
                  },
                );
              }
            },
          )
          )));
    }
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
          children: makeWidgets()
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addGarment,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}