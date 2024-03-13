// GENERATED CODE - DO NOT MODIFY BY HAND

// to generate this file run command after making model class
// [dart run build_runner build]
//package name: json_serializable: ^6.7.1

part of 'items_repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskItem _$TaskItemFromJson(Map<String, dynamic> json) => TaskItem(
      id: json['id'] as String,
      name: json['name'] as String,
      listId: json['listId'] as String,
      description: json['description'] as String,
      status: json['status'] as bool,
    );

Map<String, dynamic> _$TaskItemToJson(TaskItem instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'listId': instance.listId,
      'description': instance.description,
      'status': instance.status,
    };
