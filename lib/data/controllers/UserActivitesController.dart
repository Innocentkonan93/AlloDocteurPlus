import '../models/UserActivites.dart';
import 'package:flutter/foundation.dart';

class UserActivitesController with ChangeNotifier {
  bool _isProcessing = false;
  List<UserActivites> _listUserActivites = [];

  bool get isProcessing => _isProcessing;
  List<UserActivites> get listUserActivites {
    return [..._listUserActivites];
  }

  setUserActivitesList(List<UserActivites> list) {
    _listUserActivites = list;
    notifyListeners();
  }

  isProces(bool isProcces) {
    _isProcessing = isProcces;
  }
}
