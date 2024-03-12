
/*----------------------------------------
 Command to generate middleware
[dart_frog new middleware "/items"]
 ----------------------------------------*/

import 'package:dart_frog/dart_frog.dart';


Handler middleware(Handler handler) {
  return handler.use(requestLogger()).use(
        provider<String>((context) => 'This is a new route for items!'),
      );
}
