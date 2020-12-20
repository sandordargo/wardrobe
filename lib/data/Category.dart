class Category {
  int id;
  String name;

  Category({this.id, this.name});

  fromMap(dynamic c) {
    this.id = c["id"];
    this.name = c["name"];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

}