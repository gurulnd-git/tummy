
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

}
