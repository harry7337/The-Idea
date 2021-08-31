import 'package:bizgram/models/seller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdateDoc {
  final user = FirebaseAuth.instance.currentUser;
  final sellers = FirebaseFirestore.instance.collection('sellers');
  final Seller seller;
  UpdateDoc({required this.seller});

  Future update() async {
    sellers.doc(seller.uid).set({
      'details': {
        'displayName': seller.displayName,
        'address': seller.address,
        'panNumber': seller.panNumber,
        'countryCode': seller.countryCode,
        'aadharImagePath': "${seller.aadhar.toString()}.jpg",
        'contactNumber': seller.phoneNumber,
        'productImagePath': "${seller.productPic.toString()}.jpg",
        'worldwide': seller.worldwide,
        'cod': seller.COD,
      }
    });
  }
  /*
  Future updateDoc(DateTime selectedDate) async {
    final events = firestore.collection('events');
    events.doc('${eventNo}_available_slots').update(
      {
        '${DateFormat.yMMMd().format(selectedDate)}': {
          'slot_1': {
            'start_time': Timestamp.fromDate(
              DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
                  9, 0, 0),
            ),
            'end_time': Timestamp.fromDate(
              DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
                  10, 0, 0),
            ),
            'booking_status': false,
            'price': 100.0,
          },
          'slot_2': {
            'start_time': Timestamp.fromDate(
              DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
                  10, 0, 0),
            ),
            'end_time': Timestamp.fromDate(
              DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
                  11, 0, 0),
            ),
            'booking_status': false,
            'price': 100.0,
          },
          'slot_3': {
            'start_time': Timestamp.fromDate(
              DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
                  15, 0, 0),
            ),
            'end_time': Timestamp.fromDate(
              DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
                  16, 0, 0),
            ),
            'booking_status': false,
            'price': 100.0,
          },
          'slot_4': {
            'start_time': Timestamp.fromDate(
              DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
                  16, 0, 0),
            ),
            'end_time': Timestamp.fromDate(
              DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
                  17, 0, 0),
            ),
            'booking_status': false,
            'price': 100.0,
          },
          'slot_5': {
            'start_time': Timestamp.fromDate(
              DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
                  17, 0, 0),
            ),
            'end_time': Timestamp.fromDate(
              DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
                  18, 0, 0),
            ),
            'booking_status': false,
            'price': 100.0,
          },
        },
      },
    );
  }
  */
}
