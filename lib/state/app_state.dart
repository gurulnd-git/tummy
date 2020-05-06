
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yummy_tummy/helper/enum.dart';
import 'package:yummy_tummy/state/auth_state.dart';

class AppState extends ChangeNotifier{

  static SharedPreferences prefs;
  bool _isBusy;
  bool get isbusy => _isBusy;

  set loading(bool value){
    _isBusy = value;
    notifyListeners();
  }

  int _pageIndex = 0;
  int get pageIndex {
     return _pageIndex;
  } 
  set setpageIndex(int index){
    _pageIndex = index;
    notifyListeners();
  }

}
