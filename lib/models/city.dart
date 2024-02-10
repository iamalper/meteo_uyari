import 'town.dart';
import 'alert.dart';

class City {
  ///City's name. It can be shown to user.
  final String name;

  ///The towns which belongs to [City].
  ///
  ///Not yet implemented.
  final Set<Town>? towns;

  ///Unique for all Cities.
  ///
  ///It's center town for MeteoUyari api and returns as a [String].
  ///
  ///[Alert.towns] contains this value as [int],
  ///for comparing use [City.centerIdInt]
  final String id;
  const City({required this.name, this.towns, required this.id});

  City.fromMap(Map<String, dynamic> map)
      : this(
            id: map["id"].toString(),
            name: map["name"],
            towns: map["towns"] == null
                ? null
                : {for (final town in map["towns"]) Town.fromMap(town)});

  ///[id] as [int] value for comparing with any [Alert] object
  int get centerIdInt => int.parse(id);
  Map<String, dynamic> get toMap =>
      {"centerId": id, "name": name, "towns": towns?.toList()};
  @override
  String toString() => "Name: $name, towns: $towns, centerId: $id";
  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is City) {
      return other.hashCode == hashCode;
    } else {
      return false;
    }
  }
}
