// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TodoAdapter extends TypeAdapter<Todo> {
  @override
  final int typeId = 1;

  @override
  Todo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Todo(
      task: fields[0] as String,
      priority: fields[1] as Priority,
      dueDate: fields[2] as DateTime?,
      isCompleted: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Todo obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.task)
      ..writeByte(1)
      ..write(obj.priority)
      ..writeByte(2)
      ..write(obj.dueDate)
      ..writeByte(3)
      ..write(obj.isCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PriorityAdapter extends TypeAdapter<Priority> {
  @override
  final int typeId = 2;

  @override
  Priority read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Priority.none;
      case 1:
        return Priority.low;
      case 2:
        return Priority.medium;
      case 3:
        return Priority.high;
      default:
        return Priority.none;
    }
  }

  @override
  void write(BinaryWriter writer, Priority obj) {
    switch (obj) {
      case Priority.none:
        writer.writeByte(0);
        break;
      case Priority.low:
        writer.writeByte(1);
        break;
      case Priority.medium:
        writer.writeByte(2);
        break;
      case Priority.high:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PriorityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
