import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Tools {

  static String formatDateToString(DateTime dateTime) {
    // Define o formato de saída
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');

    // Retorna a data formatada como String
    return dateFormat.format(dateTime);
  }

  static DateTime toDate(Timestamp timestamp) => timestamp.toDate();
}
