import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yummy_tummy/helper/enum.dart';
import 'package:yummy_tummy/page/auth/select_auth_method.dart';
import 'package:yummy_tummy/page/auth/walkthrough_carousel.dart';
import 'package:yummy_tummy/page/home_page.dart';
import 'package:yummy_tummy/state/app_state.dart';
import 'package:yummy_tummy/state/auth_state.dart';
import 'package:yummy_tummy/widgets/custom_widgets.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      timer();
    });
    super.initState();
  }

  void timer() async {
    Future.delayed(Duration(seconds: 2)).then((_) async {
      var state = Provider.of<AuthState>(context, listen: false);

      bool seen = await state.checkCarousel();
      if (!seen) {
        state.authStatus = AuthStatus.SHOW_CAROUSEL;
        state.loading = false;
      } else {
        await state.getCurrentUser();
      }

    });
  }



  Widget _body() {
    var height = 150.0;
    return Container(
      height: fullHeight(context),
      width: fullWidth(context),
      child: Container(
        height: height,
        width: height,
        alignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.all(50),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Platform.isIOS
                  ? CupertinoActivityIndicator(
                radius: 35,
              )
                  : CircularProgressIndicator(
                strokeWidth: 2,
              ),
              Image.asset(
                'assets/images/icon-480.png',
                height: 30,
                width: 30,
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AuthState>(context);
    return state.authStatus == AuthStatus.SHOW_CAROUSEL
        ? WalkthroughScreen()
        : state.authStatus == AuthStatus.NOT_DETERMINED
        ? _body()
        : state.authStatus == AuthStatus.NOT_LOGGED_IN
        ? WelcomePage()
        : HomePage();
  }
}
