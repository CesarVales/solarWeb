import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

class AuthException implements Exception{//Classe para erro de login e registro
  String message;
  AuthException(this.message);
}
class AuthService extends ChangeNotifier{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? usuario;
  bool isLoading = true;

  AuthService(){
    _authCheck();
  }
   _authCheck(){
      _auth.authStateChanges().listen((User? user) {
        usuario = (user == null) ? null : user;
        isLoading = false;
        notifyListeners();
      });

  }
  _getUser() {
    usuario = _auth.currentUser;
    notifyListeners();
  }
  registrar(String email, String senha) async {
    try{
      await _auth.createUserWithEmailAndPassword(email: email, password: senha);
      _getUser();

    }on FirebaseAuthException catch(e){
        if(e.code == "weak-password") {
          throw AuthException('A senha é muito Fraca');
        } else if(e.code == 'email-already-in-use') {
          throw AuthException('Email já cadastrado');
          
        }
    }

  }

  login(String email, String senha) async {
    try{
      await _auth.signInWithEmailAndPassword(email: email, password: senha);
      _getUser();

    }on FirebaseAuthException catch(e){
      if(e.code == "user-not-found") {
        throw AuthException('Email não encontrado');
      } else if(e.code == 'wrong-password') {
        throw AuthException('senha errada');

      }
    }

  }
  logout() async {
    await _auth.signOut();
    _getUser();

  }
}



