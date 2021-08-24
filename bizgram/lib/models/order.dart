import 'package:bizgram/models/buyer.dart';
import 'package:bizgram/models/seller.dart';

class Order {
  final String _id;
  final Seller _seller;
  final Buyer _buyer;
  final DateTime _issueDate;
  DateTime _deliveryDate = DateTime.now();
  DateTime _expectedDeliveryDate = DateTime.now();

  Order(this._id, this._seller, this._buyer, this._issueDate);
}
