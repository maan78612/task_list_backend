import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context) {
  /*---------- dependencies injection ------------------*/
  final value = context.read<String>();
  return Response(body: value);
}
