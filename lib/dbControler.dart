import 'package:cloud_firestore/cloud_firestore.dart';

//Stream<List<User>> readUsers() => FirebaseFirestore.instance.collection('usuario').snapshots().map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());

//Future criarUsuario({required int id , required Int id_usuario, required double latitude, required double longitude, required String casa}) async{
  Future criarUsuario({required int id , required String login, required String nome, required String senha}) async{

    final json = {
      "id": id,
      "login": login,
      "nome": nome,
      "senha": senha,

    };
    final docUsuario = FirebaseFirestore.instance.collection('usuario').doc(nome);
    await docUsuario.set(json);
  }

  Future<Map<String, dynamic>?> lerUsuario(String nome) async {
    final docUsuario = FirebaseFirestore.instance.collection('usuario').doc(nome);
    final docSnapshot = await docUsuario.get();

    if (docSnapshot.exists) {
      return docSnapshot.data() as Map<String, dynamic>;
    } else {
      return null;
    }
  }



Future<Map<String, dynamic>?> lerLocal(String nome) async {
  final docUsuario = FirebaseFirestore.instance.collection('local').doc(nome);
  final docSnapshot = await docUsuario.get();

  if (docSnapshot.exists) {
    return docSnapshot.data() as Map<String, dynamic>;
  } else {
    return null;
  }
}

Future criarLocal({ required double latitude, required double longitude, required String nome }) async {
  final json = {
    "latitude": latitude,
    "longitude": longitude,
    "nome": nome,

  };
  final docUsuario = FirebaseFirestore.instance.collection('local').doc(nome);
  await docUsuario.set(json);
}

Future updateLocal(  String nome,[double? latitude,  double? longitude,String? nomeNovo]) async {//latitude e longitude opcionais
  final json = () {
    if(nomeNovo == null) {
      return {
        "latitude": latitude,
        "longitude": longitude,
        "nome": nome,
      };
    } else {
      return {
        "latitude": latitude,
        "longitude": longitude,
        "nome": nomeNovo,
      };
    }
  }();

  final docUsuario = FirebaseFirestore.instance.collection('local').doc(nome);
  await docUsuario.update(json);
}



Future deleteLocal({ required String nome }) async {

  final docUsuario = FirebaseFirestore.instance.collection('local').doc(nome);
  await docUsuario.delete();
}

Future criarPlaca(String data,int quantidade,{ required String modelo, required kwh , required kpw }) async {


    final json =  {
      "data": data,
      "quantidade": quantidade,
      "modelo": modelo,
      "kwh":kwh,
      "kpw":kpw,
      //"id": last_id+1,
    };

    final docUsuario = FirebaseFirestore.instance.collection('placa').doc(modelo);
    await docUsuario.set(json);
}

Future<Map<String, dynamic>?> lerPlaca(String modelo) async {
  final docUsuario = FirebaseFirestore.instance.collection('placa').doc(modelo);
  final docSnapshot = await docUsuario.get();

  if (docSnapshot.exists) {
    return docSnapshot.data() as Map<String, dynamic>;
  } else {
    return null;
  }
}

