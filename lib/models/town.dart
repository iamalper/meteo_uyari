class Town {
  final String? name;

  ///Unique for all Towns.
  final String id;
  const Town({required this.id, this.name});

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
