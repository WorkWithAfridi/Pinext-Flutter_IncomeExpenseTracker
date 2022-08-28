import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseServices {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  FirebaseServices._internal();
  static final FirebaseServices _firebaseServices =
      FirebaseServices._internal();
  factory FirebaseServices() => _firebaseServices;

  getUserId() => firebaseAuth.currentUser!.uid;
}
