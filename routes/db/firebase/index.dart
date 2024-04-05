import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:task_list_backend/constants/fire_base/firebase_collections.dart';
import 'package:task_list_backend/lists/list_repository.dart';
import 'package:task_list_backend/model/error_model.dart';


/*----------------------------------------
  Command to generate middleware
  [ dart_frog new route "/db/firebase""]
 ----------------------------------------*/


Future<Response> onRequest(RequestContext context) {
  return switch (context.request.method) {
    HttpMethod.get => _getLists(context),
    HttpMethod.post => _createList(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed))
  };
}

Future<Response> _getLists(RequestContext context) async {
  ResponseModel responseModel;
  final list = <TaskList>[];

  await FBCollections.taskList.get().then((event) {
    for (final doc in event) {
      list.add(TaskList.fromJson(doc.map));
    }
  });

  /// create response model
  responseModel = ResponseModel(
    statusCode: HttpStatus.accepted,
    success: true,
    data: list,
  );
  /// return response model as json
  return Response.json(
    statusCode: HttpStatus.accepted,
    body: responseModel.toJson(),
  );
}

Future<Response> _createList(RequestContext context) async {
  /// get body coming from user and save it as Map<String, dynamic>
  final body = await context.request.json() as Map<String, dynamic>;
  final name = body['name'] as String;
  final id = DateTime.now().millisecondsSinceEpoch.toString();
  final task = TaskList(id: id, name: name);

  /// add data to Firebase
  await FBCollections.taskList.document(task.id).set(task.toJson());

  final responseModel = ResponseModel(
    statusCode: HttpStatus.created,
    success: true,
    data: task.toJson(),
  );

  return Response.json(
    body: responseModel.toJson(),
    statusCode: HttpStatus.created,
  );
}
