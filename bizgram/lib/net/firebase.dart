import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> buyerSetup(String displayName) async {
  CollectionReference buyers = FirebaseFirestore.instance.collection('Buyers');
  FirebaseAuth? auth = FirebaseAuth.instance;
  String? uid = "";
  uid = auth.currentUser!.uid.toString();
  
  buyers.add({'displayName': displayName, 'uid': uid});
  return;
}
