// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medicine_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MedicineModel _$MedicineModelFromJson(Map<String, dynamic> json) {
  return _MedicineModel.fromJson(json);
}

/// @nodoc
mixin _$MedicineModel {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get name => throw _privateConstructorUsedError;
  @HiveField(2)
  int get quentity => throw _privateConstructorUsedError;
  @HiveField(3)
  String get packaging => throw _privateConstructorUsedError;
  @HiveField(4)
  double get mrp => throw _privateConstructorUsedError;
  @HiveField(5)
  double get pp => throw _privateConstructorUsedError;
  @HiveField(6)
  String? get imagePath => throw _privateConstructorUsedError;
  @HiveField(7)
  DateTime get lastUpdated => throw _privateConstructorUsedError;

  /// Serializes this MedicineModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MedicineModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MedicineModelCopyWith<MedicineModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MedicineModelCopyWith<$Res> {
  factory $MedicineModelCopyWith(
          MedicineModel value, $Res Function(MedicineModel) then) =
      _$MedicineModelCopyWithImpl<$Res, MedicineModel>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String name,
      @HiveField(2) int quentity,
      @HiveField(3) String packaging,
      @HiveField(4) double mrp,
      @HiveField(5) double pp,
      @HiveField(6) String? imagePath,
      @HiveField(7) DateTime lastUpdated});
}

/// @nodoc
class _$MedicineModelCopyWithImpl<$Res, $Val extends MedicineModel>
    implements $MedicineModelCopyWith<$Res> {
  _$MedicineModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MedicineModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? quentity = null,
    Object? packaging = null,
    Object? mrp = null,
    Object? pp = null,
    Object? imagePath = freezed,
    Object? lastUpdated = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      quentity: null == quentity
          ? _value.quentity
          : quentity // ignore: cast_nullable_to_non_nullable
              as int,
      packaging: null == packaging
          ? _value.packaging
          : packaging // ignore: cast_nullable_to_non_nullable
              as String,
      mrp: null == mrp
          ? _value.mrp
          : mrp // ignore: cast_nullable_to_non_nullable
              as double,
      pp: null == pp
          ? _value.pp
          : pp // ignore: cast_nullable_to_non_nullable
              as double,
      imagePath: freezed == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MedicineModelImplCopyWith<$Res>
    implements $MedicineModelCopyWith<$Res> {
  factory _$$MedicineModelImplCopyWith(
          _$MedicineModelImpl value, $Res Function(_$MedicineModelImpl) then) =
      __$$MedicineModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String name,
      @HiveField(2) int quentity,
      @HiveField(3) String packaging,
      @HiveField(4) double mrp,
      @HiveField(5) double pp,
      @HiveField(6) String? imagePath,
      @HiveField(7) DateTime lastUpdated});
}

/// @nodoc
class __$$MedicineModelImplCopyWithImpl<$Res>
    extends _$MedicineModelCopyWithImpl<$Res, _$MedicineModelImpl>
    implements _$$MedicineModelImplCopyWith<$Res> {
  __$$MedicineModelImplCopyWithImpl(
      _$MedicineModelImpl _value, $Res Function(_$MedicineModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of MedicineModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? quentity = null,
    Object? packaging = null,
    Object? mrp = null,
    Object? pp = null,
    Object? imagePath = freezed,
    Object? lastUpdated = null,
  }) {
    return _then(_$MedicineModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      quentity: null == quentity
          ? _value.quentity
          : quentity // ignore: cast_nullable_to_non_nullable
              as int,
      packaging: null == packaging
          ? _value.packaging
          : packaging // ignore: cast_nullable_to_non_nullable
              as String,
      mrp: null == mrp
          ? _value.mrp
          : mrp // ignore: cast_nullable_to_non_nullable
              as double,
      pp: null == pp
          ? _value.pp
          : pp // ignore: cast_nullable_to_non_nullable
              as double,
      imagePath: freezed == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MedicineModelImpl implements _MedicineModel {
  const _$MedicineModelImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.name,
      @HiveField(2) required this.quentity,
      @HiveField(3) required this.packaging,
      @HiveField(4) required this.mrp,
      @HiveField(5) required this.pp,
      @HiveField(6) required this.imagePath,
      @HiveField(7) required this.lastUpdated});

  factory _$MedicineModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MedicineModelImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String name;
  @override
  @HiveField(2)
  final int quentity;
  @override
  @HiveField(3)
  final String packaging;
  @override
  @HiveField(4)
  final double mrp;
  @override
  @HiveField(5)
  final double pp;
  @override
  @HiveField(6)
  final String? imagePath;
  @override
  @HiveField(7)
  final DateTime lastUpdated;

  @override
  String toString() {
    return 'MedicineModel(id: $id, name: $name, quentity: $quentity, packaging: $packaging, mrp: $mrp, pp: $pp, imagePath: $imagePath, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MedicineModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.quentity, quentity) ||
                other.quentity == quentity) &&
            (identical(other.packaging, packaging) ||
                other.packaging == packaging) &&
            (identical(other.mrp, mrp) || other.mrp == mrp) &&
            (identical(other.pp, pp) || other.pp == pp) &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, quentity, packaging,
      mrp, pp, imagePath, lastUpdated);

  /// Create a copy of MedicineModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MedicineModelImplCopyWith<_$MedicineModelImpl> get copyWith =>
      __$$MedicineModelImplCopyWithImpl<_$MedicineModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MedicineModelImplToJson(
      this,
    );
  }
}

abstract class _MedicineModel implements MedicineModel {
  const factory _MedicineModel(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String name,
      @HiveField(2) required final int quentity,
      @HiveField(3) required final String packaging,
      @HiveField(4) required final double mrp,
      @HiveField(5) required final double pp,
      @HiveField(6) required final String? imagePath,
      @HiveField(7) required final DateTime lastUpdated}) = _$MedicineModelImpl;

  factory _MedicineModel.fromJson(Map<String, dynamic> json) =
      _$MedicineModelImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get name;
  @override
  @HiveField(2)
  int get quentity;
  @override
  @HiveField(3)
  String get packaging;
  @override
  @HiveField(4)
  double get mrp;
  @override
  @HiveField(5)
  double get pp;
  @override
  @HiveField(6)
  String? get imagePath;
  @override
  @HiveField(7)
  DateTime get lastUpdated;

  /// Create a copy of MedicineModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MedicineModelImplCopyWith<_$MedicineModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
