import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:task_list_backend/hash_extension.dart';

part 'items_repository.g.dart';

/// Data source in memory-cache
Map<String, TaskItem> itemDb = {};

/// Task list class extends with Equatable [ way of determining ig 2 objects
/// of same type sre equal based on their content (id and name)
///  for example if we want to compare 2 objects in memory cache it is easy
///  because Equatable compare content inside]

@JsonSerializable()
class TaskItem extends Equatable {
  /// constructor
  const TaskItem({
    required this.id,
    required this.name,
    required this.listId,
    required this.description,
    required this.status,
  });

  /// deserialization
  factory TaskItem.fromJson(Map<String, dynamic> json) =>
      _$TaskItemFromJson(json);

  ///copy with method
  TaskItem copyWith({
    String? id,
    String? name,
    String? listId,
    String? description,
    bool? status,
  }) {
    return TaskItem(
      id: id ?? this.id,
      name: name ?? this.name,
      listId: listId ?? this.listId,
      description: description ?? this.description,
      status: status ?? this.status,
    );
  }

  /// item's id
  final String id;

  ///List's name
  final String name;

  /// List id where item belongs
  final String listId;

  /// item description
  final String description;

  /// item's status
  final bool status;

  /// Serialization
  Map<String, dynamic> toJson() => _$TaskItemToJson(this);

  @override
  /*------- this method require variables with we want to compare --------*/
  List<Object?> get props => [id, name]; // this function comes with Equatable
}

/// repository class for task list
class TaskItemRepository {
  /// check in the internal data-source for an item with given id
  Future<TaskItem?> itemById(String id) async {
    return itemById(id);
  }

  /// Get all items from data-source
  Map<String, dynamic> getAllItems() {
    final formattedItem = <String, dynamic>{};
    if (itemDb.isNotEmpty) {
      itemDb.forEach((String id) {
        final currentList = itemDb[id];
        formattedItem[id] = currentList?.toJson();
      } as void Function(String key, TaskItem value));
    }
    return formattedItem;
  }

  /// create new item with given information
  String createItem({
    required String name,
    required String listId,
    required String description,
    required bool status,
  }) {
    /// its dynamically generates the id
    final id = name.hashValue;

    /// create new task list object and pass All parameters

    final item = TaskItem(
      id: id,
      name: name,
      listId: listId,
      description: description,
      status: status,
    );
    itemDb[id] = item;

    return id;
  }

  /// Delete task item object with given [id]
  void deleteItem(String id) {
    itemDb.remove(id);
  }

  /// update task item
  Future<void> updateItem({
    required String id,
    required String name,
    required String listId,
    required String description,
    required bool status,
  }) async {
    final currentItem = itemDb[id];

    if (currentItem == null) {
      return Future.error(Exception('Item not found'));
    }

    itemDb[id] = TaskItem(
      id: id,
      name: name,
      listId: listId,
      description: description,
      status: status,
    );
  }
}
