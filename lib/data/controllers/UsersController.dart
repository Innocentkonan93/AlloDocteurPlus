import '../models/User.dart';
import 'package:flutter/material.dart';

class UsersController with ChangeNotifier {
  bool _isProcessing = false;
  List<User> _listUsers = [];

  bool get isProcessing => _isProcessing;
  List<User> get listUsers {
    return [..._listUsers];
  }

  setUserList(List<User> list) {
    _listUsers = list;
    notifyListeners();
  }

  cleanUserData(){
    _listUsers.clear();
    print('user clean');
    notifyListeners();
  }

  isProces(bool isProcces) {
    _isProcessing = isProcces;
    notifyListeners();
  }
}
