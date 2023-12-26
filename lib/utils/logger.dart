import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrefixPrinter(
    PrettyPrinter(
      colors: true,
      methodCount: 3,
      lineLength: 80,
      errorMethodCount: 6,
      noBoxingByDefault: false,
      printEmojis: true,
      printTime: true,
    ),
    trace: null,
  ),
);
