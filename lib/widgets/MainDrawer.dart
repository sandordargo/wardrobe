import 'package:flutter/material.dart';
import 'package:wardrobe/data/DateExporter.dart';
import 'package:wardrobe/widgets/AuditLogsList.dart';


import 'categories/CategoriesList.dart';
import '../ViewByCategory.dart';
import '../ViewBySize.dart';

class MainDrawer extends StatefulWidget {
  MainDrawer();

  @override
  _MyDrawerState createState() => new _MyDrawerState();
}

class _MyDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new ListView(
        children: [
          new DrawerHeader(
              child: Text("Track Your Clothes",
              style: TextStyle(height: 3,
                  fontSize: 30,
                decorationStyle: TextDecorationStyle.wavy,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 3
                  ..color = Colors.blue[700],),),
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
              // image: DecorationImage(
              //   image: AssetImage('assets/images/wardrobe.png'),
              //   fit: BoxFit.scaleDown ,
              // ),
            ),
          ),
          new ListTile(
            title: new Text("View By Category"),
            onTap: _viewByCategory,
          ),
          new ListTile(
            title: new Text("View By Size"),
            onTap: _viewBySize,
          ),
          new ListTile(
            title: new Text("Manage Categories"),
            onTap: _categoriesList,
          ),
          new ListTile(
            title: new Text("Check Your Activities"),
            onTap: _auditLogs,
          ),
          new ListTile(
            title: new Text("Export data"),
            onTap: _exportData,
          ),
        ],
      ),
    );
  }

  void _viewByCategory() {
    Navigator.pop(context);
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new ViewByCategory()),
    );
  }

  void _viewBySize() {
    Navigator.pop(context);
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new ViewBySize()),
    );
  }

  void _categoriesList() {
    Navigator.pop(context);
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new CategoriesList()),
    );
  }

  void _auditLogs() {
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new AuditLogsList()),
    );
  }

  void _exportData() {
    Navigator.pop(context);
    new DataExporter().export();
  }
}
