import 'package:intl/intl.dart';

const String systolicBloodPressureUnit = " mmHg";
const String diastolicBloodPressureUnit = " mmHg";

int normalSystolicBloodPressure = 140;
int normalDiastolicBloodPressure = 90;

class PatientRecord{


String _time;

double _systolicBloodPressure;
double _diastolicBloodPressure;


PatientRecord({ double systolicBloodPressure,String time, double diastolicBloodPressure})
:

_time = time,
_systolicBloodPressure = systolicBloodPressure,
_diastolicBloodPressure = diastolicBloodPressure;


// unit names



String getTime(){return _time;}
String getShortTime(){
  String timewithoutweek = this.getTime().split(",")[1];


  return timewithoutweek;

}


double getSystolicBloodPressure(){return _systolicBloodPressure;}
double getDiastolicBloodPressure(){return _diastolicBloodPressure;}

//return string output of data
String getSystolicBloodPressure_str(){return _systolicBloodPressure.toString()+systolicBloodPressureUnit;}
String getDiastolicBloodPressure_str(){return _diastolicBloodPressure.toString()+diastolicBloodPressureUnit;}

bool isSystolicHighlighted (){return _systolicBloodPressure > normalSystolicBloodPressure;}
bool isDiastolicHighlighted (){return _diastolicBloodPressure > normalDiastolicBloodPressure;}

}

