class AuditEntry {
  int id;
  String operation;
  String table;
  String timestamp;
  int external_id = -1;
  String values;

  AuditEntry(this.operation, this.table, {this.timestamp, this.id, this.values, this.external_id});

  // fromMap(String category, dynamic c) {
  //   this.operation = category;
  //   this.id = c["id"];
  //   this.table = c["sex"];
  //   this.values = c["size"];
  //   this.external_id = c["quantity"];
  // }
  //
  // Map<String, dynamic> toMap() {
  //   return {
  //     'id': id,
  //     // 'category': category,
  //     'sex': table,
  //     'size': values,
  //     'quantity': external_id,
  //   };
  // }

}