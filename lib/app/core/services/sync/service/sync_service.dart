import 'dart:io';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import '/app/core/utils/connectivity_helper.dart';

import 'sync_client_service.dart';
import 'sync_server_service.dart';
import 'package:flutter/foundation.dart';

/// SyncService is responsible for managing synchronization between client and server.
/// It attempts to connect to an existing server; if none is found, it starts a new server.
@lazySingleton
// class SyncService {
//   final InternetAddress _serverAddress = Platform.isAndroid
//       ? InternetAddress.anyIPv4
//       : InternetAddress.loopbackIPv4;
//   final int _defaultPort = 50505;
//   late final _client = SyncClientService(
//     address: _serverAddress,
//     port: _defaultPort,
//   );
//   final _server = SyncServerService();
//   final ConnectivityHelper _connectivityHelper;
//   SyncService(this._connectivityHelper);
//   /// Checks if there is an active internet connection.
//   Future<bool> hasConnection() async {
//     return await _connectivityHelper.checkNow();
//   }
//   /// Initializes the sync service by attempting to connect to a server on [port].
//   /// If no server is found, it starts a new server instance.
//   Future<void> init() async {
//     try {
//       final Socket socket = await Socket.connect(
//         _serverAddress,
//         _defaultPort,
//         timeout: Duration(milliseconds: 800),
//       );
//       socket.destroy(); // Server exists
//       debugPrint('🧑‍💻 Acting as client');
//     } catch (_) {
//       debugPrint('🛠 No server found. Acting as server');
//       await _server.startServer(address: _serverAddress, port: _defaultPort);
//     }
//   }
//   /// Pushes data to the server.
//   Future<void> push({
//     required String table,
//     required Map<String, dynamic> data,
//   }) async {
//     await _client.push(table, data);
//   }
//   /// Pull one item from the server.
//   Future<Map<String, dynamic>> pullOne({
//     required table,
//     required String id,
//   }) async {
//     return await _client.pullOne(table: table, id: id);
//   }
//   /// Pulls data from the server.
//   Future<List<Map<String, dynamic>>> pull({required String table}) async {
//     return await _client.pull(table);
//   }
//   /// Deletes a record from the server.
//   Future<void> delete({required String table, required String id}) async {
//     await _client.delete(table, id);
//   }
// }
class SyncService {
  final InternetAddress _serverAddress = Platform.isAndroid
      ? InternetAddress.loopbackIPv4
      : InternetAddress.loopbackIPv4;
  final int _defaultPort = 50505;

  SyncClientService? _client;
  final SyncServerService _server = SyncServerService();
  final ConnectivityHelper _connectivityHelper;

  SyncService(this._connectivityHelper);

  /// Initializes WebSocket-based sync.
  Future<void> init() async {
    debugPrint(_serverAddress.toString());
    final serverRunning = await _isServerRunning();

    if (!serverRunning) {
      try {
        await _server.startServer(address: _serverAddress, port: _defaultPort);
        debugPrint('🟢 Started WebSocket server');
      } catch (e) {
        debugPrint('❌ Failed to start server: $e');
      }
    }

    // ✅ Always initialize client regardless of server status
    final client = await getClient();
    await client.connect();
    debugPrint('🔗 Connected as WebSocket client');
  }

  Future<SyncClientService> getClient() async {
    if (_client == null) {
      _client = SyncClientService(address: _serverAddress, port: _defaultPort);
      await _client!.connect();
    }
    return _client!;
  }

  // /// Checks if the server is running by attempting to connect to it.
  Future<bool> _isServerRunning() async {
    try {
      final socket = await WebSocket.connect(
        'ws://${_serverAddress.address}:$_defaultPort',
      );
      await socket.close();
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Checks current internet connectivity.
  Future<bool> hasConnection() async {
    return await _connectivityHelper.checkNow();
  }

  /// Sends data to the server.
  Future<void> push({
    required String table,
    required Map<String, dynamic> data,
  }) async {
    final client = await getClient();
    await client.push(table, data);
  }

  /// Pulls all items from the server.
  Future<List<Map<String, dynamic>>> pull({required String table}) async {
    final client = await getClient();
    return await client.pull(table);
  }

  /// Pulls one item from the server.
  Future<Map<String, dynamic>> pullOne({
    required String table,
    required String id,
  }) async {
    final client = await getClient();
    return await client.pullOne(table: table, id: id);
  }

  /// Deletes an item from the server.
  Future<void> delete({required String table, required String id}) async {
    final client = await getClient();
    await client.delete(table, id);
  }

  /// Real-time messages from the server (e.g., 'updated' events).
  Future<Stream<Map<String, dynamic>>> get messages async {
    final client = await getClient();
    return client.messages;
  }

  /// Closes connections and cleans up.
  void dispose() {
    _client?.dispose();
    _server.stopServer();
  }
}
