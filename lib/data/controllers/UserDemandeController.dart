import '../models/Demandes.dart';
import 'package:flutter/foundation.dart';

class UserDemandeDemandeController with ChangeNotifier {
  bool _isProcessing = false;
  List<UserDemande> _listUserDemandes = [];

  bool get isProcessing => _isProcessing;
  List<UserDemande> get listUserDemandes {
    return [..._listUserDemandes];
  }

  setUserDemandeList(List<UserDemande> list) {
    _listUserDemandes = list;
    notifyListeners();
  }

  isProces(bool isProcces) {
    _isProcessing = isProcces;
    notifyListeners();
  }
}
