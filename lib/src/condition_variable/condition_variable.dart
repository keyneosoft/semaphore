part of '../../condition_variable.dart';

class ConditionVariable {
  final Queue<Completer<void>> _readyQueue = Queue<Completer<void>>();

  final Lock lock;

  ConditionVariable(this.lock);

  Future<void> signal() async {
    if (_readyQueue.isNotEmpty) {
      final completer = _readyQueue.removeFirst();
      completer.complete();
    }
  }

  Future<void> wait() async {
    final completer = Completer<void>();
    _readyQueue.add(completer);
    lock.release();

    await completer.future;
    await lock.acquire();
  }

  Future<void> broadcast() async {
    final completers = _readyQueue.toList();
    for (final completer in completers) {
      completer.complete();
      // await Future.delayed(Duration(seconds: 0));
    }
  }
}
