



import 'package:dart_frog/dart_frog.dart';
import 'package:firedart/firestore/firestore.dart';

/*----------------------------------------
 Command to generate middleware
[dart_frog new middleware "/db/fire_base"]
 ----------------------------------------*/

Handler middleware(Handler handler) {
  return (context) async {
    if (!Firestore.initialized) {
      print('initializing firebase');
      Firestore.initialize('tasklist-dartfrog-4f93f');
    } else {
      print('already initialized firebase');
    }

    final response = await handler(context);
    return response;
  };
}
