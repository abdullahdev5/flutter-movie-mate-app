import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectivityService {

  final Connectivity _connectivity = Connectivity();


  Future<bool> getIsNetworkEnabled() async {
    final connectivity = await _connectivity.checkConnectivity();
    return !connectivity.contains(ConnectivityResult.none);
  }

}

final connectivityServiceProvider = Provider<ConnectivityService>((_) => ConnectivityService());