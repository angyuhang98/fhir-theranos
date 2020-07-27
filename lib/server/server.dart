import 'package:Theranos/constant.dart';
import 'package:Theranos/model/patient.dart';
import 'package:Theranos/model/patient_record.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:core';
import 'package:intl/intl.dart';

String root_url = 'https://fhir.monash.edu/hapi-fhir-jpaserver/fhir/';
String patients_url = root_url +"Patient";
String patient_id_url = patients_url +"/1";
String search1_url = root_url +"Observation?patient=6430";
String search2_url = root_url +"Observation?patient=6430&code=2093-3";
String search3_url= root_url +"Observation?patient=3689&code=2093-3&_sort=date&_count=13";

Future<List> retrivePatientOption() async{
    List<String> patientListData =  practitionerObj.getPatientList();
    List<Patient> patientInfoData = await patientObj.getPatient(patientListData);

    return patientInfoData;
  }


Future retrievePatientList() async {
    List<Patient> emptylist = [];
    List<Patient> patientList =  patientObj.getPatientList();
    List<Patient> patientMonitored = patientObj.getPatientMonitored();

    if (patientMonitored.length == 0) {
    return emptylist;
  }
    else if (patientList.length == 0 ){
    List<Patient> patientInfoData = await patientObj.updateData(patientMonitored);
    return patientInfoData;
  }
  else{
    return patientList;
  }
}




class NetWorkPractitioner{
  List<String> _patientList = [];
  int _pin;

  List getPatientList(){
    return _patientList;
  }
  
  int getPin(){
    return _pin;
  }
  void setPin(int pin){
    _pin = pin;
  }

  Future<List<String>> getData(pin) async{ //pin argument is the user input pin
    String practitionerUrl=root_url+"Practitioner/"+pin.toString(); //get practitioner info with id of 1381208
    http.Response response = await http.get(practitionerUrl);
    if (response.statusCode == 200) { //if data exist
      //get practitioner's info
      String practitionerData = response.body;
      Map decodedPractitionerData = jsonDecode(practitionerData);

      //get practitioner's info based on his/her identifier
      String practitionerIdentifier = decodedPractitionerData['identifier'][0]['system']; //practitioner's identifier
      String practitionerIdentifierUrl = root_url + "Encounter?participant.identifier=" + practitionerIdentifier + "|500&_include=Encounter.participant.individual&_include=Encounter.patient";

      bool nextPage = true;
      String nextPageUrl = practitionerIdentifierUrl; //url to proceed to next page
      int pageCount = 0; //counter of page
      List <String> patientList = [];  //list containing all patients

      while(nextPage){ //while nextPage == True
        http.Response practitionerEncountersRes = await http.get(nextPageUrl);
        String practitionerEncountersData = practitionerEncountersRes.body;
        Map decodedPracEncountersData = jsonDecode(practitionerEncountersData);

        nextPage = false;
        List links = decodedPracEncountersData['link'];

        //iterate through all pages
        for( int i = 0 ; i < links.length ; i++ ){
          Map link = links[i];
          if (link['relation'] == 'next'){
            //nextPage = true; //comment out for just proceed to next page prevent running too many pages (page count is 1)
            nextPage = false; //(page count is 1) while loop is run once
            nextPageUrl = link['url'];
            pageCount += 1;
          }
        }

        List overallEncounterData = decodedPracEncountersData['entry'];

        for ( int j = 0 ; j < overallEncounterData.length ; j++ ){ // j < overallEncounterData.length
          Map entryData = overallEncounterData[j];
          Map resourceData = entryData['resource'];
          Map subjectData = resourceData['subject'];
          String patientReference = subjectData['reference'];
          String patientID = patientReference.split('/')[1]; //getting patient ID from reference
          patientList.add(patientID); //append patient ID to list named patientList
        }
      } //end brackets of while loop

      patientList = patientList.toSet().toList(); //removing duplicate patient id from list
      _patientList = patientList;

      return patientList;
    } else {
      return []; //return empty list if no data
    }
  }
}

class NetWorkPatient{

  List<Patient> _patientList = [];

  List<Patient> _patientsMonitored = [];

  List<Patient> getPatientMonitored(){
      return _patientsMonitored;
  }
  List<Patient> getPatientList(){
      return _patientList;
  }
  

  void addPatientsMonitored(Patient patientToMonitored){
    _patientsMonitored.add(patientToMonitored);
  }
  void removePatientsMonitored(Patient patientToMonitored){
     _patientsMonitored.removeWhere((item) => item.getID() == patientToMonitored.getID());
  }

