// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecipeModelAdapter extends TypeAdapter<RecipeModel> {
  @override
  final int typeId = 1;

  @override
  RecipeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecipeModel(
      id: fields[0] as String,
      title: fields[1] as String,
      banglaTitle: fields[2] as String,
      image: fields[3] as String,
      category: fields[4] as String,
      calories: fields[5] as int,
      time: fields[6] as int,
      ingredients: (fields[7] as List).cast<String>(),
      steps: (fields[8] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, RecipeModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.banglaTitle)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.calories)
      ..writeByte(6)
      ..write(obj.time)
      ..writeByte(7)
      ..write(obj.ingredients)
      ..writeByte(8)
      ..write(obj.steps);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
