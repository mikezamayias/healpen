import 'dart:async';

extension StreamExtension on Stream {
  Future<T> toFuture<T>() {
    final completer = Completer<T>();

    first.then((value) {
      completer.complete(value);
    }).catchError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }
}
