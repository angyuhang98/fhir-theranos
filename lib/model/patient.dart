import 'dart:ffi';
import 'package:Theranos/model/patient_record.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Patient {
  int _id;
  String _name;
  double _totalCholesterol;
  String _effectiveDateTime;
  String _gender;
  String _dateOfBirth;
  String _city;
  String _state;
  String _country;
  String _postalCode;
  bool _isHighlighted;
  List<PatientRecord> _patientData;

  List _diastolicData;
  List _systolicData;
  List _BPEffectiveTime;

  Patient({int id,name, String effectiveDateTime, double totalCholesterol,String gender, String dateOfBirth, String city, String state, String country, String postalCode,bool isHighlighted, List diastolicList, List systolicList,List BPEffectiveTime}):
  _id =id,
  _name = name, 
  _dateOfBirth =dateOfBirth,
  _gender = gender,
  _effectiveDateTime = effectiveDateTime,
  _totalCholesterol = totalCholesterol,
  _isHighlighted = isHighlighted,
  _city = city,
  _state = state,
  _country = country,
  _postalCode = postalCode,
  _patientData = [],

  _diastolicData = diastolicList,
  _systolicData = systolicList,
  _BPEffectiveTime = BPEffectiveTime;

  void  setDate(String date) => _effectiveDateTime = date;
  void  setCholesterol(double cholesterol) => _totalCholesterol = cholesterol;
  void  setIsHighLighted(bool truefalse) => _isHighlighted = truefalse;
  void addPatientData(PatientRecord record) => _patientData.add(record);


  void setDiastolicData(List diastolicList) => _diastolicData = diastolicList;
  void setSystolicData(List systolicList) => _systolicData = systolicList;
  void setBPEffectiveTime(List BPTime) => _BPEffectiveTime = BPTime;


  String getGender(){return _gender;}
  int getID(){return _id;}
  String getName(){return _name;}
  double getCholesterol(){return _totalCholesterol;}
  String getEffectiveDateTime(){return _effectiveDateTime;}
  bool getIsHighlighted(){return _isHighlighted;}
  String getCity(){return _city;}
  String getState(){return _state;}
  String getCountry(){return _country;}
  String getPostalCode(){return _postalCode;}
  String getDateOfBirth(){return _dateOfBirth;}

  List getDiastolicData(){return _diastolicData;}
  List getSystolicData(){return _systolicData;}
  List getBPEffectiveTime(){return _BPEffectiveTime;}

  PatientRecord getLatestRecord(){
    if (_patientData.length > 0){
     return  _patientData[0];
     }
     else{
     return  PatientRecord(time: "NaN",systolicBloodPressure: 0, diastolicBloodPressure: 0);
     }

  }
  List<PatientRecord> getAllRecord(){
    return _patientData;
  }
  
}


