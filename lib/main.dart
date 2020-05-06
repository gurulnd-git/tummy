import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:yummy_tummy/helper/routes.dart';
import 'package:yummy_tummy/state/app_state.dart';
import 'package:yummy_tummy/state/auth_state.dart';
import 'package:yummy_tummy/state/feed_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    List<AssetImage> allImages = [ AssetImage("assets/images/1.jpg"), AssetImage("assets/images/2.jpg"),
      AssetImage("assets/images/3.jpg"), AssetImage("assets/images/4.jpg")];
    allImages.forEach((AssetImage image) {
      precacheImage(image, context);
    });

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>(create: (_) => AppState()),
        ChangeNotifierProvider<AuthState>(create: (_) => AuthState()),
        ChangeNotifierProvider<FeedState>(create: (_) => FeedState()),
      ],
      child: MaterialApp(
        title: 'Demo Clone',
        debugShowCheckedModeBanner: false,
        routes: Routes.route(),
        onGenerateRoute: (settings) => Routes.onGenerateRoute(settings),
        onUnknownRoute: (settings) => Routes.onUnknownRoute(settings),
      ),
    );
  }
}

