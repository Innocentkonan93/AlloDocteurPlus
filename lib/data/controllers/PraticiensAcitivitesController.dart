import 'package:flutter/foundation.dart';

import '../models/ActivitesPraticiens.dart';

class PraticiensActivitesController with ChangeNotifier {
  bool _isProcessing = false;
  List<ActivitesPraticiens> _listActivitesPraticiens = [];

  bool get isProcessing => _isProcessing;
  List<ActivitesPraticiens> get listActivitesPraticiens {
    return [..._listActivitesPraticiens];
  }

  setActivitesPraticiensList(List<ActivitesPraticiens> list) {
    _listActivitesPraticiens = list;
    notifyListeners();
  }

  isProces(bool isProcces) {
    _isProcessing = isProcces;
  }
}
