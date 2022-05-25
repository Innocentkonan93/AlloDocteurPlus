
import 'package:flutter/material.dart';

import '../models/programme.dart';


class ProgrammeController with ChangeNotifier {
  bool _isProcessing = false;
  List<Programme> _listProgrammes = [];

  bool get isProcessing => _isProcessing;
  List<Programme> get listProgrammes {
    return [..._listProgrammes];
  }

  setProgrammeList(List<Programme> list) {
    _listProgrammes = list;
    notifyListeners();
  }

  cleanProgrammeData() {
    _listProgrammes.clear();
    print('Programme clean');
    notifyListeners();
  }

  isProces(bool isProcces) {
    _isProcessing = isProcces;
  }
}
