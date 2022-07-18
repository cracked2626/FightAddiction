// get firebase instance
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
final storiesCollection = FirebaseFirestore.instance.collection('stories');
final usersCollection = FirebaseFirestore.instance.collection('users');
