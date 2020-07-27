import 'package:Theranos/model/patient.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

Container cholesterolChart(List<Patient> patientlist) {
    return Container(
        height: 200.0+(patientlist.length*50),
        padding: EdgeInsets.only(right: 20),
        child: SfCartesianChart(
            plotAreaBackgroundColor: Colors.grey[100],
            primaryXAxis: CategoryAxis(),
            legend: Legend(isVisible: false), // Enables the legend.
            tooltipBehavior:
                TooltipBehavior(enable: true), // Enables the tooltip.
            series: <ChartSeries>[
              BarSeries<Patient, String>(
                  dataSource: patientlist,
                  xValueMapper: (Patient sales, _) =>
                      sales.getName().split(" ")[1],
                  yValueMapper: (Patient sales, _) => sales.getCholesterol(),
                  dataLabelSettings: DataLabelSettings(
                      isVisible: true) // Enables the data label.
                  )
            ]));
  }