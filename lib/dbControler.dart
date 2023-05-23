import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
var auth =  FirebaseAuth.instance;

//Stream<List<User>> readUsers() => FirebaseFirestore.instance.collection('usuario').snapshots().map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
//Retorna ultimo id da coleçao
Future<String> getLastId(String colecao) async {
  // obtenha uma referência para a coleção

  CollectionReference collectionRef = FirebaseFirestore.instance.collection(colecao);

// execute a consulta ordenando por ID em ordem decrescente e limitando a um único documento
//   Query query = collectionRef.orderBy('local/usuario', descending: true).limit(1);
//   print("-------------------------------------");
//   print(query);
  Query query = collectionRef.orderBy('id', descending: true).limit(1);
  QuerySnapshot querySnapshot = await query.get();
// verifique se a consulta retornou algum documento
  if (querySnapshot.docs.isNotEmpty) {
    // o último ID de documento é o ID do documento encontrado na consulta

    String ultimoId = (querySnapshot.docs.first.id);
    print('Último ID de documento: $ultimoId');
    return  ultimoId;
  }
  else {
    return '0';
  }
}

//Future criarUsuario({required int id , required Int id_usuario, required double latitude, required double longitude, required String casa}) async{
  Future criarUsuario({ required String login, required String nome, required String senha}) async{
    // var id =  ( int.parse(await getLastId('usuario'))+1);
    final json = {
      // "id": id,
      "login": login,
      "nome": nome,
      "senha": senha,
    };
    final docUsuario = FirebaseFirestore.instance.collection('usuario').doc(login);
    await docUsuario.set(json);
  }

  Future<Map<String, dynamic>?> lerUsuario(String nome) async {
    final docUsuario = FirebaseFirestore.instance.collection('usuario').doc(nome).id;
    //final docSnapshot = await docUsuario.get();

    print(docUsuario);
    // if (docSnapshot.exists) {
    //   return docSnapshot.data() as Map<String, dynamic>;
    // } else {
    //   return null;
    // }
  }



// Future<Map<String, dynamic>?> lerLocal(String nome) async {
Stream<QuerySnapshot<Map<String, dynamic>>> lerLocal() {
  User? user = auth.currentUser;
  var email = user?.email;
  final stream = FirebaseFirestore.instance.collection('local').where('id_usuario', isEqualTo:email).snapshots();
  return stream;
  // final docUsuario = FirebaseFirestore.instance.collection('local').doc(nome);
  // final docSnapshot = await docUsuario.get();
  //
  // if (docSnapshot.exists) {
  //   return docSnapshot.data() as Map<String, dynamic>;
  // } else {
  //   return null;
  // }
}

 criarLocal({ required double latitude, required double longitude, required String nome , required String endereco }) async {

  User? user = auth.currentUser;
  var email = user?.email;
  // print(email);
  // final querySnapshotId_usuario = await FirebaseFirestore.instance.collection('usuario').where('login',isEqualTo: email).limit(1).get();
  // var docsUsu = querySnapshotId_usuario.docs;
  // var id_usuario = (docsUsu.first.data())['id'];
  //final docUsuario = FirebaseFirestore.instance.collection('usuario').doc(email);

  // print(id_usuario);
  // print(id_usuario);
  var id = (int.parse(await getLastId('local'))+1);
  final json = {
    "id": id,
    "id_usuario":email,
    "latitude": latitude,
    "longitude": longitude,
    "nome": nome,
    "endereco": endereco,

  };
  final docUsuario = FirebaseFirestore.instance.collection('local').doc(id.toString());
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

// Future criarPlaca(String idLocal, String data,int quantidade,{ required String modelo, required kwh , required kpw }) async {
Future criarPlaca(int idLocal, String data,String quantidade,String modelo, String kwh ,String kpw ) async {

    // String lastId = await getLastId('placa');
    // if(lastId != null){
    //   int tmp = int.parse(lastId)+1;
    //   lastId = "$tmp";
    // }
  int id = int.parse(await getLastId("placa")) + 1;
    final json =  {
      "id_local": idLocal,
      "id": id,
      "data": data,
      "quantidade": quantidade,
      "modelo": modelo,
      "kwh":kwh,
      "kpw":kpw,
      //"id": last_id+1,
    };

    final docUsuario = FirebaseFirestore.instance.collection('placa').doc(id.toString());
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

Future criarManutencao(int idLocal, String contato,String data,String descricao, String realizador) async {
  // String id = "1";
  int id = int.parse(await getLastId("manutencao")) + 1;
  final json =  {
    "id": id,
    "id_local": idLocal,
    "contato": contato,
    "data": data,
    "descricao": descricao,
    "realizador":realizador,
  };

  final docUsuario = FirebaseFirestore.instance.collection('manutencao').doc(id.toString());
  await docUsuario.set(json);
}