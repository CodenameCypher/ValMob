import 'package:intl/intl.dart';

class Test{
  void test(){
    String s1 = '12m';
    String s2 = '13h 12m';
    String s3 = '1d 0h';
    String s4 = '10:00 PM';

    print(DateTime.now());
    DateTime date = calculateDateTime(s3); // date
    DateTime time = DateFormat("hh:mm a",'en-us').parse(s4); // time
    String dateTime = date.year.toString()+"-"+date.month.toString()+"-"+date.day.toString()+" "+s4;
    DateTime dateParsed = DateFormat("yyyy-MM-dd hh:mm a","en-us").parse(date.year.toString()+"-"+date.month.toString()+"-"+date.day.toString()+" "+s4);
    print(dateParsed);
    print(dateTime);
  }
  
  
  DateTime calculateDateTime(String eta){
    DateTime dateTime = DateTime.now();
    List<String> strings = eta.split(" ");
    for(var i = 0; i < strings.length ; i++){
      String current = strings[i];
      if(current[current.length-1] == 'd'){
        dateTime = dateTime.add(Duration(days: int.parse(current.substring(0,current.length-1))));
      }
      else if(current[current.length-1] == 'h'){
        dateTime = dateTime.add(Duration(hours: int.parse(current.substring(0,current.length-1))));
      }else{
        dateTime = dateTime.add(Duration(minutes: int.parse(current.substring(0,current.length-1))));
      }
    }
    return dateTime;
  }
}