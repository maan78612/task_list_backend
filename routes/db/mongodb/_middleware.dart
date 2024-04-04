import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';

///  Command to generate middleware
/// dart_frog new middleware "/db/mongoDb"

Handler middleware(Handler handler) {
  return (context) async {
    final myDatabase = await Db.create(
      /// default URL
      /* mongodb+srv://<username>:<password>@cluster0.7nwhkzw.mongodb.net/<database name>?retryWrites=true&w=majority&appName=Cluster0 */
      'mongodb+srv://dart_user:burnout123@cluster0.7nwhkzw.mongodb.net/TaskListDfrog?retryWrites=true&w=majority&appName=TaskListDfrog',
    );
    if (!myDatabase.isConnected) {
      print('mongodb connected');
      await myDatabase.open();
    } else {
      print('mongodb NOT connected');
    }

    /// syntax to initialize DB variable and send them to routes
    final response =
        await handler.use(provider<Db>((_) => myDatabase)).call(context);

    await myDatabase.close();
    return response;
  };
}
