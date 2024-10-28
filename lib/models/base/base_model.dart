import 'dart:convert';

import 'package:collection/collection.dart';

abstract class BaseModel<T> {
  //MAP
  BaseModel<T> fromMap(Map<String, dynamic> map);
  Map<String, dynamic> toMap();

  //JSON
  BaseModel<T> fromJson(String rawJson) =>
      fromMap(json.decode(rawJson) as Map<String, dynamic>);
  String toJson() => json.encode(toMap());

  bool equals(BaseModel<T> model) {
    return const DeepCollectionEquality().equals(toMap(), model.toMap());
  }
}
