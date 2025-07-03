import 'dart:io';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import '/app/core/utils/connectivity_helper.dart';

import 'sync_client_service.dart';
import 'sync_server_service.dart';

/// SyncService is responsible for managing synchronization between client and server.
/// It attempts to connect to an existing server; if none is found, it starts a new server.
@lazySingleton
class SyncService {
  final InternetAddress _serverAddress = Platform.isAndroid
      ? InternetAddress.anyIPv4
      : InternetAddress.loopbackIPv4;
  final int _defaultPort = 50505;

  late final _client = SyncClientService(
    address: _serverAddress,
    port: _defaultPort,
  );

  final _server = SyncServerService();
  final ConnectivityHelper _connectivityHelper;

  SyncService(this._connectivityHelper);

  /// Checks if there is an active internet connection.
  Future<bool> hasConnection() async {
    return await _connectivityHelper.checkNow();
  }

  /// Initializes the sync service by attempting to connect to a server on [port].
  /// If no server is found, it starts a new server instance.
  Future<void> init() async {
    try {
      final Socket socket = await Socket.connect(
        _serverAddress,
        _defaultPort,
        timeout: Duration(milliseconds: 800),
      );
      socket.destroy(); // Server exists
      debugPrint('🧑‍💻 Acting as client');
    } catch (_) {
      debugPrint('🛠 No server found. Acting as server');
      await _server.startServer(address: _serverAddress, port: _defaultPort);
    }
  }

  /// Pushes data to the server.
  Future<void> push({
    required String table,
    required Map<String, dynamic> data,
  }) async {
    await _client.push(table, data);
  }

  /// Pull one item from the server.
  Future<Map<String, dynamic>> pullOne({
    required table,
    required String id,
  }) async {
    return await _client.pullOne(table: table, id: id);
  }

  /// Pulls data from the server.
  Future<List<Map<String, dynamic>>> pull({required String table}) async {
    return await _client.pull(table);
  }

  /// Deletes a record from the server.
  Future<void> delete({required String table, required String id}) async {
    await _client.delete(table, id);
  }
}
