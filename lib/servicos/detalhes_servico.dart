import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../modelos/detalhes_modelo.dart';

class DetalhesServico {
  String userId;
  DetalhesServico() : userId = FirebaseAuth.instance.currentUser!.uid;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String key = "detalhes";

  Future<void> adicionarDetalhes({
      required String idEvento, required DetalhesModelo detalhesModelo,}) async {
    return await _firestore
        .collection(userId)
        .doc(idEvento)
        .collection(key)
        .doc(detalhesModelo.id)
        .set(detalhesModelo.toMap());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> conectarStream(
      {required String idEvento}) {
    return _firestore
        .collection(userId)
        .doc(idEvento)
        .collection(key)
        .orderBy("data", descending: true)
        .snapshots();
  }

  Future<void> removerDetalhes(
      {required String eventoId, required String detalhesId}) async {
    return _firestore
        .collection(userId)
        .doc(eventoId)
        .collection(key)
        .doc(detalhesId)
        .delete();
  }
}
