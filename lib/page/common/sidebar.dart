import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yummy_tummy/helper/constants.dart';
import 'package:yummy_tummy/state/auth_state.dart';
import 'package:yummy_tummy/widgets/custom_widgets.dart';
import 'package:yummy_tummy/helper/theme.dart';

class SidebarMenu extends StatefulWidget {
  const SidebarMenu({Key key, this.scaffoldKey}) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;

  _SidebarMenuState createState() => _SidebarMenuState();
}

class _SidebarMenuState extends State<SidebarMenu> {
  Widget _menuHeader() {
    final state = Provider.of<AuthState>(context);
    if (state.userModel == null) {
      return customInkWell(
        context: context,
        onPressed: () {
          //  Navigator.of(context).pushNamed('/signIn');
        },
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: 200, minHeight: 100),
          child: Center(
            child: Text(
              'Login to continue',
              style: onPrimaryTitleText,
            ),
          ),
        ),
      );
    } else {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 56,
              width: 56,
              margin: EdgeInsets.only(left: 17, top: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(28),
                image: DecorationImage(
                  image: customAdvanceNetworkImage(
                    state.userModel.profilePic ?? dummyProfilePic,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                _navigateTo("ProfilePage");
              },
              title: Row(
                children: <Widget>[
//                  UrlText(
//                    text: state.userModel.displayName ??
//                        state.userModel.email,
//                    style: onPrimaryTitleText.copyWith(
//                        color: Colors.black, fontSize: 20),
//                  ),
                  SizedBox(
                    width: 3,
                  ),
                  state.userModel.isVerified
                      ? customIcon(context,
                      icon: AppIcon.blueTick,
                      istwitterIcon: true,
                      iconColor: AppColor.primary,
                      size: 18,
                      paddingIcon: 3)
                      : SizedBox(
                    width: 0,
                  ),
                ],
              ),
              subtitle: customText(
                state.userModel.userName,
                style: onPrimarySubTitleText.copyWith(
                    color: Colors.black54, fontSize: 15),
              ),
              trailing: customIcon(context,
                  icon: AppIcon.arrowDown,
                  iconColor: AppColor.primary,
                  paddingIcon: 20),
            ),

          ],
        ),
      );
    }
  }

  ListTile _menuListRowButton(String title,
      {Function onPressed, int icon, bool isEnable = false}) {
    return ListTile(
      onTap: () {
        if (onPressed != null) {
          onPressed();
        }
      },
      leading: icon == null
          ? null
          : Padding(
        padding: EdgeInsets.only(top: 5),
        child: customIcon(
          context,
          icon: icon,
          size: 25,
          iconColor: isEnable ? AppColor.darkGrey : AppColor.lightGrey,
        ),
      ),
      title: customText(
        title,
        style: TextStyle(
          fontSize: 15,
          color: isEnable ? AppColor.secondary : AppColor.lightGrey,
        ),
      ),
    );
  }

  void _logOut() {
    final state = Provider.of<AuthState>(context,listen: false);
    Navigator.pop(context);
    state.logoutCallback();
  }

  void _navigateTo(String path) {
    Navigator.pop(context);
    Navigator.of(context).pushNamed('/$path');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 45),
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  Container(
                    child: _menuHeader(),
                  ),
                  Divider(),
                  _menuListRowButton('Profile',
                      icon: AppIcon.profile, isEnable: true, onPressed: () {
                        _navigateTo('ProfilePage');
                      }),
                  _menuListRowButton('My Listings', icon: AppIcon.lists),
                  _menuListRowButton('Bookamarks', icon: AppIcon.bookmark),
                  Divider(),
                  _menuListRowButton('Settings and privacy', isEnable: true,
                      onPressed: () {
                        _navigateTo('SettingsAndPrivacyPage');
                      }),
                  _menuListRowButton('Help Center'),
                  Divider(),
                  _menuListRowButton('Logout',
                      icon: null, onPressed: _logOut, isEnable: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
