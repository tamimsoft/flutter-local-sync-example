// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MedicineModelAdapter extends TypeAdapter<MedicineModel> {
  @override
  final int typeId = 0;

  @override
  MedicineModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MedicineModel(
      id: fields[0] as String,
      name: fields[1] as String,
      quentity: fields[2] as int,
      packaging: fields[3] as String,
      mrp: fields[4] as double,
      pp: fields[5] as double,
      imagePath: fields[6] as String?,
      lastUpdated: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, MedicineModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.quentity)
      ..writeByte(3)
      ..write(obj.packaging)
      ..writeByte(4)
      ..write(obj.mrp)
      ..writeByte(5)
      ..write(obj.pp)
      ..writeByte(6)
      ..write(obj.imagePath)
      ..writeByte(7)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicineModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MedicineModelImpl _$$MedicineModelImplFromJson(Map<String, dynamic> json) =>
    _$MedicineModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      quentity: (json['quentity'] as num).toInt(),
      packaging: json['packaging'] as String,
      mrp: (json['mrp'] as num).toDouble(),
      pp: (json['pp'] as num).toDouble(),
      imagePath: json['imagePath'] as String?,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$$MedicineModelImplToJson(_$MedicineModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'quentity': instance.quentity,
      'packaging': instance.packaging,
      'mrp': instance.mrp,
      'pp': instance.pp,
      'imagePath': instance.imagePath,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };
