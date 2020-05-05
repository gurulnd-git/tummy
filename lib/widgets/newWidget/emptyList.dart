import 'package:flutter/material.dart';
import 'package:yummy_tummy/widgets/custom_widgets.dart';
import 'package:yummy_tummy/widgets/newWidget/title_text.dart';

class EmptyList extends StatelessWidget {
  EmptyList(this.title, {this.subTitle});

  final String subTitle;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: fullHeight(context) - 135,

      child: NotifyText(title: title,subTitle: subTitle,)
    );
  }
}

class NotifyText extends StatelessWidget {
  final String subTitle;
  final String title;
  const NotifyText({Key key, this.subTitle, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TitleText(title, fontSize: 20, textAlign: TextAlign.center),
          SizedBox(
            height: 20,
          ),
          TitleText(
            subTitle,
            fontSize: 16,
            fontWeight: FontWeight.w500,

            textAlign: TextAlign.center,
          ),
        ],
      );
  }
}