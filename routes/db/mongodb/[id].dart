import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:task_list_backend/lists/list_repository.dart';
import 'package:task_list_backend/model/error_model.dart';

/*----------------------------------------
 Command to generate middleware
[dart_frog new route "/db/mongodb/[id]"]
 ----------------------------------------*/

Future<Response> onRequest(
  RequestContext context,
  String id,
) async {
  return switch (context.request.method) {
    HttpMethod.patch => _updateList(context, id),
    HttpMethod.delete => _deleteList(context, id),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed))
  };
}

Future<Response> _updateList(RequestContext context, String id) async {
  ResponseModel responseModel;

  /// get body coming from user and save it as Map<String, dynamic>
  final body = await context.request.json() as Map<String, dynamic>;
  final name = body['name'] as String;

  final task = TaskList(id: id, name: name);

  /// update data to Mongodb
  try {
    final query = where.eq('id', task.id);
    final update = {r'$set': task.toJson()};

    final result = await context.read<Db>().collection('lists').updateOne(
          query,
          update,
        );

    if (result.nModified > 0) {
      responseModel = ResponseModel(
        statusCode: HttpStatus.created,
        success: true,
        data: task.toJson(),
      );
    } else {
      responseModel = ResponseModel(
        statusCode: HttpStatus.notAcceptable,
        errorModel: ['List not updated !'],
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

Future<Response> _deleteList(RequestContext context, String id) async {
  ResponseModel responseModel;
  final query = where.eq('id', id);

  /// add document against id
  try {
    final result =
        await context.read<Db>().collection('lists').deleteOne(query);

    if (result.nRemoved > 0) {
      responseModel = ResponseModel(
        statusCode: HttpStatus.noContent,
        success: true,
        data: 'document against id: $id has been deleted successfully',
      );
    } else {
      responseModel = ResponseModel(
        statusCode: HttpStatus.notAcceptable,
        errorModel: ['List not deleted !'],
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
