

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yummy_tummy/model/user.dart';

class FeedModel {
  String key;
  String parentkey;
  String childRetwetkey;
  String description;
  String userId;
  int likeCount;
  List<LikeList> likeList;
  int commentCount;
  int retweetCount;
  String createdAt;
  String imagePath;
  List<String> tags;
  List<String> replyTweetKeyList;
  User user;
  FeedModel({
    this.key,
    this.description,
    this.userId,
    this.likeCount,
    this.commentCount,
    this.retweetCount,
    this.createdAt,
    this.imagePath,
    this.likeList,
    this.tags,
    this.user,
    this.replyTweetKeyList,
    this.parentkey,
    this.childRetwetkey
    });
  toJson() {
    Map<dynamic,dynamic> map;
    if(likeList != null && likeList.length > 0){
       map = Map.fromIterable(likeList, key: (v) =>v.key, value: (v){  
      var list = LikeList(key: v.key, userId: v.userId);
      return list.toJson();
    });
    }
    return {
      "userId": userId,
      "description": description,
     "likeCount":likeCount,
      "commentCount":commentCount ?? 0,
      "retweetCount": retweetCount ?? 0,
      "createdAt":createdAt,
      "imagePath":imagePath,
      "likeList":map,
      "tags":tags,
      "replyTweetKeyList":replyTweetKeyList,
      "user":user == null ? null : user.toJson(),
      "parentkey": parentkey,
      "childRetwetkey":childRetwetkey
    };
  }
  dynamic getLikeList(List<String> list){
    if(list != null && list.length > 0){
   var result = Map.fromIterable(list, key: (v) =>'userId', value: (v) => v[0]);
      return result;
    }
  }
  FeedModel.fromJson(Map<dynamic, dynamic> map) {
    if(likeList == null){
      likeList = [];
    }
   key = map['key'];
   description = map['description'];
   userId = map['userId'];
  //  name = map['name'];
  //  profilePic = map['profilePic'];
   likeCount = map['likeCount'];
   commentCount = map['commentCount'];
   retweetCount = map["retweetCount"] ?? 0;
   imagePath = map['imagePath'];
   createdAt = map['createdAt'];
   imagePath = map['imagePath'];
  //  username = map['username'];
   user = User.fromJson(map['user']);
   parentkey = map['parentkey'];
   childRetwetkey = map['childRetwetkey'];
   if(map['tags'] != null){
      tags = List<String>();
      map['tags'].forEach((value){
         tags.add(value);
     });
   }
   if(map['likeList'] != null){
      map['likeList'].forEach((key,value){
       if(value.containsKey('userId')){
         LikeList list = LikeList(key:key,userId: value['userId']);
          likeList.add(list);
       }
     });
     likeCount = likeList.length;
   }
   else{
     likeList = [];
     likeCount = 0;
   }
   if(map['replyTweetKeyList'] != null){
      map['replyTweetKeyList'].forEach((value){
       replyTweetKeyList = List<String>();
        map['replyTweetKeyList'].forEach((value){
           replyTweetKeyList.add(value);
       });
     });
     commentCount = replyTweetKeyList.length;
   }
   else{
     replyTweetKeyList = [];
     commentCount = 0;
   }
  }

  bool  get isValidTweet {
    bool isValid =false;
    if(description != null 
        && description.isNotEmpty
        && this.user != null
        && this.user.userName != null
        && this.user.userName.isNotEmpty
        ){
            isValid = true;
        }
        else{
          print("Invalid Tweet found. Id:- $key");
        }
        return isValid;
  }

  factory FeedModel.fromFirestore(DocumentSnapshot document) {
    Map data = document.data;

    return FeedModel(
      key: document.documentID,
      description: data['description'],
      likeCount: data['likeCount'],
      createdAt: data['createdAt']
    );
  }

}
class LikeList{
  String key;
  String userId;
  LikeList({this.key,this.userId});
  LikeList.fromJson(Map<dynamic, dynamic> map,{String key}) {
    key = key;
    userId = map['userId'];
  }
  toJson(){
    return {
      'userId':userId
    };
  }

}