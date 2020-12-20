class GarmentSQL {
  int id;
  String category;
  String sex;
  String size;
  int quantity;

  GarmentSQL({this.id, this.category, this.sex, this.size, this.quantity});

  fromMap(String category, dynamic c) {
    this.category = category;
    this.id = c["id"];
    this.sex = c["sex"];
    this.size = c["size"];
    this.quantity = c["quantity"];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      // 'category': category,
      'sex': sex,
      'size': size,
      'quantity': quantity,
    };
  }

}