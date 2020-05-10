import 'package:flutter/material.dart';
import 'package:yummy_tummy/helper/constants.dart';
import 'package:yummy_tummy/helper/enum.dart';
import 'package:yummy_tummy/helper/theme.dart';
import 'package:yummy_tummy/helper/utility.dart';
import 'package:yummy_tummy/model/feed.dart';
import 'package:yummy_tummy/state/auth_state.dart';
import 'package:yummy_tummy/state/feed_state.dart';
import 'package:yummy_tummy/widgets/custom_widgets.dart';
import 'package:provider/provider.dart';

class CardIconsRow extends StatelessWidget {
  final FeedModel model;
  final Color iconColor;
  final Color iconEnableColor;
  final double size;
  final bool isTweetDetail;
  const CardIconsRow(
      {Key key,
      this.model,
      this.iconColor,
      this.iconEnableColor,
      this.size,
      this.isTweetDetail = false})
      : super(key: key);

  Widget _likeCommentsIcons(BuildContext context, FeedModel model) {
    var state = Provider.of<AuthState>(
      context,
    );
    return Container(
        color: Colors.transparent,
        padding: EdgeInsets.only(bottom: 0, top: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 70,
            ),
            _iconWidget(context,
                text: model.likeCount == null ? '' : model.likeCount.toString(),
                icon: AppIcon.heartEmpty, onPressed: () {
                  addLikeToTweet(context);
                },
                iconColor:  iconColor,
                size: size ?? 20
            ),
            _iconWidget(
              context,
              text: model.commentCount == null ? '' : model.commentCount.toString(),
              icon: AppIcon.reply,
              iconColor: iconColor,
              size: size ?? 20,
              onPressed: () {
                var state = Provider.of<FeedState>(context);
                state.setTweetToReply = model;
                Navigator.of(context).pushNamed('/ComposeTweetPage');
              },
            ),

            _iconWidget(context, text: '', icon: null, sysIcon: Icons.share,
                onPressed: () {
              share('${model.description}',
                  subject: '${model.user.displayName}\'s post');
            }, iconColor: iconColor, size: size ?? 20),
          ],
        ));
  }

  Widget _iconWidget(BuildContext context,
      {String text,
      int icon,
      Function onPressed,
      IconData sysIcon,
      Color iconColor,
      double size = 20}) {
    return Expanded(
        child: Container(
            child: Row(
      children: <Widget>[
        IconButton(
          onPressed: () {
            if (onPressed != null) onPressed();
          },
          icon: sysIcon != null
              ? Icon(sysIcon, color: iconColor, size: size)
              : customIcon(context,
                  size: size,
                  icon: icon,
                  istwitterIcon: true,
                  iconColor: iconColor),
        ),
        customText(text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: iconColor,
              fontSize: size - 5,
            ),
            context: context),
      ],
    )));
  }

  Widget _timeWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 8,
        ),
        Row(
          children: <Widget>[
            SizedBox(
              width: 5,
            ),
            customText(getPostTime2(model.createdAt), style: textStyle14),
            SizedBox(
              width: 10,
            ),
            customText('Fwitter for Android',
                style: TextStyle(color: Theme.of(context).primaryColor))
          ],
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }

  Widget _likeCommentWidget(BuildContext context) {
    bool isLikeAvailable = model.likeCount > 0;
    bool isRetweetAvailable = model.retweetCount > 0;
    bool isLikeRetweetAvailable = isRetweetAvailable || isLikeAvailable;
    return Column(
      children: <Widget>[
        Divider(
          endIndent: 10,
          height: 0,
        ),
        AnimatedContainer(
          padding:
              EdgeInsets.symmetric(vertical: isLikeRetweetAvailable ? 12 : 0),
          duration: Duration(milliseconds: 500),
          child: !isLikeRetweetAvailable
              ? SizedBox.shrink()
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    !isRetweetAvailable
                        ? SizedBox.shrink()
                        : customText(model.retweetCount.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold)),
                    !isRetweetAvailable
                        ? SizedBox.shrink()
                        : SizedBox(width: 5),
                    AnimatedCrossFade(
                      firstChild: SizedBox.shrink(),
                      secondChild: customText('Retweets', style: subtitleStyle),
                      crossFadeState: !isRetweetAvailable
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      duration: Duration(milliseconds: 800),
                    ),
                    !isRetweetAvailable
                        ? SizedBox.shrink()
                        : SizedBox(width: 20),
                    InkWell(
                      onTap: () {
                        onLikeTextPressed(context);
                      },
                      child: AnimatedCrossFade(
                        firstChild: SizedBox.shrink(),
                        secondChild: Row(
                          children: <Widget>[
                            customSwitcherWidget(
                              duraton: Duration(milliseconds: 300),
                              child: customText(model.likeCount.toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  key: ValueKey(model.likeCount)),
                            ),
                            SizedBox(width: 5),
                            customText('Likes', style: subtitleStyle)
                          ],
                        ),
                        crossFadeState: !isLikeAvailable
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration: Duration(milliseconds: 300),
                      ),
                    )
                  ],
                ),
        ),
        !isLikeRetweetAvailable
            ? SizedBox.shrink()
            : Divider(
                endIndent: 10,
                height: 0,
              ),
      ],
    );
  }

  void addLikeToTweet(BuildContext context) {
    var state = Provider.of<FeedState>(
      context, listen: false
    );
    var authState = Provider.of<AuthState>(
      context, listen: false
    );
    state.addLikeToTweet(model, authState.userId);
  }

  void onLikeTextPressed(BuildContext context) {
//    Navigator.of(context).push(
//      CustomRoute<bool>(
//        builder: (BuildContext context) => UsersListPage(
//          pageTitle: "Liked by",
//          userIdsList: model.likeList.map((x) => x.userId).toList(),
//        ),
//      ),
//    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        isTweetDetail ? _timeWidget(context) : SizedBox(),
        isTweetDetail ? _likeCommentWidget(context) : SizedBox(),
        _likeCommentsIcons(context, model)
      ],
    ));
  }
}
