import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yummy_tummy/page/common/sidebar.dart';
import 'package:yummy_tummy/page/feed/feedPage.dart';
import 'package:yummy_tummy/state/app_state.dart';
import 'package:yummy_tummy/state/auth_state.dart';
import 'package:yummy_tummy/widgets/bottomMenuBar/bottomMenuBar.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int pageIndex = 0;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var state = Provider.of<AppState>(context, listen: false);
      state.setpageIndex = 0;
      initProfile();
    });

    super.initState();
  }


  void initProfile() {
    var state = Provider.of<AuthState>(context, listen: false);
    state.databaseInit();
  }


  Widget _body() {
    var state = Provider.of<AppState>(context);
    return SafeArea(child: Container(child: _getPage(state.pageIndex)));
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return FeedPage(
          scaffoldKey: _scaffoldKey,
        );
        break;
      default:
        return FeedPage(scaffoldKey: _scaffoldKey);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      bottomNavigationBar: BottomMenubar(),
      drawer: SidebarMenu(),
      body: _body(),
    );
  }
}
