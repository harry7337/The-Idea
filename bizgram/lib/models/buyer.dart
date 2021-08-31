import 'package:http/http.dart' as http;

import 'package:phone_number/phone_number.dart';

class BuyerData {
  final String uid;
  final String displayName;
  final String address;
  final String emailID;
  final String countryCode;
  final PhoneNumber phoneNumber;
  final String password;

  const BuyerData(
      {required this.uid,
      required this.displayName,
      required this.address,
      required this.countryCode,
      required this.emailID,
      required this.phoneNumber,
      required this.password});

  factory BuyerData.fromJson(Map<String, dynamic> json) {
    return BuyerData(
        uid: json['UID'].toString(),
        displayName: json['DisplayName'].toString(),
        address: json['addressName'].toString(),
        countryCode: json['CountryCode'].toString(),
        emailID: json['emailId'],
        phoneNumber: json['phoneNumber'],
        password: json['password']);
  }
}
