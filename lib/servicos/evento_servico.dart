import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:score_your_point/modelos/evento_modelo.dart';

class EventoServico {
  String userId;
  EventoServico() : userId = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> adicionarEvento(EventoModelo eventoModelo) async {
    return await _firestore
        .collection(userId)
        .doc(eventoModelo.id)
        .set(eventoModelo.toMap());
  }

  //método de leitura
  Stream<QuerySnapshot<Map<String, dynamic>>> conectarStreamEventos(
      bool isDecrecente) {
    return _firestore
        .collection(userId)
        .orderBy("local", descending: isDecrecente)
        .snapshots();
  }

  //método de remoção
  Future<void> removerEvento({required String idEvento}) {
    return _firestore.collection(userId).doc(idEvento).delete();
  }
}
