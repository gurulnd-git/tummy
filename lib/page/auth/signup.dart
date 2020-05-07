import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yummy_tummy/helper/constants.dart';
import 'package:yummy_tummy/helper/enum.dart';
import 'package:yummy_tummy/helper/theme.dart';
import 'package:yummy_tummy/model/user.dart';
import 'package:yummy_tummy/state/auth_state.dart';
import 'package:yummy_tummy/widgets/custom_loader.dart';
import 'package:yummy_tummy/widgets/custom_widgets.dart';

class Signup extends StatefulWidget {
  final VoidCallback loginCallback;

  const Signup({Key key, this.loginCallback}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController _nameController;
  TextEditingController _emailController;
  // TextEditingController _mobileController;
  TextEditingController _passwordController;
  TextEditingController _confirmController;
  CustomLoader loader;
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    loader = CustomLoader();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    // _mobileController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmController = TextEditingController();
     _emailController.text = 'bruce.wayne@gmail.com';
     _passwordController.text = '1234567';
     _nameController.text = 'Bruce Wayne';
    // _mobileController.text =    '9871234567';
     _passwordController.text = '1234567';
     _confirmController.text = '1234567';
    super.initState();
  }

  Widget _body(BuildContext context) {
    return Container(
      height: fullHeight(context) - 88,
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _entryFeild('Name', controller: _nameController),
            _entryFeild('Enter email', controller: _emailController),
            // _entryFeild('Mobile no',controller: _mobileController),
            _entryFeild('Enter password',
                controller: _passwordController, isPassword: true),
            _entryFeild('Confirm password',
                controller: _confirmController, isPassword: true),
            _submitButton(context),
          ],
        ),
      ),
    );
  }

  Widget _entryFeild(String hint,
      {TextEditingController controller, bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal,
        ),
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30.0),
            ),
            borderSide: BorderSide(color: YummyTummyColor.appRed),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
      ),
    );
  }

  Widget _submitButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      width: MediaQuery.of(context).size.width,
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: YummyTummyColor.appRed,
        onPressed: _submitForm,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Text('Sign up', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  void _submitForm() {
    if (_emailController.text == null ||
        _emailController.text.isEmpty ||
        _passwordController.text == null ||
        _passwordController.text.isEmpty ||
        _confirmController.text == null) {
      customSnackBar(_scaffoldKey, 'Please fill form carefully');
      return;
    } else if (_passwordController.text != _confirmController.text) {
      customSnackBar(
          _scaffoldKey, 'Password and confirm password did not match');
      return;
    }
    loader.showLoader(context);
    var state = Provider.of<AuthState>(context, listen: false);
    Random random = new Random();
    int randomNumber = random.nextInt(8);

    User user = User(
      email: _emailController.text.toLowerCase(),
      bio: 'Edit profile to update bio',
      // contact:  _mobileController.text,
      displayName: _nameController.text,
      dob: DateTime(1950, DateTime.now().month, DateTime.now().day + 3)
          .toString(),
      location: 'Somewhere in universe',
      profilePic: dummyProfilePic,
      isVerified: false,
    );
    state
        .signUp(
      user,
      password: _passwordController.text,
      scaffoldKey: _scaffoldKey,
    )
        .then((status) {
      print(status);
    }).whenComplete(
      () {
        loader.hideLoader();
        if (state.authStatus == AuthStatus.LOGGED_IN) {
          Navigator.pop(context);
          widget.loginCallback();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: customText(
          'Sign Up',
          context: context,
          style: TextStyle(fontSize: 20),
        ),
        backgroundColor: YummyTummyColor.appRed,
        centerTitle: true,
      ),
      body: SingleChildScrollView(child: _body(context)),
    );
  }
}
