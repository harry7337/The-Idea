import 'package:bizgram/models/person.dart';
import 'package:bizgram/models/seller.dart';

class Buyer extends Person {
  final String _shipAddress;
  List<Seller> following = [];
  Buyer(String name, String phNo, String email, String userName,
      this._shipAddress)
      : super(name, phNo, email, userName);

  String getShipAddress() {
    return this._shipAddress;
  }

  List<Seller> getFollowing() {
    return this.following;
  }

  int getFollowingCount() {
    return this.following.length;
  }
}
