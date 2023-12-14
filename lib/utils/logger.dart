import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrefixPrinter(
    PrettyPrinter(
      colors: true,
      noBoxingByDefault: false,
      methodCount: 5,
      errorMethodCount: 5,
      lineLength: 80,
      printEmojis: true,
      printTime: true,
    ),
  ),
);
