import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Garment extends HiveObject {

  @HiveField(0)
  String sex;

  @HiveField(1)
  String size;

  @HiveField(2)
  int quantity;

  @HiveField(3)
  String categeory;

  Garment({this.sex, this.size, this.quantity, this.categeory});

  String toString() {
    return "Garment(sex: ${this.sex}, size: ${this.size}, "
        "quantity: ${this.quantity}, category: ${this.categeory})\n";
  }
}

class GarmentAdapter extends TypeAdapter<Garment> {
  @override
  final typeId = 0;

  @override
  Garment read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Garment()
      ..sex = fields[0] as String
      ..size = fields[1] as String
      ..quantity = fields[2] as int
      ..categeory = fields[3] as String;
  }

  @override
  void write(BinaryWriter writer, Garment obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.sex)
      ..writeByte(1)
      ..write(obj.size)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(3)
      ..write(obj.categeory);
  }
}