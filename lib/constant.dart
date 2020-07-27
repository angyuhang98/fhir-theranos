import 'package:Theranos/server/server.dart';
import 'dart:async';


final boldFont = "OpenSans Bold";
final regularFont = "OpenSans Regular";
final semiboldFont = "OpenSans SemiBold";

//interval in seconds
const int intervalOfUpdate = 30;

NetWorkPatient patientObj = new NetWorkPatient();
NetWorkPractitioner practitionerObj = new NetWorkPractitioner();

Timer timer;
bool monitorCholesterol = true;
bool monitorBloodPressure = true;
int highlightDiastolicBoundary = 90;
int highlightSystolicBoundary = 140;



