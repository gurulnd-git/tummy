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

class CardBottom extends StatelessWidget {
  final FeedModel model;
  final Color iconColor;
  final Color iconEnableColor;
  final double size;
  const CardBottom(
      {Key key,
        this.model,
        this.iconColor,
        this.iconEnableColor,
        this.size})
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

          ],
        ),
        SizedBox(
          height: 5,
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
            _timeWidget(context),
            _likeCommentsIcons(context, model)
          ],
        ));
  }
}
