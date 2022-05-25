import 'package:flutter/foundation.dart';

import '../models/Departement.dart';

class DepartementController with ChangeNotifier {
  bool _isProcessing = false;
  List<Departement> _listDepartements = [];

  bool get isProcessing => _isProcessing;
  List<Departement> get listDepartements {
    return [..._listDepartements];
  }

  setDepartementList(List<Departement> list) {
    _listDepartements = list;
    notifyListeners();
  }

  isProces(bool isProcces) {
    _isProcessing = isProcces;
  }
}
