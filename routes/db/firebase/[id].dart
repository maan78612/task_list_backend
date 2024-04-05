import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:task_list_backend/constants/fire_base/firebase_collections.dart';
import 'package:task_list_backend/model/error_model.dart';

/*----------------------------------------
 Command to generate middleware
[dart_frog new route "/db/firebase/[id]"]
 ----------------------------------------*/

Future<Response> onRequest(
  RequestContext context,
  String id,
) {
  return switch (context.request.method) {
    HttpMethod.patch => _updateList(context, id),
    HttpMethod.delete => _deleteList(context, id),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed))
  };
}

Future<Response> _updateList(RequestContext context, String id) async {
  ResponseModel responseModel;
  final body = await context.request.json();
  final name = body['name'];

  await FBCollections.taskList.document(id).update({'name': name});
  responseModel = ResponseModel(
    statusCode: HttpStatus.accepted,
    success: true,
  );
  return Response.json(
    statusCode: HttpStatus.accepted,
    body: responseModel.toJson(),
  );
}

Future<Response> _deleteList(RequestContext context, String id) async {
  ResponseModel responseModel;
  try {
    final isExist = await FBCollections.taskList.document(id).exists;

    if (isExist) {
      await FBCollections.taskList.document(id).delete();
      responseModel = ResponseModel(
        statusCode: HttpStatus.accepted,
        success: true,
        data: 'success',
      );
    } else {
      responseModel = ResponseModel(
        statusCode: HttpStatus.notFound,
        errorModel: ['Item not found !'],
      );
    }
  } catch (error) {
    responseModel = ResponseModel(
      statusCode: HttpStatus.badRequest,
      errorModel: ['Unknown Error!'],
    );
  }
  return Response.json(
    statusCode: HttpStatus.badRequest,
    body: responseModel.toJson(),
  );
}
