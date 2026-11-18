import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class InternetService extends GetxController with WidgetsBindingObserver {
  static InternetService get to => Get.find();

  final RxBool isConnected = true.obs;

  StreamSubscription<List<ConnectivityResult>>? _subscription;
  Timer? _retryTimer;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    if (!kIsWeb) {
      _checkConnection();
      _subscription =
          Connectivity().onConnectivityChanged.listen(_onConnectivityChanged);
    } else {
      isConnected.value = true;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !kIsWeb) {
      _checkConnection();
    }
  }

  void _onConnectivityChanged(List<ConnectivityResult> results) {
    if (kIsWeb) {
      isConnected.value = true;
      return;
    }
    if (results.isEmpty || results.every((r) => r == ConnectivityResult.none)) {
      isConnected.value = false;
      _startRetryTimer();
    } else {
      _verifyInternet();
    }
  }

  void _startRetryTimer() {
    if (kIsWeb) return;
    _retryTimer?.cancel();
    _retryTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      await _checkConnection();
      if (isConnected.value) {
        _retryTimer?.cancel();
        _retryTimer = null;
      }
    });
  }

  Future<void> _verifyInternet() async {
    if (kIsWeb) {
      isConnected.value = true;
      return;
    }
    try {
      final results = await Connectivity().checkConnectivity();
      isConnected.value = results.isNotEmpty && !results.every((r) => r == ConnectivityResult.none);
    } catch (_) {
      isConnected.value = true;
    }
  }

  Future<void> _checkConnection() async {
    if (kIsWeb) {
      isConnected.value = true;
      return;
    }
    try {
      final results = await Connectivity().checkConnectivity();
      isConnected.value = results.isNotEmpty && !results.every((r) => r == ConnectivityResult.none);
    } catch (_) {
      isConnected.value = true;
    }
  }

  Future<void> retry() => _checkConnection();

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _subscription?.cancel();
    _retryTimer?.cancel();
    super.onClose();
  }
}
