///Contains custom exceptions for simplifiying error management and showing localised error messages to user.
///
///All exceptions should implement [MeteoUyariException]
library;

///Base exception for MeteoUyari app.
///
///See [message] for localised error messages.
abstract class MeteoUyariException implements Exception {
  ///Error message that shown to end user. Doesn't contains technical details.
  String get message;
}

@Deprecated("App no longer have to manage storage space")
class UnableToSaveCityException implements MeteoUyariException {
  ///Throw when city could not saved.
  ///
  ///Usually throws when device has not enough storage space.
  const UnableToSaveCityException();
  @override
  String get message =>
      "Seçim kaydedilemedi, yeteri depolama alanına sahip olduğunuza emin olun.";
}

class NetworkException implements MeteoUyariException {
  ///Throws for network errors.
  const NetworkException();
  @override
  String get message => "Bağlantı hatası";
}
