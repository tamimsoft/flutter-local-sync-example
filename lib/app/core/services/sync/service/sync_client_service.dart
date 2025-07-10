import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '/app/core/exception/sync_service_exception.dart';

/// A service class for handling synchronization operations with a remote server.
///
/// This class provides methods to perform push, pull, and delete operations over a socket connection,
/// with built-in retry logic and timeout handling. It is designed to be robust against transient failures.
// class SyncClientService {
//   /// The server address to connect to.
//   final InternetAddress address;

//   /// The port number on the server to connect to.
//   final int port;

//   /// Timeout duration for establishing a connection to the server.
//   final Duration connectionTimeout;

//   /// Timeout duration for individual operations after the connection is established.
//   final Duration operationTimeout;

//   /// Creates a new instance of [SyncClientService].
//   ///
//   /// [address] and [port] are required parameters.
//   /// Optional [connectionTimeout] defaults to 10 seconds.
//   /// Optional [operationTimeout] defaults to 5 seconds.
//   SyncClientService({
//     required this.address,
//     required this.port,
//     this.connectionTimeout = const Duration(seconds: 10),
//     this.operationTimeout = const Duration(seconds: 5),
//   });

//   /// Pushes data to the specified table on the server.
//   ///
//   /// [table] is the name of the target table.
//   /// [data] is the map of key-value pairs to be sent.
//   Future<void> push(String table, Map<String, dynamic> data) async {
//     await _executeWithRetry('PUSH', table, {
//       'type': 'PUSH',
//       'table': table,
//       'data': data,
//     });
//   }

//   Future<Map<String, dynamic>> pullOne({
//     required String table,
//     required String id,
//   }) async {
//     final response = await _executeWithRetry('PULL_ONE', table, {
//       'type': 'PULL_ONE',
//       'table': table,
//       'id': id,
//     });

//     return response['data'] as Map<String, dynamic>;
//   }

//   /// Pulls data from the specified table on the server.
//   ///
//   /// [table] is the name of the source table.
//   /// Returns a list of maps representing the retrieved data.
//   Future<List<Map<String, dynamic>>> pull(String table) async {
//     final response = await _executeWithRetry('PULL', table, {
//       'type': 'PULL',
//       'table': table,
//     });
//     return List<Map<String, dynamic>>.from(response['data'] as List);
//   }

//   /// Deletes an item by ID from the specified table on the server.
//   ///
//   /// [table] is the name of the target table.
//   /// [id] is the identifier of the item to delete.
//   Future<void> delete(String table, String id) async {
//     await _executeWithRetry('DELETE', table, {
//       'type': 'DELETE',
//       'table': table,
//       'id': id,
//     });
//   }

//   /// Executes a given operation with retry logic in case of failure.
//   ///
//   /// [operation] is the type of operation (e.g., PUSH, PULL, DELETE).
//   /// [table] is the name of the affected table.
//   /// [request] is the request data to send.
//   /// Returns a future that completes with the result of the operation.
//   Future<Map<String, dynamic>> _executeWithRetry(
//     String operation,
//     String table,
//     Map<String, dynamic> request,
//   ) async {
//     int attempt = 0;
//     int maxAttempts = 3;
//     SyncServiceException? lastError;

//     while (attempt < maxAttempts) {
//       attempt++;
//       try {
//         return await _executeOperation(operation, table, request);
//       } catch (e) {
//         debugPrint(
//           'Attempt $attempt failed for $operation on $table: ${e.toString()}',
//         );
//         if (attempt < maxAttempts) {
//           await Future.delayed(const Duration(milliseconds: 500));
//         }
//       }
//     }

//     debugPrint('All $attempt attempts failed for $operation on $table');
//     throw lastError ?? SyncServiceException('Unknown error occurred');
//   }

