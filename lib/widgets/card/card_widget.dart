import 'package:flutter/material.dart';
import 'package:yummy_tummy/helper/constants.dart';
import 'package:yummy_tummy/helper/theme.dart';
import 'package:yummy_tummy/model/feed.dart';
import 'package:yummy_tummy/state/feed_state.dart';
import 'package:yummy_tummy/widgets/card/card_bottom.dart';
import 'package:yummy_tummy/widgets/custom_widgets.dart';
import 'package:yummy_tummy/widgets/newWidget/customUrlText.dart';
import 'package:provider/provider.dart';

import 'card_image.dart';

class CardWidget extends StatelessWidget {
  final FeedModel model;
  final Widget trailing;
  final bool isDisplayOnProfile;
  CardWidget(
      {Key key,
      this.model,
      this.trailing,
      this.isDisplayOnProfile = false})
      : super(key: key);

  Widget _recipe(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: 10),
        Container(
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () {
              // If tweet is displaying on someone's profile then no need to navigate to profile again.
//              if (isDisplayOnProfile) {
//                return;
//              }
              Navigator.of(context).pushNamed('/ProfilePage/' + model?.userId);
            },
            child: customImage(context, model.user?.profilePic),
          ),
        ),
        SizedBox(width: 20),
        Container(
          width: fullWidth(context) - 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        UrlText(
                          //text: model?.user?.displayName,
                          text : "Sample User",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(width: 3),
                         customIcon(
                          context,
                          icon: AppIcon.blueTick,
                          istwitterIcon: true,
                          iconColor: AppColor.primary,
                          size: 13,
                          paddingIcon: 3,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Flexible(
                          child: customText(
                            '${model.user?.userName}',
                            style: userNameStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 4),
//                        customText('· ${getChatTime(model.createdAt)}',
//                            style: userNameStyle),
                      ],
                    ),
                  ),
                  Container(child: trailing == null ? SizedBox() : trailing),
                ],
              ),
              UrlText(
                text: model.description,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                urlStyle:
                TextStyle(color: Colors.blue, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
        SizedBox(width: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var feedstate = Provider.of<FeedState>(context);
    return InkWell(
      onLongPress: () {
       // card press
      },
      onTap: () {
        Navigator.of(context).pushNamed('/FeedPostDetail/' + model.key);
      },
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 12),
            child:_recipe(context),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CardImage(model: model,),
          ),
          Padding(
            padding: EdgeInsets.only(left: 60),
            child: CardBottom(
              model: model,
              iconColor: Theme.of(context).textTheme.caption.color,
              iconEnableColor: YummyTummyColor.appRed,
              size: 20,
            ),
          ),
          Divider(
            height: .5,
            thickness: .5,
          )
        ],
      ),
    );
  }
}