  Future<List<Patient>> getPatient(List<String> patientList) async{
    int patientCount = patientList.length; //total number of patients monitored by practitioner
    List<Patient> output = [];

    for ( int k = 0 ; k < patientCount ; k++ ){
      //Check whether the patient already been monitored
      String patientId = patientList[k];
      bool alreadyExist = false;

      for (int i=0;i<_patientsMonitored.length;i++){

        if(_patientsMonitored[i].getID().toString()==patientId){
          alreadyExist = true;
          break;
        }
      }
      if (alreadyExist) continue;
      //getting patient's name from his/her id
      String patientPersonalInfoUrl =  root_url + "Patient/" + patientId;

      //getting patient's personal info
      http.Response patientPersonalInfoResponse = await http.get(patientPersonalInfoUrl);
      String patientPersonalInfo = patientPersonalInfoResponse.body;
      
      Map decodedPatientPersonalInfo = jsonDecode(patientPersonalInfo);
      Map patientNameInfo = decodedPatientPersonalInfo['name'][0]; //getting patientNameInfo as hash table format
      String patientGender = decodedPatientPersonalInfo['gender'];
      patientGender = patientGender.substring(0,1).toUpperCase() + patientGender.substring(1);
      String patientDateOfBirth = decodedPatientPersonalInfo['birthDate'];
      String patientCity = decodedPatientPersonalInfo['address'][0]['city'];
      String patientState = decodedPatientPersonalInfo['address'][0]['state'];
      String patientCountry = decodedPatientPersonalInfo['address'][0]['country'];
      String patientPostalCode;

      //handle address with no postal code
      if(decodedPatientPersonalInfo['address'][0]['postalCode'] == null){
        patientPostalCode = 'No postal code';
      }else{
        patientPostalCode = decodedPatientPersonalInfo['address'][0]['postalCode'];
      }

      //list containing all prefix,given name and family name of patient
      List patientNameList = [patientNameInfo['prefix'],patientNameInfo['given'],patientNameInfo['family']];

      //ensure that all the elements in patientNameList are String
      for ( int m = 0 ; m < patientNameList.length ; m++ ){
        if (patientNameList[m] is List){
          patientNameList[m] = patientNameList[m].join();
        }
      }
      
      String patientName = patientNameList.join(" ") ; 
      Patient patient = new Patient(id:int.parse(patientId),name:patientName,totalCholesterol:0, effectiveDateTime: "", gender: patientGender, dateOfBirth: patientDateOfBirth, city: patientCity, state: patientState, country: patientCountry, postalCode: patientPostalCode, isHighlighted: false);
      output.add(patient);
    }

    return output;
  }

  Future<List> updateData(List<Patient> patientList) async{
    int patientCount = patientList.length; //total number of patients monitored by practitioner
    List overallPatientInfo = [];

    for ( int k = 0 ; k < patientCount ; k++ ){
      String patientId =patientList[k].getID().toString();
      String cholesterolUrl = root_url + "Observation?patient="+ patientId +"&code=2093-3&_sort=date&_count=13";
      http.Response cholesterolResponse = await http.get(cholesterolUrl);
      String cholesterolData = cholesterolResponse.body;
      Map decodedcholesterolData = jsonDecode(cholesterolData);

      //getting the JSON data containing blood pressure of patient with particular patient id
      String bloodPressureUrl = root_url + "Observation?patient="+ patientId + "&code=55284-4&_sort=-date&_count=13";
      http.Response bloodPressureResponse = await http.get(bloodPressureUrl);
      String bloodPressureData = bloodPressureResponse.body;
      Map decodedBloodPressureData = jsonDecode(bloodPressureData);

      try{
        List patientCholesterolData = decodedcholesterolData['entry'];
        Map patientCholesterolResource = patientCholesterolData[patientCholesterolData.length-1]['resource']; //getting the latest data

        //code for cholesterol level of patient
        Map patientValueQuantity = patientCholesterolResource['valueQuantity'];
        String patientCholesterolLevel = patientValueQuantity['value'].toString();

        //code for cholesterol date and time
        String dateTime = patientCholesterolResource['effectiveDateTime'].split("+")[0];
        String offset = patientCholesterolResource['effectiveDateTime'].split("+")[1].substring(0,2);

        DateTime dateTimeObj = DateTime.parse(dateTime); //creating DateTime object
        dateTimeObj = dateTimeObj.add(Duration(hours: int.parse(offset))); //adding offset

        String effectiveTimeDate = DateFormat.yMEd().add_jms().format(dateTimeObj);

        patientList[k].setCholesterol(double.parse(patientCholesterolLevel));
        patientList[k].setDate(effectiveTimeDate);

        int counter;

        if (decodedBloodPressureData['entry'].length < 5){
          counter = decodedBloodPressureData['entry'].length;
        }else{
          counter = 5;
        }

        List diastolicList = [];
        List systolicList = [];
        List BPTimeList = [];

        for (int i = 0 ; i < counter ; i++){
          Map entryData = decodedBloodPressureData['entry'][i];
          Map resourceData = entryData['resource'];
          Map diastolicComponentData = resourceData['component'][0];
          Map systolicComponentData = resourceData['component'][1];
          Map diastolicValueMap = diastolicComponentData['valueQuantity'];
          Map systolicValueMap = systolicComponentData['valueQuantity'];
          String diastolicValue = diastolicValueMap['value'].toString();
          String systolicValue = systolicValueMap['value'].toString();

          //code for blood pressure date and time
          String bloodPressureDateTime = resourceData['effectiveDateTime'].split("+")[0];
          String offset = resourceData['effectiveDateTime'].split("+")[1].substring(0,2);

          DateTime BPdateTimeObj = DateTime.parse(bloodPressureDateTime); //creating DateTime object
          BPdateTimeObj = BPdateTimeObj.add(Duration(hours: int.parse(offset))); //adding offset

          String BPEffectiveTimeDate = DateFormat.yMEd().add_jms().format(BPdateTimeObj);

          diastolicList.add(diastolicValue);
          systolicList.add(systolicValue);
          BPTimeList.add(BPEffectiveTimeDate);
        }

        patientList[k].setDiastolicData(diastolicList);
        patientList[k].setSystolicData(systolicList);
        patientList[k].setBPEffectiveTime(BPTimeList);

      }
      catch (e){ //exception handler for error when retrieving data
        continue;
      }
    }
    _patientList = patientList;
    return patientList;
  }
}
