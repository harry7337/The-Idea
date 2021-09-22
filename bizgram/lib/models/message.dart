import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {

  late String? senderUid ;
  late String? receiverUid;
  late String? type;
  late String? message;
  late FieldValue? timestamp;
  late String? photoUrl;

  Message({ this.senderUid, this.receiverUid, this.type,this.message, this.timestamp});
  Message.withoutMessage({required this.senderUid,required this.receiverUid,required this.type,required this.timestamp,required this.photoUrl});

  Map toMap() {
    var map = Map<String, dynamic>();
    map['senderUid'] = this.senderUid;
    map['receiverUid'] = this.receiverUid;
    map['type'] = this.type;
    map['message'] = this.message;
    map['timestamp'] = this.timestamp;
    return map;
  }

  Message fromMap(Map<String, dynamic> map) {
    Message _message = Message();
    _message.senderUid = map['senderUid'];
    _message.receiverUid = map['receiverUid'];
    _message.type = map['type'];
    _message.message = map['message'];
    _message.timestamp = map['timestamp'];
    return _message;
  }

  

}