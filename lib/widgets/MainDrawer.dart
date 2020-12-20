import 'package:flutter/material.dart';
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
          new DrawerHeader(child: Text("Wardrobe")),
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
    Navigator.pop(context);
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new AuditLogsList()),
    );
  }
}
