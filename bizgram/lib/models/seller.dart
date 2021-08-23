import 'package:flutter/material.dart';
import 'package:bizgram/models/person.dart';

import 'buyer.dart';

class Seller extends Person {
  final String enterpriceName;
  final String address;
  String bio = " ";
  List<String> productGenre = [];
  List<Buyer> followers = [];
  Map<String, Image> productPictures = {};

  Seller({
    required String name,
    required String phNo,
    required String email,
    required String userName,
    required this.enterpriceName,
    required this.address,
    required this.bio,
  }) : super(name, phNo, email, userName);

  String getAddress() {
    return this.address;
  }

  List<Buyer> getFollowers() {
    return this.followers;
  }

  int getFollowerCount() {
    return this.followers.length;
  }
}
