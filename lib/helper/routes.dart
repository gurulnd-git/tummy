import 'package:flutter/material.dart';
import 'package:yummy_tummy/helper/custom_route.dart';
import 'package:yummy_tummy/helper/theme.dart';
import 'package:yummy_tummy/page/auth/select_auth_method.dart';
import 'package:yummy_tummy/page/auth/signin.dart';
import 'package:yummy_tummy/page/auth/signup.dart';
import 'package:yummy_tummy/page/common/splash.dart';
import 'package:yummy_tummy/page/feed/composeTweet/createFeed.dart';
import 'package:yummy_tummy/widgets/custom_widgets.dart';

class Routes {
  static dynamic route() {
    return {
      '/': (BuildContext context) => SplashPage(),
    };
  }

  static Route onGenerateRoute(RouteSettings settings) {
    final List<String> pathElements = settings.name.split('/');
    if (pathElements[0] != '' || pathElements.length == 1) {
      return null;
    }
   switch (pathElements[1]) {
      // case "FeedPostDetail":
      //   var postId = pathElements[2];
      //     return SlideLeftRoute<bool>(builder:(BuildContext context)=> FeedPostDetail(postId: postId,),settings: RouteSettings(name:'FeedPostDetail'));
      //   case "ProfilePage":
      //    String profileId;
      //    if(pathElements.length > 2){
      //        profileId = pathElements[2];
      //    }
      //   return CustomRoute<bool>(builder:(BuildContext context)=> ProfilePage(
      //     profileId: profileId,
      //   ));
      case "WelcomePage":return CustomRoute<bool>(builder:(BuildContext context)=> WelcomePage()); 
      case "SignIn":return CustomRoute<bool>(builder:(BuildContext context)=> SignIn()); 
      case "SignUp":return CustomRoute<bool>(builder:(BuildContext context)=> Signup()); 
      // case "ForgetPasswordPage":return CustomRoute<bool>(builder:(BuildContext context)=> ForgetPasswordPage());
       case "CreateFeedPage":return CustomRoute<bool>(builder:(BuildContext context)=> CreateFeedPage(),);
      // case "EditProfile":return CustomRoute<bool>(builder:(BuildContext context)=> EditProfilePage());
      // case "SettingsAndPrivacyPage":return CustomRoute<bool>(builder:(BuildContext context)=> SettingsAndPrivacyPage(),); 
      // case "AccountSettingsPage":return CustomRoute<bool>(builder:(BuildContext context)=> AccountSettingsPage(),); 
      // case "AccountSettingsPage":return CustomRoute<bool>(builder:(BuildContext context)=> AccountSettingsPage(),);
      // case "DisplayAndSoundPage":return CustomRoute<bool>(builder:(BuildContext context)=> DisplayAndSoundPage(),);
      // case "AccessibilityPage":return CustomRoute<bool>(builder:(BuildContext context)=> AccessibilityPage(),);
      // case "AboutPage":return CustomRoute<bool>(builder:(BuildContext context)=> AboutPage(),);
      // case "VerifyEmailPage":return CustomRoute<bool>(builder:(BuildContext context)=> VerifyEmailPage(),); 
      default:return onUnknownRoute(RouteSettings(name: '/Feature'));
     }
  }

  static Route onUnknownRoute(RouteSettings settings){
     return MaterialPageRoute(
          builder: (_) => Scaffold(
                appBar: AppBar(title: customTitleText(settings.name.split('/')[1]),centerTitle: true,
                backgroundColor: YummyTummyColor.appRed,),
                body: Center(
                  child: Text('${settings.name.split('/')[1]} Comming soon..'),
                ),
              ),
        );
   }

}