import 'package:Theranos/model/lines_chart_data.dart';
import 'package:flutter/material.dart';
import 'package:Theranos/model/patient.dart';
import 'package:Theranos/constant.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


Widget bpLinesChart(Patient patient) {

    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      legend:
          Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap,position:LegendPosition.bottom),
      primaryXAxis: NumericAxis(
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          majorGridLines: MajorGridLines(width: 0),
          interval: 2),
      primaryYAxis: NumericAxis(
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(color: Colors.transparent)),
      series: getLineSeries(patient),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  List<LineSeries<ChartData, num>> getLineSeries(Patient patient){
  List<ChartData> chartdata = [];
  List date = patient.getBPEffectiveTime();
  List systolic = patient.getSystolicData();
  List diastolic = patient.getDiastolicData();

  
  for (int i = date.length-1;i>=0;i--){
    String datetime = date[i].split("/")[2].substring(0,4);
    chartdata.add(new ChartData(dateint: int.parse(datetime),date:date[i],sbp:double.parse(systolic[i]),dbp:double.parse(diastolic[i])));
  }
  return <LineSeries<ChartData, num>> [
    LineSeries<ChartData, num>(
        animationDuration: 2500,
        enableTooltip: true,
        dashArray: <double>[15, 3, 3, 3],
        dataSource: chartdata,
        yValueMapper: (ChartData sales, _) => sales.getSBP(),
        xValueMapper: (ChartData sales, _) => sales.getDateInt(),
        width: 2,
        name: 'Systolic',
        markerSettings: MarkerSettings(isVisible: true)),
    LineSeries<ChartData, num>(
        animationDuration: 2500,
        enableTooltip: true,
        dashArray: <double>[15, 3, 3, 3],
        dataSource: chartdata,
        yValueMapper: (ChartData sales, _) => sales.getDBP(),
        xValueMapper: (ChartData sales, _) => sales.getDateInt(),
        width: 2,
        name: 'Diastolic',
        markerSettings: MarkerSettings(isVisible: true)),
  ];
}