
import '../models/Curriculum.dart';
import 'package:flutter/material.dart';

class PraticienCurriculum with ChangeNotifier {
  bool _isProcessing = false;
  List<Curriculums> _listCurriculums = [];

  bool get isProcessing => _isProcessing;
  List<Curriculums> get listCurriculums {
    return [..._listCurriculums];
  }

  setCurriculumsList(List<Curriculums> list) {
    _listCurriculums = list;
    notifyListeners();
  }

  cleanCurriculumsData() {
    _listCurriculums.clear();
    print('Curriculums clean');
    notifyListeners();
  }

  isProces(bool isProcces) {
    _isProcessing = isProcces;
  }
}
