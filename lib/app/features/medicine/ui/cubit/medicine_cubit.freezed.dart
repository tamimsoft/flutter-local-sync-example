// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medicine_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MedicineState {
  /// List of available medicines.
  List<MedicineModel> get medicines => throw _privateConstructorUsedError;

  /// Current selected quantity of medicine.
  int get quantity => throw _privateConstructorUsedError;

  /// Available packaging options.
  List<PackagingType> get availablePackaging =>
      throw _privateConstructorUsedError;

  /// Indicates if data is currently being loaded.
  bool get isLoading => throw _privateConstructorUsedError;

  /// Optional error message in case of failure.
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of MedicineState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MedicineStateCopyWith<MedicineState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MedicineStateCopyWith<$Res> {
  factory $MedicineStateCopyWith(
          MedicineState value, $Res Function(MedicineState) then) =
      _$MedicineStateCopyWithImpl<$Res, MedicineState>;
  @useResult
  $Res call(
      {List<MedicineModel> medicines,
      int quantity,
      List<PackagingType> availablePackaging,
      bool isLoading,
      String? errorMessage});
}

/// @nodoc
class _$MedicineStateCopyWithImpl<$Res, $Val extends MedicineState>
    implements $MedicineStateCopyWith<$Res> {
  _$MedicineStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MedicineState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? medicines = null,
    Object? quantity = null,
    Object? availablePackaging = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      medicines: null == medicines
          ? _value.medicines
          : medicines // ignore: cast_nullable_to_non_nullable
              as List<MedicineModel>,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      availablePackaging: null == availablePackaging
          ? _value.availablePackaging
          : availablePackaging // ignore: cast_nullable_to_non_nullable
              as List<PackagingType>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MedicineStateImplCopyWith<$Res>
    implements $MedicineStateCopyWith<$Res> {
  factory _$$MedicineStateImplCopyWith(
          _$MedicineStateImpl value, $Res Function(_$MedicineStateImpl) then) =
      __$$MedicineStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<MedicineModel> medicines,
      int quantity,
      List<PackagingType> availablePackaging,
      bool isLoading,
      String? errorMessage});
}

/// @nodoc
class __$$MedicineStateImplCopyWithImpl<$Res>
    extends _$MedicineStateCopyWithImpl<$Res, _$MedicineStateImpl>
    implements _$$MedicineStateImplCopyWith<$Res> {
  __$$MedicineStateImplCopyWithImpl(
      _$MedicineStateImpl _value, $Res Function(_$MedicineStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of MedicineState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? medicines = null,
    Object? quantity = null,
    Object? availablePackaging = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$MedicineStateImpl(
      medicines: null == medicines
          ? _value._medicines
          : medicines // ignore: cast_nullable_to_non_nullable
              as List<MedicineModel>,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      availablePackaging: null == availablePackaging
          ? _value._availablePackaging
          : availablePackaging // ignore: cast_nullable_to_non_nullable
              as List<PackagingType>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$MedicineStateImpl implements _MedicineState {
  const _$MedicineStateImpl(
      {final List<MedicineModel> medicines = const [],
      this.quantity = 1,
      final List<PackagingType> availablePackaging = PackagingType.values,
      this.isLoading = false,
      this.errorMessage})
      : _medicines = medicines,
        _availablePackaging = availablePackaging;

  /// List of available medicines.
  final List<MedicineModel> _medicines;

  /// List of available medicines.
  @override
  @JsonKey()
  List<MedicineModel> get medicines {
    if (_medicines is EqualUnmodifiableListView) return _medicines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_medicines);
  }

  /// Current selected quantity of medicine.
  @override
  @JsonKey()
  final int quantity;

  /// Available packaging options.
  final List<PackagingType> _availablePackaging;

  /// Available packaging options.
  @override
  @JsonKey()
  List<PackagingType> get availablePackaging {
    if (_availablePackaging is EqualUnmodifiableListView)
      return _availablePackaging;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availablePackaging);
  }

  /// Indicates if data is currently being loaded.
  @override
  @JsonKey()
  final bool isLoading;

  /// Optional error message in case of failure.
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'MedicineState(medicines: $medicines, quantity: $quantity, availablePackaging: $availablePackaging, isLoading: $isLoading, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MedicineStateImpl &&
            const DeepCollectionEquality()
                .equals(other._medicines, _medicines) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            const DeepCollectionEquality()
                .equals(other._availablePackaging, _availablePackaging) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_medicines),
      quantity,
      const DeepCollectionEquality().hash(_availablePackaging),
      isLoading,
      errorMessage);

  /// Create a copy of MedicineState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MedicineStateImplCopyWith<_$MedicineStateImpl> get copyWith =>
      __$$MedicineStateImplCopyWithImpl<_$MedicineStateImpl>(this, _$identity);
}

abstract class _MedicineState implements MedicineState {
  const factory _MedicineState(
      {final List<MedicineModel> medicines,
      final int quantity,
      final List<PackagingType> availablePackaging,
      final bool isLoading,
      final String? errorMessage}) = _$MedicineStateImpl;

  /// List of available medicines.
  @override
  List<MedicineModel> get medicines;

  /// Current selected quantity of medicine.
  @override
  int get quantity;

  /// Available packaging options.
  @override
  List<PackagingType> get availablePackaging;

  /// Indicates if data is currently being loaded.
  @override
  bool get isLoading;

  /// Optional error message in case of failure.
  @override
  String? get errorMessage;

  /// Create a copy of MedicineState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MedicineStateImplCopyWith<_$MedicineStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
