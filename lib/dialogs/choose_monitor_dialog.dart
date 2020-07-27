import 'package:flutter/material.dart';
import 'package:Theranos/constant.dart';
import 'package:Theranos/widget/flushbar.dart';
import 'package:flutter/services.dart';

class MyDialogContent extends StatefulWidget {
  MyDialogContent({
    Key key,
  }) : super(key: key);
  @override
  MyDialogContentState createState() => new MyDialogContentState();
}

class MyDialogContentState extends State<MyDialogContent> {
  bool monitorBP;
  bool monitorC;
  final diastolicController = TextEditingController();
  final systolicController = TextEditingController();

  void initState() {
    super.initState();
    monitorBP = monitorBloodPressure;
    monitorC = monitorCholesterol;
    diastolicController.text = highlightDiastolicBoundary.toString();
    systolicController.text = highlightSystolicBoundary.toString();

  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        padding: EdgeInsets.all(20),
        height: 550,
        width: 700,
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Select fields to monitor",
                textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: semiboldFont,
                        fontWeight: FontWeight.w600,
                        fontSize: 22)),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                    activeColor: Colors.blue[500],
                    checkColor: Colors.blue[500],
                    value: monitorBP,
                    onChanged: (bool newvalue) {
                      setState(() {
                        monitorBP = newvalue;
                      });
                    }),
                Text(
                  "Blood Pressure",
                  style: TextStyle(
                      fontFamily: semiboldFont,
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[800]),
                )
              ],
            ),
            Row(
              children: [
                Checkbox(
                    activeColor: Colors.blue[500],
                    checkColor: Colors.blue[500],
                    value: monitorC,
                    onChanged: (bool newvalue) {
                      setState(() {
                        monitorC = newvalue;
                      });
                    }),
                Text(
                  "Cholesterol Level",
                  style: TextStyle(
                      fontFamily: semiboldFont,
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[800]),
                )
              ],
            ),
            SizedBox(height:40),
            //_buildDiastolicTextField(),
            //get here
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Select Boundary",
                textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: semiboldFont,
                        fontWeight: FontWeight.w600,
                        fontSize: 22)),
              ],
            ),
            TextFormField(
              inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly,
                         LengthLimitingTextInputFormatter(3),
                                      ],
              keyboardType: TextInputType.number,
              controller: systolicController,
              decoration: InputDecoration(
                  labelText: 'Systolic Blood Pressure',
                  hintText: 'Initial default value is 0',
                  hintStyle: TextStyle(
                    fontFamily: semiboldFont,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[400],
                  ),
                  labelStyle: TextStyle(
                    fontFamily: semiboldFont,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[800],
                  )
              ),
            ),
            SizedBox(height: 30),
            TextFormField(
              controller: diastolicController,
              decoration: InputDecoration(
                  labelText: 'Diastolic Blood Pressure',
                  hintText: 'Initial default value is 0',
                  hintStyle: TextStyle(
                    fontFamily: semiboldFont,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[400],
                  ),
                  labelStyle: TextStyle(
                    fontFamily: semiboldFont,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[800],
                  )
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 80,
                  height: 40,
                  decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(40)),
                  child: RawMaterialButton(
                    constraints: BoxConstraints(),
                    padding: EdgeInsets.only(left: 10, right: 5),
                    child: Container(
                      child: Text(
                        'Done',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 25,
                          fontFamily: regularFont,
                          color: Colors.blue[700],
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (!monitorBP && !monitorC) {
                        myFlushBar(context,
                            "You must select at least one from these options.");
                      } else {
                        if (diastolicController.text == ""){
                          highlightDiastolicBoundary = highlightDiastolicBoundary;
                        }else{
                          highlightDiastolicBoundary = int.parse(diastolicController.text);
                        }

                        if (systolicController.text == ""){
                          highlightSystolicBoundary = highlightSystolicBoundary;
                        }else{
                          highlightSystolicBoundary = int.parse(systolicController.text);
                        }

                        monitorBloodPressure = monitorBP;
                        monitorCholesterol = monitorC;
                        Navigator.pop(context,true);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}