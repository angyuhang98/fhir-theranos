import 'package:Theranos/model/patient_record.dart';
import 'package:Theranos/model/lines_chart_data.dart';
import 'package:flutter/material.dart';
import 'package:Theranos/model/patient.dart';
import 'package:Theranos/constant.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

Dialog patientDetailDialog(Patient patientData, context) {
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    child: Container(
      height: 550,
      width :700,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Patient's Detail",
                    style: TextStyle(fontSize:25,fontFamily:regularFont,fontWeight:FontWeight.w700),
                    ),
                  ],
                ),
              )
            ],
          ),
          Column(
            children: <Widget>[
              Container(
                height: 425,
                child: SingleChildScrollView(
                                child: Column(
                    children: [
                      detailRow("Name",patientData.getName()),
                      detailRow("Gender",patientData.getGender()),
                      detailRow("DOB", patientData.getDateOfBirth()),
                      detailRow("City", patientData.getCity()),
                      detailRow("State", patientData.getState()),
                      detailRow("Country", patientData.getCountry()),
                      detailRow("Postal Code",patientData.getPostalCode()),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height:20),
              Padding(
                padding: const EdgeInsets.only(right:18.0),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RawMaterialButton(
                          constraints: BoxConstraints(),
                          padding: EdgeInsets.only(left: 10, right: 5),
                          child: Text(
                            'Done',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 22,
                              fontFamily: regularFont,
                              color: Colors.blue[700],
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                ],
            ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}


Padding detailRow(String titleText,String detailRow) {
  return Padding(
    padding: EdgeInsets.only(bottom: 5),
    child: Container(
      decoration: BoxDecoration(
        color:Colors.grey[50]
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Text(titleText,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: boldFont,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500
                  )),
            ),
            SizedBox(width:15),
            Expanded(
              flex: 2,
              child: Text(
                  detailRow, //deleted patientData.name+patientData.surname
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: regularFont,
                    color: Colors.grey[600],
                  )),
            ),
          ],
        ),
      ),
    ),
  );
}


  PreferredSize statisticAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(60.0),
      child: AppBar(
        title: Padding(
            padding: EdgeInsets.only(left: 10, top: 20, bottom: 10),
            child: Text(
              "Statistics",
              style: TextStyle(
                fontSize: 30,
                fontFamily: semiboldFont,
                color: Colors.grey[800],
              ),
            )),
        elevation: 3,
        backgroundColor: Colors.cyan[400],
        actions: <Widget>[
          // action button
          Padding(
            padding: const EdgeInsets.only(right: 15.0, top: 5),
            child: IconButton(
              icon: Icon(
                Icons.view_list,
                color: Colors.grey[800],
                size: 35,
              ),
              onPressed: () {
              },
            ),
          ),
          // overflow menu
        ],
      ),
    );
  }





