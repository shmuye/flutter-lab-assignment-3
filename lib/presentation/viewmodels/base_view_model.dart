import 'package:flutter/foundation.dart';

abstract class BaseViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  @protected
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @protected
  void setError(String? value) {
    _error = value;
    notifyListeners();
  }

  @protected
  Future<T> handleAsync<T>({
    required Future<T> Function() action,
    String? errorMessage,
  }) async {
    try {
      setLoading(true);
      setError(null);
      return await action();
    } catch (e) {
      setError(errorMessage ?? e.toString());
      rethrow;
    } finally {
      setLoading(false);
    }
  }
}