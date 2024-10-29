import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desafio_quality/models/base/base_model.dart';

class FirebaseService {
  FirebaseService._();

  static Future<List<T>> getListWithCondition<T>({
    required String collection,
    required String field,
    required String isEqualTo,
    required BaseModel<T> modelEmpty,
  }) async {
    if (isEqualTo.isEmpty || collection.isEmpty) {
      return Future.error('Dados Inválidos para buscar', StackTrace.current);
    }
    try {
      List<T> res = [];
      final response = await FirebaseFirestore.instance
          .collection(collection)
          .where(field, isEqualTo: isEqualTo)
          .get();
      for (var element in response.docs) {
        if (element.exists) {
          res.add(modelEmpty.fromMap(element.data()) as T);
        }
      }

      return res;
    } catch (e, stackTrace) {
      return Future.error(e.toString(), stackTrace);
    }
  }

  static Future<String> insert({
    required BaseModel data,
    required String collection,
  }) async {
    if (collection.isEmpty) {
      return Future.error('Dados Inválidos para cadastrar', StackTrace.current);
    }
    try {
      var json = data.toMap();
      final response =
          await FirebaseFirestore.instance.collection(collection).add(json);
      return response.id;
    } catch (e, stackTrace) {
      return Future.error('Erro ao tentar Cadastrar', stackTrace);
    }
  }

  static Future<void> update({
    required String collection,
    required String id,
    required BaseModel data,
  }) async {
    if (id.isEmpty || collection.isEmpty) {
      return Future.error('Dados Inválidos para atualizar', StackTrace.current);
    }
    try {
      var json = data.toMap();
      json['updatedAt'] = DateTime.now();
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(id)
          .set(json, SetOptions(merge: true));
    } catch (e, stackTrace) {
      return Future.error(e.toString(), stackTrace);
    }
  }

  static Future<void> delete({
    required String collection,
    required String id,
  }) async {
    if (id.isEmpty || collection.isEmpty) {
      return Future.error('Dados Inválidos para atualizar', StackTrace.current);
    }
    try {
      await FirebaseFirestore.instance.collection(collection).doc(id).delete();
    } catch (e, stackTrace) {
      return Future.error(e.toString(), stackTrace);
    }
  }
}
