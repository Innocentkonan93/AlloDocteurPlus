import '../models/UserDocuments.dart';
import 'package:flutter/foundation.dart';

class UserDocumentsController with ChangeNotifier {
  bool _isProcessing = false;
  List<UserDocuments> _listUserDocuments = [];

  bool get isProcessing => _isProcessing;
  List<UserDocuments> get listUserDocuments {
    return [..._listUserDocuments];
  }

  setUserDocumentsList(List<UserDocuments> list) {
    _listUserDocuments = list;
    notifyListeners();
  }

  isProces(bool isProcces) {
    _isProcessing = isProcces;
  }
}
