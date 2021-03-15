import 'package:cloud_firestore/cloud_firestore.dart';

class DateHelper{
  Timestamp fromDateTimeToTimestamp(DateTime dateTime){
    return Timestamp.fromDate(dateTime);
  }

  DateTime fromTimestampToDateTime(Timestamp timestamp){
    return timestamp.toDate();
  }

  bool isSameDate(DateTime a, DateTime b){
    if(a.day == b.day && a.month == b.month && a.year ==b.year){
      return true;
    }
    return false;
  }
}