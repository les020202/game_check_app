import 'package:flutter/material.dart';

import '../../models/user_agreement.dart';
import '../../services/firestore_support_service.dart';

class FirestoreSupportProvider extends ChangeNotifier{
  FirestoreSupportService _service;
  FirestoreSupportProvider(this._service);

  UserAgreement? _agreement;
  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  UserAgreement? get agreement => _agreement;

  Future<void> loadAgreement() async {
    _agreement = await _service.getUserAgreement();
    notifyListeners();
  }

  // Future<void> saveAgreement(UserAgreement agreement) async {
  //   await _service.setUserAgreement(agreement);
  //   await loadAgreement();
  // }

  Future<void> setMarketingConsent(bool value) async {
    await _service.updateMarketingConsent(value);
    await loadAgreement();
  }
}
