import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '/app/core/utils/sync_storage_manager.dart';
import '/app/core/exception/sync_service_exception.dart';

/// A service class that manages a sync server to handle client requests for data operations.
/// Supports PUSH, PULL, and DELETE operations from connected clients.
// class SyncServerService {
//   ServerSocket? _server;
//
//   /// Starts the server on the provided [address] and [port].
//   /// Throws [SyncServiceException] if server fails to start.
//   Future<void> startServer({
//     required InternetAddress address,
//     required int port,
//   }) async {
//     try {
//       _server = await ServerSocket.bind(address, port);
//       debugPrint('🟢 Sync Server started on port $port');
//       _server!.listen(
//         _handleClientConnection,
//         onError: (error) => debugPrint('Server error: $error'),
//         onDone: () => debugPrint('Server stopped accepting connections'),
//       );
//     } on SocketException catch (e) {
//       debugPrint('Failed to start server: $e');
//       throw SyncServiceException('Failed to start server: ${e.message}');
//     }
//   }
//
//   /// Handles incoming client connections with a timeout of 10 seconds.
//   /// Processes messages based on their 'type' field:
//   /// - `PUSH`: Saves data to file.
//   /// - `PULL`: Reads all data from file.
//   /// - `DELETE`: Deletes a specific item from the file.
//   void _handleClientConnection(Socket client) {
//     client
//         .timeout(Duration(seconds: 10))
//         .listen(
//           (data) async {
//             final msg = utf8.decode(data);
//             final decoded = jsonDecode(msg);
//             final type = decoded['type'];
//             final table = decoded['table'];
//
//             if (type == 'PUSH') {
//               await _saveToFile(table, decoded['data']);
//               client.write(jsonEncode({'status': 'success'}));
//             } else if (type == 'PULL') {
//               final data = await _readAllFromFile(table);
//               client.write(jsonEncode({'data': data}));
//             } else if (type == 'PULL_ONE') {
//               final id = decoded['id'];
//               final item = await _readOneFromFile(table, id);
//               client.write(jsonEncode({'data': item}));
//             } else if (type == 'DELETE') {
//               await _deleteFromFile(table, decoded['id']);
//               client.write(jsonEncode({'status': 'deleted'}));
//             }
//
//             client.close();
//           },
//           onError: (error) {
//             debugPrint('Client error: $error');
//             client.close();
//           },
//           onDone: () => client.close(),
//         );
//   }
//
//   /// Saves or updates [data] in the specified [table] file.
//   /// Ensures idempotency by comparing timestamps for conflict resolution.
//   Future<void> _saveToFile(String table, Map<String, dynamic> data) async {
//     final file = await _getTableFile(table);
//     List<Map<String, dynamic>> items = [];
//
//     if (await file.exists()) {
//       final content = await file.readAsString();
//       if (content.trim().isNotEmpty) {
//         try {
//           final parsed = jsonDecode(content);
//           if (parsed is List) {
//             items = List<Map<String, dynamic>>.from(parsed);
//           }
//         } catch (e) {
//           debugPrint('🚨 JSON parse error in $table.json: $e');
//         }
//       }
//     }
//
//     final existingIndex = items.indexWhere((e) => e['id'] == data['id']);
//     if (existingIndex != -1) {
//       final existing = items[existingIndex];
//       final existingTime =
//           DateTime.tryParse(existing['updatedAt'] ?? '') ?? DateTime(2000);
//       final newTime =
//           DateTime.tryParse(data['updatedAt'] ?? '') ?? DateTime.now();
//
//       debugPrint('⏰ Comparing: new=$newTime, existing=$existingTime');
//
//       if (!newTime.isBefore(existingTime)) {
//         items[existingIndex] = data;
//         debugPrint('✅ Updated item at index $existingIndex');
//       } else {
//         debugPrint('⛔ Skipped update; existing is newer or same');
//       }
//     } else {
//       items.add(data);
//       debugPrint('➕ Added new item');
//     }
//
//     await file.writeAsString(jsonEncode(items));
//     debugPrint('📁 File saved: ${file.path}');
//   }
//
//   /// Reads a single item with the specified [id] from the given [table] file.
//   Future<Map<String, dynamic>?> _readOneFromFile(
//     String table,
//     String id,
//   ) async {
//     final file = await _getTableFile(table);
//     if (!await file.exists()) return null;
//
//     final content = await file.readAsString();
//     if (content.isEmpty) return null;
//
//     final List<Map<String, dynamic>> items = List<Map<String, dynamic>>.from(
//       jsonDecode(content),
//     );
//
//     return items.firstWhere((item) => item['id'] == id, orElse: () => {});
//   }
//
//   /// Reads all data from the specified [table] file.
//   Future<List<Map<String, dynamic>>> _readAllFromFile(String table) async {
//     final file = await _getTableFile(table);
//     if (!await file.exists()) return [];
//     final content = await file.readAsString();
//     if (content.isEmpty) return [];
//     return List<Map<String, dynamic>>.from(jsonDecode(content));
//   }
//
//   /// Returns the file path for the given [table].
//   Future<File> _getTableFile(String table) async {
//     final dir = await SyncStorageManager.getSyncDirectory(); // base folder
//     return File('${dir.path}/$table.json');
//   }
//
//   /// Deletes an item with the specified [id] from the given [table] file.
//   Future<void> _deleteFromFile(String table, String id) async {
//     final file = await _getTableFile(table);
//     if (!await file.exists()) return;
//
//     final content = await file.readAsString();
//     if (content.isEmpty) return;
//
//     List<Map<String, dynamic>> items = List<Map<String, dynamic>>.from(
//       jsonDecode(content),
//     );
//     items.removeWhere((item) => item['id'] == id);
//     await file.writeAsString(jsonEncode(items));
//   }
//
//   /// Stops the running server gracefully.
//   Future<void> stopServer() async {
//     await _server?.close();
//     debugPrint('🔴 Server stopped');
//   }
// }
//

