import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class InternetController extends ChangeNotifier {
  bool isOnline = true;

  late StreamSubscription<List<ConnectivityResult>> _subscription;

  InternetController() {
    _init();
  }

  void _init() {
    _subscription =
        Connectivity().onConnectivityChanged.listen(_updateStatus);

    _checkInitialConnection();
  }

  Future<void> _checkInitialConnection() async {
    final result = await Connectivity().checkConnectivity();
    _updateStatus(result);
  }

  void _updateStatus(List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi)) {
      isOnline = true;
    } else {
      isOnline = false;
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}