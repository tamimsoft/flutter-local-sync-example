import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'sync_status_state.dart';
part 'sync_status_cubit.freezed.dart';

/// Manages the synchronization status state for the application.
/// Provides methods to update the sync state in the UI layer.
@lazySingleton
class SyncStatusCubit extends Cubit<SyncStatusState> {
  /// Initializes the cubit with the default [SyncStatusState].
  SyncStatusCubit() : super(SyncStatusState());

  /// Sets the sync status to [SyncStatus.offline].
  void setOffline() => emit(state.copyWith(status: SyncStatus.offline));

  /// Sets the sync status to [SyncStatus.syncing].
  void setSyncing() => emit(state.copyWith(status: SyncStatus.syncing));

  /// Sets the sync status to [SyncStatus.synced].
  void setSynced() => emit(state.copyWith(status: SyncStatus.synced));

  /// Sets the sync status to [SyncStatus.idle].
  void setIdle() => emit(state.copyWith(status: SyncStatus.idle));

  /// Sets the sync status to [SyncStatus.error].
  void setError() => emit(state.copyWith(status: SyncStatus.error));
}
