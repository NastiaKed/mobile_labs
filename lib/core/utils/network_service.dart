import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkService {
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;

  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  NetworkService._internal() {
    _connectivity.onConnectivityChanged.listen((_) async {
      final isConnected = await InternetConnectionChecker().hasConnection;
      _controller.add(isConnected);
    });
  }

  Future<bool> checkConnection() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) return false;
    return await InternetConnectionChecker().hasConnection;
  }

  Stream<bool> get onConnectionChange => _controller.stream;

  void dispose() => _controller.close();
}