/// WebSocket Server

class SyncServerService {
  HttpServer? _server;
  final List<WebSocket> _clients = [];

  Future<void> startServer({
    required InternetAddress address,
    required int port,
  }) async {
    try {
      _server = await HttpServer.bind(address, port);
      debugPrint('🟢 WebSocket Server started on $address:$port');
      _server!.listen((HttpRequest request) async {
        if (WebSocketTransformer.isUpgradeRequest(request)) {
          final socket = await WebSocketTransformer.upgrade(request);
          _clients.add(socket);
          _handleWebSocketClient(socket);
        } else {
          request.response
            ..statusCode = HttpStatus.badRequest
            ..write('Expected WebSocket request')
            ..close();
        }
      });
    } catch (e) {
      debugPrint('Failed to start server: $e');
      throw SyncServiceException('Failed to start server: ${e.toString()}');
    }
  }

  void _handleWebSocketClient(WebSocket client) {
    client.listen(
          (data) async {
        try {
          final decoded = jsonDecode(data);
          final type = decoded['type'];
          final table = decoded['table'];
          final requestId = decoded['requestId'] ?? 'unknown';

          debugPrint('📨 Received $type request for $table (req: $requestId)');

          if (type == 'PUSH') {
            await _saveToFile(table, decoded['data']);
            _broadcast({
              'event': 'updated',
              'table': table,
              'requestId': requestId,
              'isEvent': true,
            });
            client.add(jsonEncode({
              'status': 'success',
              'requestId': requestId,
            }));
          } else if (type == 'PULL') {
            final data = await _readAllFromFile(table);
            client.add(jsonEncode({
              'data': data,
              'requestId': requestId,
            }));
          } else if (type == 'PULL_ONE') {
            final item = await _readOneFromFile(table, decoded['id']);
            if (item != null && item.isNotEmpty) {
              client.add(jsonEncode({
                'data': item,
                'requestId': requestId,
              }));
            } else {
              client.add(jsonEncode({
                'error': 'Item not found',
                'requestId': requestId,
              }));
            }
          } else if (type == 'DELETE') {
            await _deleteFromFile(table, decoded['id']);
            _broadcast({
              'event': 'updated',
              'table': table,
              'requestId': requestId,
              'isEvent': true,
            });
            client.add(jsonEncode({
              'status': 'deleted',
              'requestId': requestId,
            }));
          } else {
            client.add(jsonEncode({
              'error': 'Unknown operation type',
              'requestId': requestId,
            }));
          }
        } catch (e) {
          client.add(jsonEncode({
            'error': e.toString(),
            'requestId': 'unknown',
          }));
        }
      },
      onDone: () => _clients.remove(client),
      onError: (_) => _clients.remove(client),
    );
  }

