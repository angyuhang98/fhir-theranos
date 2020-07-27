import 'package:flutter/material.dart';
import 'package:Theranos/model/patient.dart';
import 'package:Theranos/constant.dart';
import 'package:Theranos/widget/bp_chart.dart';

Dialog patientBPStatDialog(Patient patientData, context) {
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    child: Container(
      height: 400,
      width :700,

      padding: EdgeInsets.only(left:5,right:5),
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
                    Text(patientData.getName().split(' ')[0]+ patientData.getName().split(' ')[1],
                    style: TextStyle(fontSize:22,fontFamily:regularFont,fontWeight:FontWeight.w500),
                    ),
                  ],
                ),
              )
            ],
          ),
          Column(
            children: <Widget>[
              Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      bpLinesChart(patientData),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

