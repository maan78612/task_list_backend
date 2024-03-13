

import 'package:firedart/firestore/firestore.dart';
import 'package:firedart/firestore/models.dart';

var db =  Firestore.instance;

class FBCollections {
  static CollectionReference taskList = db.collection("tasklists");


}
