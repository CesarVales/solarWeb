import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

//Stream<List<User>> readUsers() => FirebaseFirestore.instance.collection('usuario').snapshots().map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
//Retorna ultimo id da coleçao
Future<String> getLastId(String colecao) async {
  // obtenha uma referência para a coleção

  CollectionReference collectionRef = FirebaseFirestore.instance.collection(colecao);

// execute a consulta ordenando por ID em ordem decrescente e limitando a um único documento
  Query query = collectionRef.orderBy('local/usuario', descending: true).limit(1);
  print("-------------------------------------");
  print(query);

  QuerySnapshot querySnapshot = await query.get();
// verifique se a consulta retornou algum documento
  if (querySnapshot.docs.isNotEmpty) {
    // o último ID de documento é o ID do documento encontrado na consulta
    String ultimoId = (querySnapshot.docs.first.id) ;
    print('Último ID de documento: $ultimoId');
    return  ultimoId;
  }
  else {
    return '0';
  }
}

//Future criarUsuario({required int id , required Int id_usuario, required double latitude, required double longitude, required String casa}) async{
  Future criarUsuario({ required String login, required String nome, required String senha}) async{
    final json = {
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

Future deletePlaca({ required String modelo }) async {

  final docUsuario = FirebaseFirestore.instance.collection('placa').doc(modelo);
  await docUsuario.delete();
}

Future updatePlaca( String data,int quantidade,String modelo, double kwh ,double kpw ) async {//latitude e longitude opcionais
  final json =  {
    "data": data,
    "quantidade": quantidade,
    "modelo": modelo,
    "kwh":kwh,
    "kpw":kpw,
    //"id": last_id+1,
  };

  final docUsuario = FirebaseFirestore.instance.collection('local').doc(modelo);
  await docUsuario.update(json);
}

Future criarManutencao(String contato,String data,String descricao, String realizador) async {

  final json =  {
    "contato": contato,
    "data": data,
    "descricao": descricao,
    "realizador":realizador,
    "id": getLastId('placa'),
  };

  final docUsuario = FirebaseFirestore.instance.collection('placa').doc(contato);
  await docUsuario.set(json);
}