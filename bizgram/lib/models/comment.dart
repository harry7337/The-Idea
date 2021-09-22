import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  
  late String ownerName;
  late String ownerPhotoUrl;
  late String comment;
  late FieldValue timeStamp;
  late String ownerUid;

  Comment({required this.ownerName,required this.ownerPhotoUrl,required this.comment,required this.timeStamp,required this.ownerUid});

   Map toMap(Comment comment) {
    var data = Map<String, dynamic>();
    data['ownerName'] = comment.ownerName;
    data['ownerPhotoUrl'] = comment.ownerPhotoUrl;
    data['comment'] = comment.comment;
    data['timestamp'] = comment.timeStamp;
    data['ownerUid'] = comment.ownerUid;
    return data;
}

  Comment.fromMap(Map<String, dynamic> mapData) {
    this.ownerName = mapData['ownerName'];
    this.ownerPhotoUrl = mapData['ownerPhotoUrl'];
    this.comment = mapData['comment'];
    this.timeStamp = mapData['timestamp'];
    this.ownerUid = mapData['ownerUid'];
  }

}