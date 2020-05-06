import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yummy_tummy/model/walkthrough.dart';
import 'package:yummy_tummy/state/auth_state.dart';
import 'package:yummy_tummy/utils/git_it.dart';
import 'package:yummy_tummy/utils/navigation_service.dart';
import 'package:yummy_tummy/widgets/newWidget/custom_flat_button.dart';
SharedPreferences prefs;
class WalkthroughScreen extends StatefulWidget {
 // AppModel model;
  final List<Walkthrough> pages = [
    Walkthrough(
      title: "Find amazing recipes",
      description:
      "Search with what you have in your fridge",
      image: "assets/images/1.jpg"
    ),
    Walkthrough(
      title: "Upload unlimited recipes",
      description: "Let others know your choice of secret ingredients",
      image: "assets/images/2.jpg"
    ),
    Walkthrough(
      title: "Leverage your skills",
      description:
      "Strom into the top recipes",
       image: "assets/images/3.jpg"
    ),
  ];


  @override
  _WalkthroughScreenState createState() => _WalkthroughScreenState();
}

class _WalkthroughScreenState extends State<WalkthroughScreen> {

  void initState() {
    setPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Swiper.children(
        autoplay: false,
        index: 0,
        loop: false,
        pagination: SwiperPagination(
          margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 40.0),
          builder: DotSwiperPaginationBuilder(
              color: Colors.white30,
              activeColor: Colors.white,
              size: 6.5,
              activeSize: 8.0),
        ),
        control: SwiperControl(
          iconPrevious: null,
          iconNext: null,
        ),
        children: _getPages(context),
      ),
    );
  }

  List<Widget> _getPages(BuildContext context) {
    List<Widget> widgets = [];
    for (int i = 0; i < widget.pages.length; i++) {
      Walkthrough page = widget.pages[i];
      widgets.add(
        new Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage(page.image),
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 360.0),
                child: Icon(
                  page.icon,
                  size: 125.0,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.only(top: 50.0, right: 15.0, left: 15.0),
                child: Text(
                  page.title,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.none,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                    fontFamily: "OpenSans",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  page.description,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.none,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w300,
                    fontFamily: "OpenSans",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: page.extraWidget,
              )
            ],
          ),
        ),
      );
    }
    widgets.add(
      new Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/4.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding:
                const EdgeInsets.only(top: 480.0, right: 15.0, left: 15.0),
                child: Text(
                  "Jump straight into the action.",
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.none,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                    fontFamily: "OpenSans",
                  ),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.only(top: 20.0, right: 15.0, left: 15.0),
                child: CustomFlatButton(
                  title: "Get Started",
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  textColor: Colors.white,
                  onPressed: () {
                    prefs.setBool('seen', true);
                    var state = Provider.of<AuthState>(context, listen: false);
                    state.getCurrentUser();
                    //locator<NavigationService>().pop();
                    //locator<NavigationService>().navigateTo('/auth');
                  },
                  splashColor: Colors.black12,
                  borderColor: Colors.white,
                  borderWidth: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    return widgets;
  }

  setPref() async {
    prefs = await SharedPreferences.getInstance();
  }
}
