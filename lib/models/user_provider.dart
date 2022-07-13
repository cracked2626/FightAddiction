import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class UserProvider with ChangeNotifier {
  String? id;
  String? name;
  String? imageUrl;
  String? email;

  UserProvider({
    this.id,
    this.name,
    this.imageUrl,
    this.email,
  });
  factory UserProvider.fromDocument(DocumentSnapshot doc) {
    return UserProvider(
      id: (doc.data() as Map)['id'],
      name: (doc.data() as Map)['name'],
      imageUrl: (doc.data() as Map)['photoUrl'],
      email: (doc.data() as Map)['email'],
    );
  }
  setData({DocumentSnapshot? doc}) {
    id = (doc?.data() as Map)['id'];
    name = (doc?.data() as Map)['name'];
    imageUrl = (doc?.data() as Map)['photoUrl'];
    email = (doc?.data() as Map)['email'];
    log('UserProvider.setData: $doc');
    notifyListeners();
  }
}
