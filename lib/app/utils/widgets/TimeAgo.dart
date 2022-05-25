import 'package:intl/intl.dart';

class TimeAgo {
  static String timeAgoSinceDate(String time) {
    DateTime notificationDate = DateTime.parse(time);

    final date2 = DateTime.now();
    final diff = date2.difference(notificationDate);

    if (diff.inDays > 8)
      return DateFormat("dd-MM-yyyy").format(notificationDate);
      // return DateFormat("dd-MM-yyyy HH:mm:ss").format(notificationDate);
    else if ((diff.inDays / 7).floor() >= 1)
      return "Semaine dernière";
    else if (diff.inDays >= 2)
      return "Il y a ${diff.inDays} jours";
    else if (diff.inDays >= 1)
      return "Il y a 1 jour";
    else if (diff.inHours >= 2)
      return "Il y a ${diff.inHours} heures";
    else if (diff.inHours >= 1)
      return "Il y a 1 heure";
    else if (diff.inMinutes >= 2)
      return "Il y a ${diff.inMinutes} minutes";
    else if (diff.inMinutes >= 1)
      return "Il y a 1 minute";
    else if (diff.inSeconds >= 3)
      return "Il y a ${diff.inSeconds} secondes";
    else
      return "À l'instant";
  }
  

  static bool isSameDay(String time) {
    DateTime notificationDate = DateTime.parse(time);

    final date2 = DateTime.now();
    final diff = date2.difference(notificationDate);

    if (diff.inDays > 0)
      return false;
    else
      return true;
  }

  static bool isSameMinutes(String time) {
    DateTime notificationDate = DateTime.parse(time);

    final date2 = DateTime.now();
    final diff = date2.difference(notificationDate);

    if (diff.inMinutes > 0)
      return false;
    else
      return true;
  }
}
