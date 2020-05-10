import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yummy_tummy/helper/constants.dart';
import 'package:yummy_tummy/helper/theme.dart';
import 'package:yummy_tummy/helper/utility.dart';
import 'package:yummy_tummy/model/feed.dart';
import 'package:yummy_tummy/model/user.dart';
import 'package:yummy_tummy/page/feed/composeTweet/widget/composeBottomIconWidget.dart';
import 'package:yummy_tummy/page/feed/composeTweet/widget/composeTweetImage.dart';
import 'package:yummy_tummy/page/feed/composeTweet/widget/custom_app_bar.dart';
import 'package:yummy_tummy/state/auth_state.dart';
import 'package:yummy_tummy/state/feed_state.dart';
import 'package:yummy_tummy/widgets/custom_widgets.dart';

class CreateFeedPage extends StatefulWidget {
  CreateFeedPage({Key key}) : super(key: key);

  _CreateFeedPageState createState() => _CreateFeedPageState();
}

class _CreateFeedPageState extends State<CreateFeedPage> {
  bool reachToOver = false;
  bool reachToWarning = false;
  Color wordCountColor;
  File _image;
  TextEditingController _textEditingController;

  @override
  void initState() {
    wordCountColor = YummyTummyColor.appRed;
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  Widget _descriptionEntry() {
    return TextField(
      controller: _textEditingController,
      onChanged: (value) {
        setState(() {
          if (_textEditingController.text != null &&
              _textEditingController.text.isNotEmpty) {
            if (_textEditingController.text.length > 259 &&
                _textEditingController.text.length < 280) {
              wordCountColor = Colors.orange;
            } else if (_textEditingController.text.length >= 280) {
              wordCountColor = Theme.of(context).errorColor;
            } else {
              wordCountColor = YummyTummyColor.appRed;
            }
          }
        });
      },
      maxLines: null,
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Write Your Recipe here',
          hintStyle: TextStyle(fontSize: 18)),
    );
  }

  void _submitButton() async {
    if (_textEditingController.text == null ||
        _textEditingController.text.isEmpty ||
        _textEditingController.text.length > 280) {
      return;
    }
    var state = Provider.of<FeedState>(context,listen: false);
    var authState = Provider.of<AuthState>(context,listen: false);
    if (state.isBusy) {
      return;
    }
    // state.isBusy = true;
   // kScreenloader.showLoader(context);
    var name = authState.userModel.displayName ??
        authState.userModel.email.split('@')[0];
    var pic = authState.userModel.profilePic ?? dummyProfilePic;
    var tags = getHashTags(_textEditingController.text);
    User user = User(
        displayName: name,
        userName: authState.userModel.userName,
        isVerified: authState.userModel.isVerified,
        profilePic: pic,
        userId: authState.userId);
    FeedModel _model = FeedModel(
      description: _textEditingController.text,
      userId: authState.userModel.userId,
      tags: tags,
      user: user,
      createdAt: DateTime.now().toUtc().toString(),
    );
    if (_image != null) {
//      await state.uploadFile(_image).then(
//        (imagePath) {
//          if (imagePath != null) {
//            _model.imagePath = imagePath;
//           // state.createTweet(_model);
//          }
//        },
//      );
    } else {
      state.createTweet(_model, true);
    }
    // state.isBusy = false;
    kScreenloader.hideLoader();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AuthState>(
      context,
    );
    return Scaffold(
      appBar: CustomAppBar(
        title: customTitleText(
          '',
        ),
        onActionPressed: _submitButton,
        isCrossButton: true,
        submitButtonText: 'Post',
        isSubmitDisable: _textEditingController.text == null ||
            _textEditingController.text.isEmpty ||
            _textEditingController.text.length > 280 ||
            Provider.of<FeedState>(context).isBusy,

      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        customImage(context,
                            state.userModel?.profilePic ?? dummyProfilePic),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: _descriptionEntry(),
                        )
                      ],
                    ),
                    ComposeTweetImage(
                      image: _image,
                      onCrossIconPressed: () {
                        setState(() {
                          _image = null;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ComposeBottomIconWidget(
                textEditingController: _textEditingController,
                onImageIconSelcted: (file) {
                  setState(() {
                    _image = file;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
