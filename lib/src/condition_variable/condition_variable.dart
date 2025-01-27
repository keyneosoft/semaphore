part of '../../condition_variable.dart';

class ConditionVariable {
  final Queue<Completer<void>> _readyQueue = Queue<Completer<void>>();

  final Lock _lock;

  ConditionVariable([this._lock]);

  Future<void> signal() async {
    if (_readyQueue.isNotEmpty) {
      final completer = _readyQueue.removeFirst();
      completer.complete();
    }
  }

  Future<void> wait() async {
    final completer = Completer<void>();
    _readyQueue.add(completer);
    if (_lock != null) {
      _lock.release();
    }

    await completer.future;
    if (_lock != null) {
      await _lock.acquire();
    }
  }

  Future<void> broadcast() async {
    final completers = _readyQueue.toList();
    for (final completer in completers) {
      completer.complete();
      // await Future.delayed(Duration(seconds: 0));
    }
  }
}