//   /// Executes a single operation over a socket connection.
//   ///
//   /// [operation] is the type of operation (e.g., PUSH, PULL, DELETE).
//   /// [table] is the name of the affected table.
//   /// [request] is the request data to send.
//   /// Returns a future that completes with the server's response.
//   Future<Map<String, dynamic>> _executeOperation(
//     String operation,
//     String table,
//     Map<String, dynamic> request,
//   ) async {
//     Socket? socket;
//     try {
//       socket = await Socket.connect(address, port)
//           .timeout(connectionTimeout)
//           .catchError((e) {
//             throw SyncTimeoutException('Connection timeout: ${e.toString()}');
//           });
//
//       final completer = Completer<Map<String, dynamic>>();
//       final buffer = StringBuffer();
//
//       socket.listen(
//         (data) {
//           buffer.write(utf8.decode(data));
//         },
//         onError: (error) {
//           if (!completer.isCompleted) {
//             completer.completeError(
//               SyncServiceException('Socket error: ${error.toString()}'),
//             );
//           }
//         },
//         onDone: () {
//           if (!completer.isCompleted) {
//             final rawResponse = buffer.toString().trim();
//             debugPrint('📥 Raw socket response: $rawResponse');
//
//             if (rawResponse.isEmpty) {
//               completer.completeError(
//                 SyncServiceException('Empty response from server.'),
//               );
//               return;
//             }
//
//             try {
//               final response = jsonDecode(rawResponse) as Map<String, dynamic>;
//               if (response.containsKey('error')) {
//                 completer.completeError(
//                   SyncServiceException(response['error'] as String),
//                 );
//               } else {
//                 completer.complete(response);
//               }
//             } catch (e) {
//               completer.completeError(
//                 SyncServiceException(
//                   'Invalid response format: ${e.toString()}',
//                 ),
//               );
//             }
//           }
//         },
//         cancelOnError: true,
//       );
//
//       socket.write(jsonEncode(request));
//       await socket.flush();
//       debugPrint('Sent $operation request for $table');
//
//       final response = await completer.future.timeout(operationTimeout);
//       debugPrint('$operation successful for $table');
//       return response;
//     } on TimeoutException catch (e) {
//       throw SyncTimeoutException('Operation timeout: ${e.message}');
//     } on SocketException catch (e) {
//       throw SyncServiceException('Connection failed: ${e.message}');
//     } catch (e) {
//       throw SyncServiceException('Operation failed: ${e.toString()}');
//     } finally {
//       await socket?.close();
//     }
//   }
// }

class SyncClientService {
  final InternetAddress address;
  final int port;
  WebSocket? _socket;
  SyncClientService({required this.address, required this.port});
  // final _streamController = StreamController<Map<String, dynamic>>();
  final _streamController = StreamController<Map<String, dynamic>>.broadcast();

  Future<void> connect() async {
    final uri = Uri.parse('ws://${address.address}:$port');
    _socket = await WebSocket.connect(uri.toString());
    _socket!.listen(
      (data) {
        final message = jsonDecode(data);
        _streamController.add(message);
      },
      onError: (e) {
        debugPrint('Client error: $e');
      },
      onDone: () {
        debugPrint('WebSocket closed by server');
      },
    );
  }

  Stream<Map<String, dynamic>> get messages => _streamController.stream;

  Future<void> push(String table, Map<String, dynamic> data) async {
    await _sendRequest({'type': 'PUSH', 'table': table, 'data': data});
  }

  Future<List<Map<String, dynamic>>> pull(String table) async {
    final response = await _sendRequest({'type': 'PULL', 'table': table});
    return List<Map<String, dynamic>>.from(response['data']);
  }

  Future<Map<String, dynamic>> pullOne({
    required String table,
    required String id,
  }) async {
    final response = await _sendRequest({
      'type': 'PULL_ONE',
      'table': table,
      'id': id,
    });
    return Map<String, dynamic>.from(response['data']);
  }

  Future<void> delete(String table, String id) async {
    await _sendRequest({'type': 'DELETE', 'table': table, 'id': id});
  }

  Future<Map<String, dynamic>> _sendRequest(Map<String, dynamic> request) async {
    final completer = Completer<Map<String, dynamic>>();
    late StreamSubscription sub;

    final requestId = const Uuid().v4();
    request['requestId'] = requestId;

    sub = _streamController.stream.listen((event) {
      if (event['requestId'] == requestId) {
        sub.cancel();
        if (event.containsKey('error')) {
          completer.completeError(SyncServiceException(event['error']));
        } else {
          completer.complete(event);
        }
      }
    });

    _socket?.add(jsonEncode(request));
    return completer.future.timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        sub.cancel(); // Always cancel the subscription on timeout
        throw SyncTimeoutException('No response from server');
      },
    );
  }

  void dispose() {
    _socket?.close();
    _streamController.close();
  }
}
