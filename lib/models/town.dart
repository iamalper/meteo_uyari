import 'package:intl/intl.dart';

class Town {
  static final _formatter = NumberFormat("00");
  final String name;

  ///Unique for all Towns.
  ///
  ///It is formatted like `9AABB`
  ///- AA = 2 digit city code (Minimum 01 , Maximum 81)
  ///- BB = 2 digit local district code (unknown for now)
  final int id;

  ///The [cityCode] which [this] belongs to. It is always between 0 and 81
  ///
  ///Use [formattedCityCode] for always getting 2 digit code.
  int get cityCode => int.parse(id.toString().substring(1, 3));

  ///2 digit [cityCode]
  String get formattedCityCode => _formatter.format(cityCode);

  Town({required this.id, required this.name}) {
    assert(id.toString().startsWith("9"));
    assert(id.toString().length == 5);
    assert(cityCode >= 0 && cityCode <= 81);
  }
  Town.fromMap(Map<String, dynamic> map)
      : this(id: map["id"], name: map["name"]);

  Map<String, dynamic> get map => {"id": id, "name": name};

  @override
  String toString() => "Name: $name, Id: $id";

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is Town) {
      return other.hashCode == hashCode;
    } else {
      return false;
    }
  }
}
