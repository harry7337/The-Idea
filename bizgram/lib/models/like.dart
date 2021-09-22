import 'package:cloud_firestore/cloud_firestore.dart';

class Like {
  
  late String ownerName;
  late String ownerPhotoUrl;
  late String ownerUid;
  late FieldValue timeStamp;

  Like({required this.ownerName,required this.ownerPhotoUrl,required this.ownerUid,required this.timeStamp});

   Map toMap(Like like) {
    var data = Map<String, dynamic>();
    data['ownerName'] = like.ownerName;
    data['ownerPhotoUrl'] = like.ownerPhotoUrl;
    data['ownerUid'] = like.ownerUid;
    data['timestamp'] = like.timeStamp.toString();
    return data;
}

  Like.fromMap(Map<String, dynamic> mapData) {
    this.ownerName = mapData['ownerName'];
    this.ownerPhotoUrl = mapData['ownerPhotoUrl'];
    this.ownerUid = mapData['ownerUid'];
    this.timeStamp = mapData['timestamp'];
  }

}