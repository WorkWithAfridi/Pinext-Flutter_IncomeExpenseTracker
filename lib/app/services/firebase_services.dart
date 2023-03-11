import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseServices {
  factory FirebaseServices() => _firebaseServices;

  FirebaseServices._internal();
  static final FirebaseServices _firebaseServices = FirebaseServices._internal();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  String getUserId() => firebaseAuth.currentUser!.uid;
}
