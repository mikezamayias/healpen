import 'dart:async';

import '../utils/logger.dart';

extension StreamExtension on Stream {
  Future<T> toFuture<T>() {
    final completer = Completer<T>();

    first.then((value) {
      completer.complete(value);
    }).catchError((error) {
      logger.e('$error');
      completer.completeError(error);
    });

    return completer.future;
  }
}
