import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:task_list_backend/hash_extension.dart';

part 'list_repository.g.dart';

/// Data source in memory-cache
Map<String, TaskList> listDb = {};

/// Task list class extends with Equatable [ way of determining ig 2 objects
/// of same type sre equal based on their content (id and name)
///  for example if we want to compare 2 objects in memory cache it is easy
///  because Equatable compare content inside]

@JsonSerializable()
class TaskList extends Equatable {
  /// constructor
  const TaskList({required this.id, required this.name});

  /// deserialization
  factory TaskList.fromJson(Map<String, dynamic> json) =>
      _$TaskListFromJson(json);

  ///copy with method
  TaskList copyWith({String? id, String? name}) {
    return TaskList(id: id ?? this.id, name: name ?? this.name);
  }

  /// List's id
  final String id;

  ///List's name
  final String name;

  /// Serialization
  Map<String, dynamic> toJson() => _$TaskListToJson(this);

  @override
  /*------- this method require variables with we want to compare --------*/
  List<Object?> get props => [id, name]; // this function comes with Equatable
}

/// repository class for task list
class TaskListRepository {
  /// check in the internal data-source for a list with given id
  Future<TaskList?> listById(String id) async {
    return listById(id);
  }

  /// Get all list from data-source
  Map<String, dynamic> getAllLists() {
    final formattedList = <String, dynamic>{};
    if (listDb.isNotEmpty) {
      listDb.forEach(
        (String id) {
          final currentList = listDb[id];
          formattedList[id] = currentList?.toJson();
        } as void Function(String key, TaskList value),
      );
    }
    return formattedList;
  }

  /// create new list with given [name]
  String createList({required String name}) {
    /// its dynamically generates the id
    final id = name.hashValue;

    /// create new task list object and pass two parameters

    final list = TaskList(id: id, name: name);
    listDb[id] = list;

    return id;
  }

  /// Delete task list object with given [id]
  void deleteList(String id) {
    listDb.remove(id);
  }

  /// update task list
  Future<void> updateList({required String id, required String name}) async {
    final currentList = listDb[id];

    if (currentList == null) {
      return Future.error(Exception('List not found'));
    }

    listDb[id] = TaskList(id: id, name: name);
  }
}
