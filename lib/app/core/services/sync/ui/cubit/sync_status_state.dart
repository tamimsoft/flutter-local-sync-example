part of 'sync_status_cubit.dart';

enum SyncStatus { idle, offline, syncing, synced, error }

@freezed
class SyncStatusState with _$SyncStatusState {
  const factory SyncStatusState({@Default(SyncStatus.idle) SyncStatus status}) =
      _SyncStatusState;
}
