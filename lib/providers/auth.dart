import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/model/exception.dart';

class Auth with ChangeNotifier {
  String? _userId;
  String? _token;
  DateTime? _expiryDate;
  Timer? _authTimer;

  get token {
    if (_token != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _expiryDate != null) {
      return _token!;
    }
    return null;
  }

  bool get isAuth {
    return  token != null;
  }

  String get userId {
    return _userId!;
  }

  Future<void> _authentication(
      String email, String password, String urlSegment) async {
    String url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBh-kjdfuJRxrfiU3IG1AbI7lI471S0nik';
    try {
      final res = await http.post(Uri.parse(url),
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final resData = json.decode(res.body);
      if (resData['error'] != null) {
       throw HttpException(resData['error']['message']);
      }
      _token = resData['idToken'];
      _userId = resData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(resData['expiresIn'])));
      notifyListeners();
      _autoLogOut();
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final saveResData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String(),
      });
      sharedPreferences.setString('userData', saveResData);
    } catch (e) {
      throw e;
    }
  }

  Future<void> signUp(String email, String password) async{
    return  _authentication(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async{
    return _authentication(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) return false;
    final extractData =
        json.decode(prefs.getString('userData')!) as Map<String, Object>;
    final expiryDateAuto = DateTime.parse(extractData['expiryDate'].toString());
    if (expiryDateAuto.isBefore(DateTime.now())) return false;
    _token = extractData['token'].toString();
    _userId = extractData['userId'].toString();
    _expiryDate = expiryDateAuto;
    notifyListeners();
    _autoLogOut();
    return true;
  }

  Future<void>logOut()async{
    _token=null;
    _userId=null;
    _expiryDate=null;
    if(_authTimer!=null){
      _authTimer!.cancel();
      _authTimer=null;
    }
    final prefs=await SharedPreferences.getInstance();
    prefs.remove('userData');
  }
  void _autoLogOut(){
    if(_authTimer!=null){
      _authTimer!.cancel();

    }
    final timeToExpiry=_expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer=Timer(Duration(seconds: timeToExpiry),logOut);
  }


}
