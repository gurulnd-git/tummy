import 'package:flutter/material.dart';
import 'package:yummy_tummy/model/feed.dart';
import 'package:yummy_tummy/state/feed_state.dart';
import 'package:provider/provider.dart';
import 'package:yummy_tummy/widgets/custom_widgets.dart';

class CardImage extends StatelessWidget {
  const CardImage(
      {Key key, this.model, this.isRetweetImage = false})
      : super(key: key);

  final FeedModel model;
  final bool isRetweetImage;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      alignment: Alignment.centerRight,
      child: model.imagePath == null
          ? SizedBox.shrink()
          : Padding(
              padding: EdgeInsets.only(
                top: 8,
              ),
              child: InkWell(
                borderRadius: BorderRadius.all(
                  Radius.circular(isRetweetImage ? 0 : 20),
                ),
                onTap: () {
                  var state = Provider.of<FeedState>(context, listen: false);
                 // state.getpostDetailFromDatabase(model.key);
                  state.setTweetToReply = model;
                  Navigator.pushNamed(context, '/ImageViewPge');
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(isRetweetImage ? 0 : 20),
                  ),
                  child: Container(
                    width: fullWidth(context) * (.8) - 8,
                    decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                    ),
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
                      child: customNetworkImage(model.imagePath,
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
