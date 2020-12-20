import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wardrobe/EditGarment.dart';
import 'package:wardrobe/data/AuditEntry.dart';
import 'package:wardrobe/data/Category.dart';

import 'package:wardrobe/data/GarmentSQL.dart';
import 'package:wardrobe/data/QueryHelper.dart';

import '../utils/consts.dart';
import 'MainDrawer.dart';

class AuditLogsList extends StatefulWidget {
  @override
  _AuditLogsListState createState() => new _AuditLogsListState();
}

class _AuditLogsListState extends State<AuditLogsList> {

  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }


  Widget _buildRow(AuditEntry auditEntry) {
    return ListTile(
        leading: Text("${auditEntry.timestamp}"),
        title: Text("${auditEntry.table}: ${auditEntry.operation}"),
        subtitle: Text("${auditEntry.values}"),
        );
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: new MainDrawer(),
      appBar: new AppBar(
        title: new Text(
            "What have I done?"),
      ),
      body:
      new FutureBuilder(
          future: ClothesDB.get().getAuditEntries(),
          builder: (context, snapshot) {
            print('snapshot.hasData');
            print(snapshot.hasData);
            if (snapshot.hasData && snapshot.data.isNotEmpty) {
              return new ListView.builder(
                padding: const EdgeInsets.all(10.0),
                itemCount: snapshot.data.length,
                itemBuilder: (context, i) {
                  return _buildRow(snapshot.data[i]);
                }
              );
            }

            return CircularProgressIndicator();
          }),

    );
  }
}
