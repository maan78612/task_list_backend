import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:task_list_backend/lists/list_repository.dart';
import 'package:task_list_backend/model/error_model.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => _getList(context),
    HttpMethod.post => _createList(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed))
  };
}

Future<Response> _getList(RequestContext context) async {
  final taskList = <TaskList>[];

  /// fetch list from DB
  final mapList = await context.read<Db>().collection('lists').find().toList();

  /// populate list of  TaskList
  for (final list in mapList) {
    taskList.add(TaskList.fromJson(list));
  }

  final responseModel = ResponseModel(
    statusCode: HttpStatus.created,
    success: true,
    data: taskList,
  );

  /// return response model as json
  return Response.json(
    body: responseModel.toJson(),
  );
}

Future<Response> _createList(RequestContext context) async {
   ResponseModel responseModel;

  /// get body coming from user and save it as Map<String, dynamic>
  final body = await context.request.json() as Map<String, dynamic>;
  final name = body['name'] as String;
  final id = DateTime.now().millisecondsSinceEpoch.toString();
  final task = TaskList(id: id, name: name);

  /// add data to Mongodb
  try {
    final result =
        await context.read<Db>().collection('lists').insertOne(task.toJson());
    if (!result.isSuccess) {
      responseModel = ResponseModel(
        statusCode: HttpStatus.created,
        success: true,
        data: task.toJson(),
      );
    } else {
      responseModel = ResponseModel(
        statusCode: HttpStatus.notAcceptable,
        errorModel: ['Item not created !'],
      );
    }
  } catch (e) {
    responseModel = ResponseModel(
      statusCode: HttpStatus.badRequest,
      errorModel: ['Unknown error occurred'],
    );
  }

  return Response.json(body: responseModel.toJson());
}
