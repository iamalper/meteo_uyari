///Base exception for MeteoUyari app.
///
///See [message]
abstract class MeteoUyariException implements Exception {
  ///Error message that shown to end user. Doesnt't contains technical details.
  String get message;
}

///Throw when user reject notification permission request.
class NoNotificationPermissionException implements MeteoUyariException {
  @override
  String get message => "Gerekli izinler verilmedi.";
}

///Throw when city could not saved.
///
///Usually throws when device has not enough storage space.
class UnableToSaveCityException implements MeteoUyariException {
  @override
  String get message =>
      "Seçim kaydedilemedi, yeteri depolama alanına sahip olduğunuza emin olun.";
}

///Throws when a parser unable to parse a request.
///
///Usually the reason is change to api.
class ParserException implements MeteoUyariException {
  @override
  String get message => "Servis hatası";
}
