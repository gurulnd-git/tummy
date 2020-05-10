
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yummy_tummy/helper/enum.dart';
import 'package:yummy_tummy/model/user.dart';
import 'package:yummy_tummy/state/app_state.dart';

class AuthState extends AppState {
  SharedPreferences prefs;
  AuthStatus authStatus =  AuthStatus.NOT_DETERMINED;
  bool isSignInWithGoogle = false;
  FirebaseUser user;
  String userId;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  List<User> _profileUserModelList;
  User _userModel;

  User get userModel => _userModel;

  User get profileUserModel {
    if (_profileUserModelList != null && _profileUserModelList.length > 0) {
      return _profileUserModelList.last;
    } else {
      return null;
    }
  }

  void removeLastUser() {
    _profileUserModelList.removeLast();
  }

  /// Logout from device
  void logoutCallback() {
    authStatus = AuthStatus.NOT_LOGGED_IN;
    userId = '';
    _userModel = null;
    _profileUserModelList = null;
    if (isSignInWithGoogle) {
      _googleSignIn.signOut();
      // logEvent('google_logout');
    }
    _firebaseAuth.signOut();
    notifyListeners();
  }

  /// Alter select auth method, login and sign up page
  void openSignUpPage() {
    authStatus = AuthStatus.NOT_LOGGED_IN;
    userId = '';
    notifyListeners();
  }

  databaseInit() {
    try {
//      if (_profileQuery == null) {
//        //_profileQuery = kDatabase.child("profile").child(userId);
//        //_profileQuery.onValue.listen(_onProfileChanged);
//      }
    } catch (error) {
      print(error);
    }
  }

  /// Verify user's credentials for login
  Future<String> signIn(String email, String password,
      {GlobalKey<ScaffoldState> scaffoldKey}) async {
    try {
      loading = true;
      var result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      user = result.user;
      userId = user.uid;
      return user.uid;
    } catch (error) {
      loading = false;
      print(error);
      // kAnalytics.logLogin(loginMethod: 'email_login');
      //customSnackBar(scaffoldKey, error.message);
      // logoutCallback();
      return null;
    }
  }

  /// Create user from `google login`
  /// If user is new then it create a new user
  /// If user is old then it just `authenticate` user and return firebase user data
  Future<FirebaseUser> handleGoogleSignIn() async {
    try {
      /// Record log in firebase kAnalytics about Google login
      //  kAnalytics.logLogin(loginMethod: 'google_login');
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google login cancelled by user');
      }
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      user = (await _firebaseAuth.signInWithCredential(credential)).user;
      authStatus = AuthStatus.LOGGED_IN;
      userId = user.uid;
      isSignInWithGoogle = true;
      createUserFromGoogleSignIn(user);
      notifyListeners();
      return user;
    } catch (error) {
      user = null;
      authStatus = AuthStatus.NOT_LOGGED_IN;
      print(error);
      return null;
    }
  }

  /// Create user profile from google login
  createUserFromGoogleSignIn(FirebaseUser user) {
    var diff = DateTime.now().difference(user.metadata.creationTime);
    // Check if user is new or old
    // If user is new then add new user to firebase realtime kDatabase
    if (diff < Duration(seconds: 15)) {
      User model = User(
        bio: 'Edit profile to update bio',
        dob: DateTime(1950, DateTime.now().month, DateTime.now().day + 3)
            .toString(),
        location: 'Somewhere in universe',
        profilePic: user.photoUrl,
        displayName: user.displayName,
        email: user.email,
        key: user.uid,
        userId: user.uid,
        contact: user.phoneNumber,
        isVerified: user.isEmailVerified,
      );
      createUser(model, newUser: true);
    } else {
      print('Last login at: ${user.metadata.lastSignInTime}');
    }
  }

  /// Create new user's profile in db
  Future<String> signUp(User userModel,
      {GlobalKey<ScaffoldState> scaffoldKey, String password}) async {
    try {
      loading = true;
      var result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: userModel.email,
        password: password,
      );
      user = result.user;
      authStatus = AuthStatus.LOGGED_IN;
      // kAnalytics.logSignUp(signUpMethod: 'register');
      UserUpdateInfo updateInfo = UserUpdateInfo();
      updateInfo.displayName = userModel.displayName;
      updateInfo.photoUrl = userModel.profilePic;
      await result.user.updateProfile(updateInfo);
      _userModel = userModel;
      _userModel.key = user.uid;
      _userModel.userId = user.uid;
      createUser(_userModel, newUser: true);
      return user.uid;
    } catch (error) {
      loading = false;
      print(error);
      // customSnackBar(scaffoldKey, error.message);
      return null;
    }
  }

  /// `Create` and `Update` user
  /// IF `newUser` is true new user is created
  /// Else existing user will update with new values
  createUser(User user, {bool newUser = false}) {
    if (newUser) {
      // Create username by the combination of name and id
      //user.userName = getUserName(id: user.userId, name: user.displayName);
      // kAnalytics.logEvent(name: 'create_newUser');

      // Time at which user is created
      //  user.createdAt = DateTime.now().toUtc().toString();
    }
    // kDatabase.child('profile').child(user.userId).set(user.toJson());
    _userModel = user;
    if (_profileUserModelList != null) {
      _profileUserModelList.last = _userModel;
    }
    loading = false;
  }

  /// Fetch current user profile
  Future<FirebaseUser> getCurrentUser() async {
    try {
      loading = true;
      //logEvent('get_currentUSer');
      user = await _firebaseAuth.currentUser();
      if (user != null) {
        authStatus = AuthStatus.LOGGED_IN;
        userId = user.uid;
        _userModel = getUserModelFromFirebaseUser(user);
      } else {
        authStatus = AuthStatus.NOT_LOGGED_IN;
      }
      loading = false;
      return user;
    } catch (error) {
      loading = false;
      print(error);
      authStatus = AuthStatus.NOT_LOGGED_IN;
      return null;
    }
  }

  /// Reload user to get refresh user data
  reloadUser() async {
    await user.reload();
    user = await _firebaseAuth.currentUser();
    if (user.isEmailVerified) {
      userModel.isVerified = true;
      // If user verifed his email
      // Update user in firebase realtime kDatabase
      createUser(userModel);
      print('User email verification complete');
      // logEvent('email_verification_complete',
      //      parameter: {userModel.userName: user.email});
    }
  }

  /// Check if user's email is verified
  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }


  Future<bool> checkCarousel() async {
    prefs = await SharedPreferences.getInstance();
    bool seen = (prefs.getBool('seen') ?? false);
    return seen;
  }

  User getUserModelFromFirebaseUser(FirebaseUser fbuser) {
    User user = new User();
    user.displayName = fbuser.displayName;
    user.key = fbuser.uid;
    user.email = fbuser.email;
    user.isVerified = fbuser.isEmailVerified;
    user.profilePic = fbuser.photoUrl;
    user.contact = fbuser.phoneNumber;
    return user;
  }

}
