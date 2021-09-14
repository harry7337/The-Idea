import 'package:bizgram/models/buyer.dart';
import 'package:bizgram/models/seller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdateBuyer {
  final user = FirebaseAuth.instance.currentUser;
  final buyer = FirebaseFirestore.instance.collection('buyers');
  final BuyerData buyers;
  UpdateBuyer({required this.buyers});

  Future update() async {
    buyers.doc(buyers.uid).set({
      'details': {
        'displayName': buyers.displayName,
        'address': buyers.address,
        'countryCode': buyers.countryCode,
        'contactNumber': buyers.phoneNumber,
        'emailID': buyers.emailID,
        'password':buyers.password,

      }
    });
  }}