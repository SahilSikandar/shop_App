import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/provider/model/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? autoTimer;
  bool get isAuth {
    return token != "";
  }

  String get token {
    if (_token != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _expiryDate != null) {
      return _token!;
    }
    return "";
  }

  String get userId {
    return _userId.toString();
  }

  Future<void> _authenticate(
      String email, String pass, String urlSegemnet) async {
    try {
      final url = Uri.parse(
          'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegemnet?APi_key');
      final response = await http.post(url,
          body: json.encode(
              {'email': email, 'password': pass, 'returnSecureToken': true}));
      //print(response.body);
      final responseData = json.decode(response.body);
      if (responseData == null || responseData.containsKey('error')) {
        throw HttpExceptions(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      autoLogOut();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String()
      });
      prefs.setString('userData', userData);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> signUp(String email, String pass) async {
    return _authenticate(email, pass, 'signUp');
    //notifyListeners();
  }

  Future<void> signIn(String email, String pass) async {
    return _authenticate(email, pass, 'signInWithPassword');
    //notifyListeners();
  }

  Future<bool> autoSignIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey('userData')) {
        return false;
      }

      final extractedData =
          json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
      final expiryData = DateTime.parse(extractedData['expiryDate'] as String);

      if (expiryData.isBefore(DateTime.now())) {
        return false;
        //eturn true;
      }
      _expiryDate = expiryData;
      _token = extractedData['token'] as String;
      _userId = extractedData['userId'] as String;
      notifyListeners();
      autoLogOut();
    } catch (e) {
      rethrow;
    }
    return true;
    //notifyListeners();
  }

  Future<void> logOut() async {
    _expiryDate = null;
    _token = null;
    _userId = null;
    autoTimer = null;
    if (autoTimer != null) {
      autoTimer!.cancel();
      autoTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void autoLogOut() {
    if (autoTimer != null) {
      autoTimer!.cancel();
    }
    final expireTime = _expiryDate!.difference(DateTime.now()).inSeconds;
    autoTimer = Timer(Duration(seconds: expireTime), () {
      logOut();
    });
    //notifyListeners();
  }
}
