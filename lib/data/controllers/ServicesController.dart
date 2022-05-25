import '../models/Services.dart';
import 'package:flutter/foundation.dart';

class ServicesController with ChangeNotifier {
  bool _isProcessing = false;
  List<Services> _listServicess = [];

  bool get isProcessing => _isProcessing;
  List<Services> get listServicess {
    return [..._listServicess];
  }

  setServicesList(List<Services> list) {
    _listServicess = list;
    notifyListeners();
  }

  isProces(bool isProcces) {
    _isProcessing = isProcces;
  }
}
