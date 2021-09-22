import 'package:http/http.dart' as http;

import 'package:phone_number/phone_number.dart';

class BuyerData {
  late String? uid;
  late String displayName;
  late String address;
  late String? emailID;
   late String countryCode;
  late String? phoneNumber;
  late String password;

   BuyerData(
      {required this.uid,
      required this.displayName,
      required this.address,
      required this.countryCode,
      required this.emailID,
      required this.phoneNumber,
      required this.password});

      
   Map toMap(BuyerData buyer) {
    var data = Map<String, dynamic>();
    data['ownerUid'] = buyer.uid;
    data['display name'] = buyer.displayName;
    data['address'] = buyer.address;
    data['emailID'] = buyer.emailID;
    data['country code'] = buyer.countryCode;
    data['phone number'] = buyer.phoneNumber;
    data['password'] = buyer.password;
    return data;
  }

  BuyerData.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['ownerUid'];
    this.displayName = mapData['display name'];
    this.address = mapData['address'];
    this.emailID = mapData['emailID'];
    this.phoneNumber = mapData['phone number'];
    this.password = mapData['password'];
    this.countryCode = mapData['country code'];
  }

}


  doc(String? uid) {}


  

