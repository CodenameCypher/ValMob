import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Test{
  void test() async{
    String s1 = "6h 24m from now";
    String s2 = "1d 1h from now";

    calculateDateTime(s1);
    // calculateDateTime(s2);
  }

  DateTime calculateDateTime(String eta){
    DateTime dateTime = DateTime.now();
    List<String> strings = eta.split(" ");
    for(var i = 0; i < strings.length - 2 ; i++){
      String current = strings[i];
      // print(current);
      if(current[current.length-1] == 'd'){
        dateTime = dateTime.add(Duration(days: int.parse(current.substring(0,current.length-1))));
      }
      else if(current[current.length-1] == 'h'){
        dateTime = dateTime.add(Duration(hours: int.parse(current.substring(0,current.length-1))));
      }else{
        dateTime = dateTime.add(Duration(minutes: int.parse(current.substring(0,current.length-1))));
      }
    }
    print("Prev time: "+dateTime.toString());
    dateTime = alignDateTime(dateTime, Duration(minutes: 15), true);
    DateTime dateTime2 = alignDateTime(dateTime, Duration(minutes: 15), false);
    print("New time: "+dateTime.toString());
    print("New time 2: "+dateTime2.toString());
    print(dateTime.difference(dateTime2));

    print(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour+1));
    return dateTime;
  }

  DateTime alignDateTime(DateTime dt, Duration alignment,bool roundUp) {
    assert(alignment >= Duration.zero);
    if (alignment == Duration.zero) return dt;
    final correction = Duration(
        days: 0,
        hours: alignment.inDays > 0
            ? dt.hour
            : alignment.inHours > 0
            ? dt.hour % alignment.inHours
            : 0,
        minutes: alignment.inHours > 0
            ? dt.minute
            : alignment.inMinutes > 0
            ? dt.minute % alignment.inMinutes
            : 0,
        seconds: alignment.inMinutes > 0
            ? dt.second
            : alignment.inSeconds > 0
            ? dt.second % alignment.inSeconds
            : 0,
        milliseconds: alignment.inSeconds > 0
            ? dt.millisecond
            : alignment.inMilliseconds > 0
            ? dt.millisecond % alignment.inMilliseconds
            : 0,
        microseconds: alignment.inMilliseconds > 0 ? dt.microsecond : 0);
    if (correction == Duration.zero) return dt;
    final corrected = dt.subtract(correction);
    final result = roundUp ? corrected.add(alignment) : corrected;
    return result;
  }
}