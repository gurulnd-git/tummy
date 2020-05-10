
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yummy_tummy/model/feed.dart';
import 'package:yummy_tummy/state/app_state.dart';

class FeedState extends AppState {
  bool isBusy = false;
  Map<String, List<FeedModel>> tweetReplyMap = {};
  FeedModel _tweetToReplyModel;
  FeedModel get tweetToReplyModel => _tweetToReplyModel;
  set setTweetToReply(FeedModel model) {
    _tweetToReplyModel = model;
  }
  
  List<FeedModel> _feedlist;
  List<FeedModel> _tweetDetailModelList;

  List<FeedModel> get tweetDetailModel => _tweetDetailModelList;

  /// contain tweet list for home page
  /// `feedlist` always [contain all tweets] fetched from firebase kDatabase
  List<FeedModel> get feedlist {
    if (_feedlist == null) {
      return null;
    } else {
      return List.from(_feedlist.reversed);
    }
  }

  void getDataFromDatabase() {
    try {
      isBusy = true;
      _feedlist = null;
     // notifyListeners();

      var ref = Firestore.instance.collection('recipes');

     ref.snapshots().map((list) => list.documents.map((doc)
      => FeedModel.fromFirestore(doc)).toList()).listen((r) {
        _feedlist = r ;
        _feedlist.sort((x,y) => DateTime.parse(x.createdAt).compareTo(DateTime.parse(y.createdAt)));
        isBusy = false;
        notifyListeners();
      });

    } catch (error) {
      isBusy = false;
      print(error);
    }
  }

  /// set tweet for detail tweet page
  /// Setter call when tweet is tapped to view detail
  /// Add Tweet detail is added in _tweetDetailModelList
  /// It makes `Fwitter` to view nested Tweets
  set setFeedModel(FeedModel model) {
    if (_tweetDetailModelList == null) {
      _tweetDetailModelList = [];
    }

    /// [Skip if any duplicate tweet already present]
    if (_tweetDetailModelList.length == 0 ||
        _tweetDetailModelList.length > 0 &&
            !_tweetDetailModelList.any((x) => x.key == model.key)) {
      _tweetDetailModelList.add(model);
      notifyListeners();
    }
  }

  /// create [New Tweet]
  createTweet(FeedModel model, bool isCreatePost) async {
    ///  Create tweet in [Firebase kDatabase]
    isBusy = true;
    notifyListeners();
    try {
        if (isCreatePost) {
          await Firestore.instance.collection('recipes').add(model.toJson());
        } else {
          // Update Post
          await Firestore.instance.collection('recipes').document(model.key).setData(model.toJson(), merge: true);
      }
    } catch (error) {
      print(error);
    }
    isBusy = false;
    notifyListeners();
  }


  /// [Subscribe Tweets] firebase Database
  Future<bool> databaseInit() {
    try {
//      if (_feedQuery == null) {
//        _feedQuery.onChildAdded.listen(_onTweetAdded);
//        _feedQuery.onChildChanged.listen(_onTweetChanged);
//        _feedQuery.onChildRemoved.listen(_onTweetRemoved);
//      }

      return Future.value(true);
    } catch (error) {
      print(error);
      return Future.value(false);
    }
  }

  addLikeToTweet(FeedModel feed, String userId) {
    try {
      if (feed.likeList != null &&
          feed.likeList.length > 0 &&
          feed.likeList.any((x) => x.userId == userId)) {
          feed.likeList.removeWhere(
                (x) => x.userId == userId,
          );
        // If user unlike Tweet
        feed.likeCount -= 1;
        //updateTweet(tweet);
//        kDatabase
//            .child('notification')
//            .child(tweet.userId)
//            .child(
//          tweet.key,
//        )
//            .child('likeList')
//            .child(userId)
//            .remove();
      } else {
        // If user likes the post
        print(feed.likeCount);
        Firestore.instance.collection('recipes').document(feed.key).updateData({
          "likeCount": ( feed.likeCount += 1 ),
        });

//        kDatabase
//            .child('tweet')
//            .child(tweet.key)
//            .child('likeList')
//            .child(userId)
//            .set({'userId': userId});
//        kDatabase
//            .child('notification')
//            .child(tweet.userId)
//            .child(
//          tweet.key,
//        )
//            .child('likeList')
//            .child(userId)
//            .set({'userId': userId});
      }
    } catch (error) {
      print(error);
    }
  }

  /// Add [new comment tweet] to any tweet
  /// Comment is a Tweet itself
  addcommentToPost(FeedModel replyTweet) {
    try {
      isBusy = true;
      notifyListeners();
      if (_tweetToReplyModel != null) {
        FeedModel tweet =
        _feedlist.firstWhere((x) => x.key == _tweetToReplyModel.key);
        var json = replyTweet.toJson();
//        kDatabase.child('tweet').push().set(json).then((value) {
//          tweet.replyTweetKeyList.add(_feedlist.last.key);
//          updateTweet(tweet);
//        });
      }
    } catch (error) {
      print(error);
    }
    isBusy = false;
    notifyListeners();
  }



}
