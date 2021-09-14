import 'package:http/http.dart' as http;

import 'package:phone_number/phone_number.dart';

class BuyerData {
  final String? uid;
  final String displayName;
  final String address;
  final String? emailID;
  final String countryCode;
  final String? phoneNumber;
  final String password;

  const BuyerData(
      {required this.uid,
      required this.displayName,
      required this.address,
      required this.countryCode,
      required this.emailID,
      required this.phoneNumber,
      required this.password});

  doc(String? uid) {}


  }

