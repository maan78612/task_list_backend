// GENERATED CODE - DO NOT MODIFY BY HAND
// to generate this file run command after making model class
// [dart run build_runner build]
//package name: json_serializable: ^6.7.1

part of 'list_repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskList _$TaskListFromJson(Map<String, dynamic> json) => TaskList(
      id: json['id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$TaskListToJson(TaskList instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
