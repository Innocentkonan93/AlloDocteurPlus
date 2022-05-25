import '../models/ServicesType.dart';
import 'package:flutter/foundation.dart';

class ServicesTypeController with ChangeNotifier {
  bool _isProcessing = false;
  List<ServicesType> _listServicesTypes = [];

  bool get isProcessing => _isProcessing;
  List<ServicesType> get listServicesTypes {
    return [..._listServicesTypes];
  }

  setServicesTypeList(List<ServicesType> list) {
    _listServicesTypes = list;
    notifyListeners();
  }

  isProces(bool isProcces) {
    _isProcessing = isProcces;
  }
}