  void _broadcast(Map<String, dynamic> message) {
    final json = jsonEncode(message);
    for (var client in _clients) {
      client.add(json);
    }
  }

  Future<void> stopServer() async {
    for (final client in _clients) {
      await client.close();
    }
    await _server?.close();
    debugPrint('🔴 WebSocket Server stopped');
  }

  Future<void> _saveToFile(String table, Map<String, dynamic> data) async {
    final file = await _getTableFile(table);
    List<Map<String, dynamic>> items = [];

    if (await file.exists()) {
      final content = await file.readAsString();
      if (content.trim().isNotEmpty) {
        try {
          final parsed = jsonDecode(content);
          if (parsed is List) {
            items = List<Map<String, dynamic>>.from(parsed);
          }
        } catch (e) {
          debugPrint('🚨 JSON parse error in $table.json: $e');
        }
      }
    }

    final existingIndex = items.indexWhere((e) => e['id'] == data['id']);
    if (existingIndex != -1) {
      final existing = items[existingIndex];
      final existingTime =
          DateTime.tryParse(existing['updatedAt'] ?? '') ?? DateTime(2000);
      final newTime =
          DateTime.tryParse(data['updatedAt'] ?? '') ?? DateTime.now();

      debugPrint('⏰ Comparing: new=$newTime, existing=$existingTime');

      if (!newTime.isBefore(existingTime)) {
        items[existingIndex] = data;
        debugPrint('✅ Updated item at index $existingIndex');
      } else {
        debugPrint('⛔ Skipped update; existing is newer or same');
      }
    } else {
      items.add(data);
      debugPrint('➕ Added new item');
    }

    await file.writeAsString(jsonEncode(items));
    debugPrint('📁 File saved: ${file.path}');
  }

  Future<Map<String, dynamic>?> _readOneFromFile(
      String table,
      String id,
      ) async {
    final file = await _getTableFile(table);
    if (!await file.exists()) return null;

    final content = await file.readAsString();
    if (content.isEmpty) return null;

    final List<Map<String, dynamic>> items = List<Map<String, dynamic>>.from(
      jsonDecode(content),
    );

    return items.firstWhere(
          (item) => item['id'] == id,
      orElse: () => {},
    );
  }

  Future<List<Map<String, dynamic>>> _readAllFromFile(String table) async {
    final file = await _getTableFile(table);
    if (!await file.exists()) return [];
    final content = await file.readAsString();
    if (content.isEmpty) return [];
    return List<Map<String, dynamic>>.from(jsonDecode(content));
  }

  Future<File> _getTableFile(String table) async {
    final dir = await SyncStorageManager.getSyncDirectory();
    return File('${dir.path}/$table.json');
  }

  Future<void> _deleteFromFile(String table, String id) async {
    final file = await _getTableFile(table);
    if (!await file.exists()) return;

    final content = await file.readAsString();
    if (content.isEmpty) return;

    List<Map<String, dynamic>> items = List<Map<String, dynamic>>.from(
      jsonDecode(content),
    );
    items.removeWhere((item) => item['id'] == id);
    await file.writeAsString(jsonEncode(items));
  }
}
