import 'package:flutter/material.dart';
import 'package:Theranos/constant.dart';
import 'package:Theranos/model/patient.dart';
import 'package:Theranos/server/server.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class AddPatientPage extends StatefulWidget {
  static const String id = "add_patient_page";
  @override
  _AddPatientPageState createState() => _AddPatientPageState();
}

class _AddPatientPageState extends State<AddPatientPage>
    with SingleTickerProviderStateMixin {
  String userPinNum;
  List patientsAddToMonitor = [];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.black));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    userPinNum = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Colors.cyan[50],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
            title: Padding(
                padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                child: Text(
                  "Add Patient for Monitoring",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: semiboldFont,
                    color: Colors.grey[800],
                  ),
                )),
            elevation: 3,
            backgroundColor: Colors.cyan[400]),
      ),
      body: SafeArea(
        child: Container(
            child: Column(
          children: <Widget>[
            Expanded(
              flex: 7,
              child: SingleChildScrollView(
                child: FutureBuilder(
                    future: retrivePatientOption(),
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        //if the data is still on going the retrieve process
                        return Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 2.6),
                          child: SpinKitCubeGrid(
                            color: Colors.blue[900],
                            size: 50.0,
                          ),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          scrollDirection: Axis.vertical,
                          physics: PageScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return listViewItem(context, index, snapshot.data);
                          },
                        );
                      } //else close bracket
                    }),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0, bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(color: Colors.red[700])),
                      color: Colors.red[700],
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        'Discard',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 22,
                          fontFamily: regularFont,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                    ),
                    SizedBox(width: 20.0),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(color: Colors.lightGreen[400])),
                      color: Colors.lightGreen[400],
                      padding: EdgeInsets.only(left: 6, right: 5),
                      child: Text(
                        'Save',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 22,
                          fontFamily: regularFont,
                          color: Colors.green[900],
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          for (int i = 0;
                              i < patientsAddToMonitor.length;
                              i++) {
                            patientObj
                                .addPatientsMonitored(patientsAddToMonitor[i]);
                          }
                        });
                        Navigator.pop(context, true);
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        )),
      ),
    );
  }

  GestureDetector listViewItem(
      BuildContext context, int index, List<Patient> patientInfo) {
    final grey_style = TextStyle(
        color: Colors.grey[700], fontFamily: regularFont, fontSize: 20);
    final red_style = TextStyle(color: Colors.red, fontFamily: boldFont);

    Patient patientdata = patientInfo[index];
    return GestureDetector(
        onTap: () {
          setState(() {
            if (patientdata.getIsHighlighted() == true) {
              patientdata.setIsHighLighted(false);
              patientsAddToMonitor
                  .removeWhere((item) => item.getID() == patientdata.getID());
            } else {
              patientsAddToMonitor.add(patientdata);
              patientdata.setIsHighLighted(true);
            }
          });
        },
        child: Container(
          height: 60,
          margin: EdgeInsets.only(left: 7, top: 3, bottom: 3, right: 7),
          decoration: BoxDecoration(
              color: patientdata.getIsHighlighted()
                  ? Colors.grey[200]
                  : Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[350],
                    offset: Offset(2.0, 2),
                    blurRadius: 2.0,
                    spreadRadius: 1),
                BoxShadow(
                    color: Colors.white,
                    offset: Offset(-2, -2),
                    blurRadius: 2.0,
                    spreadRadius: 1.0),
              ]),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: Text(
                    patientdata.getName(),
                    style: grey_style,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

