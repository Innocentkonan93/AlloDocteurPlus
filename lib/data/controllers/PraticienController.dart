import '../models/Praticien.dart';
import 'package:flutter/material.dart';

class PraticienController with ChangeNotifier {
  bool _isProcessing = false;
  List<Praticien> _listPraticiens = [];

  bool get isProcessing => _isProcessing;
  List<Praticien> get listPraticiens {
    return [..._listPraticiens];
  }

  setPraticienList(List<Praticien> list) {
    _listPraticiens = list;
    notifyListeners();
  }

  cleanPraticienData() {
    _listPraticiens.clear();
    print('praticien clean');
    notifyListeners();
  }

  isProces(bool isProcces) {
    _isProcessing = isProcces;
  }
}
