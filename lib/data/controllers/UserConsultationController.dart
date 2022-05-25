import '../models/Consultations.dart';
import 'package:flutter/foundation.dart';

class UserConsultationController with ChangeNotifier {
  bool _isProcessing = false;
  List<Consultations> _listConsultationss = [];

  bool get isProcessing => _isProcessing;
  List<Consultations> get listConsultations {
    return [..._listConsultationss];
  }

  setConsultationsList(List<Consultations> list) {
    _listConsultationss = list;
    notifyListeners();
  }

  findConsultationsByStatus(String status) {
    _listConsultationss.where((element) {
      return element.statutConsultation == status;
    });
  }

  isProces(bool isProcces) {
    _isProcessing = isProcces;
  }
}
