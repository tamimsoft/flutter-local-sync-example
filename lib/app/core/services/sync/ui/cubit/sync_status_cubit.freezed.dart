// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_status_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SyncStatusState {
  SyncStatus get status => throw _privateConstructorUsedError;

  /// Create a copy of SyncStatusState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SyncStatusStateCopyWith<SyncStatusState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncStatusStateCopyWith<$Res> {
  factory $SyncStatusStateCopyWith(
          SyncStatusState value, $Res Function(SyncStatusState) then) =
      _$SyncStatusStateCopyWithImpl<$Res, SyncStatusState>;
  @useResult
  $Res call({SyncStatus status});
}

/// @nodoc
class _$SyncStatusStateCopyWithImpl<$Res, $Val extends SyncStatusState>
    implements $SyncStatusStateCopyWith<$Res> {
  _$SyncStatusStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SyncStatusState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SyncStatus,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SyncStatusStateImplCopyWith<$Res>
    implements $SyncStatusStateCopyWith<$Res> {
  factory _$$SyncStatusStateImplCopyWith(_$SyncStatusStateImpl value,
          $Res Function(_$SyncStatusStateImpl) then) =
      __$$SyncStatusStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({SyncStatus status});
}

/// @nodoc
class __$$SyncStatusStateImplCopyWithImpl<$Res>
    extends _$SyncStatusStateCopyWithImpl<$Res, _$SyncStatusStateImpl>
    implements _$$SyncStatusStateImplCopyWith<$Res> {
  __$$SyncStatusStateImplCopyWithImpl(
      _$SyncStatusStateImpl _value, $Res Function(_$SyncStatusStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of SyncStatusState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
  }) {
    return _then(_$SyncStatusStateImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SyncStatus,
    ));
  }
}

/// @nodoc

class _$SyncStatusStateImpl implements _SyncStatusState {
  const _$SyncStatusStateImpl({this.status = SyncStatus.idle});

  @override
  @JsonKey()
  final SyncStatus status;

  @override
  String toString() {
    return 'SyncStatusState(status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncStatusStateImpl &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status);

  /// Create a copy of SyncStatusState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncStatusStateImplCopyWith<_$SyncStatusStateImpl> get copyWith =>
      __$$SyncStatusStateImplCopyWithImpl<_$SyncStatusStateImpl>(
          this, _$identity);
}

abstract class _SyncStatusState implements SyncStatusState {
  const factory _SyncStatusState({final SyncStatus status}) =
      _$SyncStatusStateImpl;

  @override
  SyncStatus get status;

  /// Create a copy of SyncStatusState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncStatusStateImplCopyWith<_$SyncStatusStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
