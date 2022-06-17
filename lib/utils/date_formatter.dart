
import 'package:intl/intl.dart';

formatDate(String date){
   
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  final String formatted = formatter.format(DateTime.parse(date));

  return formatted;
}