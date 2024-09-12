import 'package:intl/intl.dart';

String formatDate(String? date) {
  if (date == null || date.isEmpty) return 'No expiry';
  final DateTime parsedDate = DateTime.parse(date);
  final DateFormat formatter = DateFormat('dd/MM/yy');
  return formatter.format(parsedDate);
}
