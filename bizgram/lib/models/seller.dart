import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:phone_number/phone_number.dart';

class Seller {
  final String? uid;
  final String displayName;
  final String address;
  final String? emailID;
  final String countryCode;
  final String phoneNumber;
  final File? aadhar;
  final String panNumber;
  final List<File?> productPic;
  final bool worldwide;
  final bool COD;

  const Seller(
      {required this.uid,
      required this.displayName,
      required this.address,
      required this.countryCode,
      required this.emailID,
      required this.phoneNumber,
      required this.aadhar,
      required this.COD,
      required this.panNumber,
      required this.productPic,
      required this.worldwide});

  // factory SellerData.fromJson(Map<String, dynamic> json) {
  //   return SellerData(
  //       uid: json['UID'].toString(),
  //       displayName: json['DisplayName'].toString(),
  //       address: json['addressName'].toString(),
  //       countryCode: json['CountryCode'].toString(),
  //       emailID: json['emailId'],
  //       phoneNumber: json['phoneNumber'],
  //       COD: json['COD'],
  //       aadhar: json['aadhar'],
  //       panNumber: json['pan'],
  //       password: json['password'],
  //       productpic: json['productpic'],
  //       worldwide: json['worldwide']);
  // }
}
