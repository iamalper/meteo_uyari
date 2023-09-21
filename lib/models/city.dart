import 'town.dart';

class City {
  final String name;
  List<Town>? towns;

  ///Unique for all Cities.
  final int centerId;
  City({required this.name, this.towns, required this.centerId});
  @override
  String toString() => "Name: $name, towns: $towns, centerId: $centerId";
  @override
  int get hashCode => centerId.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is City) {
      return other.hashCode == hashCode;
    } else {
      return false;
    }
  }
}
