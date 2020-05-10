import 'package:flutter/material.dart';
import 'package:yummy_tummy/helper/constants.dart';
import 'package:yummy_tummy/helper/theme.dart';
import 'package:yummy_tummy/model/feed.dart';
import 'package:yummy_tummy/state/feed_state.dart';
import 'package:yummy_tummy/widgets/card/card_bottom.dart';
import 'package:yummy_tummy/widgets/custom_widgets.dart';
import 'package:yummy_tummy/widgets/newWidget/customUrlText.dart';
import 'package:provider/provider.dart';
import 'package:yummy_tummy/widgets/card/widgets/cardIconsRow.dart';

import 'widgets/cardImage.dart';

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  leading: GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed('/ProfilePage/' + model?.userId);
                    },
                    child: customImage(context, model.user?.profilePic),
                  ),
                  title: Row(
                    children: <Widget>[
                      UrlText(
                        text: model.user?.displayName,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(width: 3),
                  ( model.user != null &&model.user?.isVerified )
                          ? customIcon(
                        context,
                        icon: AppIcon.blueTick,
                        istwitterIcon: true,
                        iconColor: AppColor.primary,
                        size: 13,
                        paddingIcon: 3,
                      )
                          : SizedBox(width: 0),
                      SizedBox(
                        width: ( model.user != null && model.user?.isVerified) ? 5 : 0,
                      ),
                    ],
                  ),
                  subtitle:
                  customText('${model.user?.userName}', style: userNameStyle),
                  trailing: trailing,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: UrlText(
                    text: model.description,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize:  14,
                        fontWeight: FontWeight.w400),
                    urlStyle: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.w400),
                  ),
                )
              ],
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

                  Container(child: trailing == null ? SizedBox() : trailing),
                ],
              ),
              UrlText(
                text: model.description,
                style: TextStyle(
                  color: Colors.black
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
