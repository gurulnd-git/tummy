import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yummy_tummy/helper/constants.dart';
import 'package:yummy_tummy/model/feed.dart';
import 'package:yummy_tummy/state/auth_state.dart';
import 'package:yummy_tummy/state/feed_state.dart';
import 'package:yummy_tummy/widgets/custom_loader.dart';
import 'package:yummy_tummy/widgets/custom_widgets.dart';


class FeedPage extends StatefulWidget {
  const FeedPage({Key key, this.scaffoldKey}) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;

  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
  }

  Widget _floatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).pushNamed('/CreateFeedPage/tweet');
      },
      child: customIcon(
        context,
        icon: AppIcon.fabTweet,
        istwitterIcon: true,
        iconColor: Theme.of(context).colorScheme.onPrimary,
        size: 25,
      ),
    );
  }

  Widget _getUserAvatar(BuildContext context) {
    var authState = Provider.of<AuthState>(context);
    return Padding(
      padding: EdgeInsets.all(10),
      child: customInkWell(
        context: context,
        onPressed: () {
          widget.scaffoldKey.currentState.openDrawer();
        },
        child:
            customImage(context, authState.userModel?.profilePic, height: 30),
      ),
    );
  }

  Widget _body() {
    var state = Provider.of<FeedState>(context);
    var authstate = Provider.of<AuthState>(context);
    List<FeedModel> list;
    if (!state.isBusy && state.feedlist != null && state.feedlist.isNotEmpty) {
      list = state.feedlist.where((x) {
        if (x.user.userId == authstate.userId )
            {
          return true;
        } else {
          return false;
        }
      }).toList();
      if (list.isEmpty) {
        list = null;
      }
    }

    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          floating: true,
          elevation: 0,
          leading: _getUserAvatar(context),
          title: customTitleText('Home'),
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          backgroundColor: Theme.of(context).appBarTheme.color,
          bottom: PreferredSize(
            child: Container(
              color: Colors.grey.shade200,
              height: 1.0,
            ),
            preferredSize: Size.fromHeight(0.0),
          ),
        ),
        state.isBusy && list == null
            ? SliverToBoxAdapter(
                child:  Container(
                        height: fullHeight(context) - 135,
                        child: CustomScreenLoader(
                          height: double.infinity,
                          width: fullWidth(context),
                          backgroundColor: Colors.white,
                        )
                      )
              )
            : !state.isBusy && list == null
                ? SliverToBoxAdapter(
                   )
                : SliverList(
                    delegate: SliverChildListDelegate(
                      list.map(
                        (model) {
                          return Container(
                            color: Colors.white,
//                            child: Tweet(
//                              model: model,
//                              trailing: TweetBottomSheet().tweetOptionIcon(
//                                  context, model, TweetType.Tweet),
//                            ),
                          );
                        },
                      ).toList(),
                    ),
                  )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _floatingActionButton(),
      body: SafeArea(
        child: Container(
          height: fullHeight(context),
          width: fullWidth(context),
          child: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: () async {
              var state = Provider.of<FeedState>(context);
             // state.getDataFromDatabase();
              return Future.value(true);
            },
            child: _body(),
          ),
        ),
      ),
    );
  }
}
