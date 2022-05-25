
import 'package:flutter/material.dart';

import '../models/Pharmacies.dart';

class PharmacieController with ChangeNotifier {
  bool _isProcessing = false;
  List<Pharmacie> _listPharmacies = [];

  bool get isProcessing => _isProcessing;
  List<Pharmacie> get listPharmacies {
    return [..._listPharmacies];
  }

  setPharmacieList(List<Pharmacie> list) {
    _listPharmacies = list;
    notifyListeners();
  }

  cleanPharmacieData() {
    _listPharmacies.clear();
    print('Pharmacie clean');
    notifyListeners();
  }

  isProces(bool isProcces) {
    _isProcessing = isProcces;
  }
}
