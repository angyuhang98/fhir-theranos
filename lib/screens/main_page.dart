
import 'package:Theranos/dialogs/choose_monitor_dialog.dart';
import "package:Theranos/dialogs/patient_bp_stat_dialog.dart";
import 'package:Theranos/widget/bp_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:Theranos/constant.dart';
import 'package:Theranos/model/patient.dart';
import 'package:Theranos/dialogs/patient_detail_dialog.dart';
import 'package:flashy_tab_bar/flashy_tab_bar.dart';
import 'package:Theranos/screens/add_patient_page.dart';
import 'package:flutter/services.dart';
import 'package:Theranos/server/server.dart';
import 'package:Theranos/widget/cholesterol_chart.dart';
import 'dart:async';
import '../constant.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);
  static const String id = "main_page";

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isPressed;
  String userPinNum;
  var _tapPosition;
  bool patientAdded;
  int _selectedIndex = 0;

  final textStyle = TextStyle(
    fontSize: 22,
    fontFamily: regularFont,
    color: Colors.blue[700],
  );

  final textStyle_op = TextStyle(
    fontSize: 22,
    fontFamily: regularFont,
    color: Colors.grey[800],
  );

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.grey[400]));
    patientAdded = false;
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {

    timer = new Timer.periodic(new Duration(seconds: intervalOfUpdate), (Timer t) {   //update data periodically
      List<Patient> patientList = patientObj.getPatientMonitored();
      if (patientObj.getPatientMonitored().length > 0) {
        patientObj.updateData(patientList);
      }
      setState(() {});
    });

    List<Patient> patientList = patientObj.getPatientMonitored();
    if (patientObj.getPatientMonitored().length > 0) {
      patientObj.updateData(patientList);
    }
    setState(() {});

    userPinNum = ModalRoute.of(context).settings.arguments;
    if (_selectedIndex == 0) {
      return mainPageDashboard(context);
    } else if ((_selectedIndex == 1 &&monitorBloodPressure)) {
      return mainPageBloodPressure(context);
    } else {
      return statisticTab(context);
    }
  }

  SafeArea mainPageBloodPressure(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        key: _scaffoldKey,
        bottomNavigationBar: monitorBloodPressure|| monitorCholesterol? bottomBar():null,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: mainPageAppbar(context),
        ),
        floatingActionButton: _getFAB(),
        body: SafeArea(
            child: Stack(children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      children: [
                        FutureBuilder(
                            future: retrievePatientList(),
                            builder: (context, snapshot) {
                              if (snapshot.data == null) {
                                return mainPageLoading();
                              } else if (snapshot.data.length == 0) {
                                return Container(
                                  height:
                                      MediaQuery.of(context).size.height / 2,
                                  width: MediaQuery.of(context).size.width,
                                  child: Center(
                                    child: Text(
                                      "Click floating Button to Select Your Patient",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: semiboldFont,
                                          fontSize: 25,
                                          color: Colors.grey[600]),
                                    ),
                                  ),
                                );
                              } else {
                                return Container(
                                  width: 800,
                                  child: Column(
                                    children: [
                                      ListView.builder(
                                        itemCount: snapshot.data.length,
                                        scrollDirection: Axis.vertical,
                                        primary: false,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return bloodPressurelistViewItem(
                                            context,
                                            index,
                                            snapshot.data,
                                            getAvgValue(snapshot.data),
                                            monitorCholesterol,
                                            monitorBloodPressure,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              } //else close bracket
                            }),
                      ],
                    )),
              ],
            ),
          ),
            patientAdded ? mainPageLoading() : Column()
        ])),
      ),
    );
  }

  FlashyTabBar bottomBar() {
    List<FlashyTabBarItem> alist = [FlashyTabBarItem(
   activeColor :Colors.grey[600],
            icon: Icon(Icons.view_list,color : Colors.grey[400],size: 22),
            title: Text('Home Page',
            style:TextStyle(fontFamily: semiboldFont,fontSize: 20,color: Colors.grey[600],fontWeight: FontWeight.w700)
            ),
          ),
          ];
    if (monitorBloodPressure){
      alist.add(FlashyTabBarItem(
   activeColor :Colors.grey[600],
            icon: Icon(Icons.opacity, color : Colors.grey[400],size:22),
            title:  Text('Blood Pressure',
            style:TextStyle(fontFamily: semiboldFont,fontSize: 18,color: Colors.grey[600],fontWeight: FontWeight.w700)
            ),
            
          ));
    }
    if (monitorCholesterol){
      alist.add(FlashyTabBarItem(
   activeColor :Colors.grey[600],
            icon: Icon(Icons.assessment, color : Colors.grey[400],size:22),
            title:  Text('Cholesterol',
            style:TextStyle(fontFamily: semiboldFont,fontSize: 18,color: Colors.grey[600],fontWeight: FontWeight.w700)
            ),
          ));
    }

    return FlashyTabBar(
        selectedIndex: _selectedIndex,
        showElevation: false, 
        height : 70,


        onItemSelected: (index) => setState(() {
          _selectedIndex = index;
        }),
        items: alist,
      );
  }

  AppBar mainPageAppbar(BuildContext context) {
    return AppBar(
      title: Padding(
          padding: EdgeInsets.only(left: 10, top: 20, bottom: 10),
          child: Text(
            "Theranos",
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
              Icons.tune,
              color: Colors.white,
              size: 35,
            ),
            onPressed: () async {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (ctxt) => MyDialogContent()).then((value) {
                if (value) {
                  setState(() {_selectedIndex = 0;});
                }
              });
            },
          ),
        ),
        // overflow menu
      ],
    );
  }

  SafeArea mainPageDashboard(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        key: _scaffoldKey,
        bottomNavigationBar:monitorBloodPressure || monitorCholesterol? bottomBar():null,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: mainPageAppbar(context),
        ),
        floatingActionButton: _getFAB(),
        body: SafeArea(
            child: Stack(children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        children: [
                          FutureBuilder(
                              future: retrievePatientList(),
                              builder: (context, snapshot) {
                                if (snapshot.data == null) {
                                  return mainPageLoading();
                                } else if (snapshot.data.length == 0) {
                                  return Container(
                                    height:
                                        MediaQuery.of(context).size.height / 2,
                                    width: MediaQuery.of(context).size.width,
                                    child: Center(
                                      child: Text(
                                        "Click floating Button to Select Your Patient",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: semiboldFont,
                                            fontSize: 25,
                                            color: Colors.grey[600]),
                                      ),
                                    ),
                                  );
                                } else {
                                  return Container(
                                    width: 800,
                                    child: Column(
                                      children: [
                                        listViewTitle(
                                            context,
                                            monitorCholesterol,
                                            monitorBloodPressure),
                                        ListView.builder(
                                          itemCount: snapshot.data.length,
                                          scrollDirection: Axis.vertical,
                                          primary: false,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return listViewItem(
                                              context,
                                              index,
                                              snapshot.data,
                                              getAvgValue(snapshot.data),
                                              monitorCholesterol,
                                              monitorBloodPressure,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                } //else close bracket
                              }),
                        ],
                      )),
                ],
              ),
            ),
          ),
            patientAdded ? mainPageLoading() : Column()
        ])),
      ),
    );
  }

  Container mainPageLoading() {
    return Container(
      padding: EdgeInsets.all(35),
      child: new Stack(
        children: <Widget>[
          new Container(
            alignment: AlignmentDirectional.center,
            decoration: new BoxDecoration(
              color: Colors.grey[100],
            ),
            child: new Container(
              width: 300.0,
              height: 500,
              alignment: AlignmentDirectional.center,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Center(
                    child: new SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: new CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.blue),
                        value: null,
                        strokeWidth: 7.0,
                      ),
                    ),
                  ),
                  new Container(
                    margin: const EdgeInsets.only(top: 25.0),
                    child: new Center(
                      child: new Text(
                        "loading.. wait...",
                        style: new TextStyle(
                            fontSize: 20,
                            color: Colors.grey[500],
                            fontFamily: semiboldFont),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getFAB() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, AddPatientPage.id,
                      arguments: userPinNum)
                  .then((value) {
                if (value) {
                  setState(() {
                  });
                }
              });
            },
            backgroundColor: Colors.white,
            foregroundColor: Colors.grey[800],
            child: Icon(
              Icons.add,
              size: 30,
            )),
      ],
    );
  }

  double getAvgValue(List patientdata) {
    double sum = 0;

    for (int i = 0; i < patientdata.length; i++) {
      sum += patientdata[i].getCholesterol();
    }
    double avg = sum / patientdata.length;

    return avg;
  }

  Widget bloodPressurelistViewItem(
      BuildContext context,
      int index,
      List patientInfo,
      double avg,
      bool showCholesterol,
      bool showBloodPressure) {


    final grey_style =
        TextStyle(color: Colors.grey[700], fontFamily: regularFont);
    final red_style = TextStyle(
        color: Colors.red, fontFamily: boldFont, fontWeight: FontWeight.w500);
    final purple_style = TextStyle(
        color: Colors.purple,
        fontFamily: boldFont,
        fontWeight: FontWeight.w500);

    Patient patientdata = patientInfo[index]; //data retrieved from constant
    final patientName = patientdata.getName().split(" ")[0] +
        patientdata.getName().split(" ")[1]; //patientName

    final patientCholesterol =
        patientdata.getCholesterol(); //patient cholesterol level
    final patientEffectiveDateTime = patientdata.getEffectiveDateTime();

    String patientSystolic = '0';
    String patientDiastolic = '0';
    String patientBPTime = '0';

  List date = patientdata.getBPEffectiveTime();
  List systolic = patientdata.getSystolicData();

  List<Widget> bpRow = [];
  for (int i = date.length-1;i>=0;i--){
      List displayDateList = date[i].split(" ");
      String displayDate =  displayDateList[1] +" "+ displayDateList[2] + displayDateList[3];
      Widget item = detailRow(displayDate, systolic[i].split('.')[0]+" mmHg", i%2 ==0 ? true : false);
      bpRow.add(item);
    
  }

    try {
      patientSystolic = patientdata.getSystolicData()[0];
      patientDiastolic = patientdata.getDiastolicData()[0];
      patientBPTime = patientdata.getBPEffectiveTime()[0];
    } catch (e) {}

    return GestureDetector(
      onTap: (){
         showDialog(

            context: context,
            builder: (ctxt) => patientBPStatDialog(patientdata, context));
      
      },
      child: Container(
        height: 40.0+35*date.length,
        margin: EdgeInsets.only(top: 16, left: 7, right: 7),
        width: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: patientdata.getIsHighlighted()
                ? Colors.white
                : Colors.grey[200],
            boxShadow: [
              BoxShadow(
                  color: Colors.grey[350],
                  offset: Offset(2.0, 2),
                  blurRadius: 2.0,
                  spreadRadius: 1),
              BoxShadow(
                  color: Colors.grey[350],
                  offset: Offset(2, 2),
                  blurRadius: 2.0,
                  spreadRadius: 1.0),
            ]),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, bottom: 5, top: 5),
                  child: Text(patientName,
                      style: TextStyle(
                          fontFamily: semiboldFont,
                          fontSize: 20,
                          fontWeight: FontWeight.w500)),
                ),
              ],
            ),
            ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: bpRow,),

          ],
        ),
      ),
    );
  }

  Container detailRow(String titleText, String detailRow, bool white_or_grey) {
    final purple_style = TextStyle(
        fontSize: 19,
        color: Colors.purple,
        fontFamily: boldFont,
        fontWeight: FontWeight.w500);

    final grey_style =TextStyle(
      fontSize: 19,
                      fontFamily: boldFont,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w400);
    return Container(
      decoration: BoxDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
              color: white_or_grey ? Colors.grey[100] : Colors.white,
              child: Text(titleText,
               overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 19,
                      fontFamily: boldFont,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w400)),
            ),
          ),
          
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.only(left:10,right: 3, top: 5, bottom: 5),
              color: white_or_grey ? Colors.grey[100] : Colors.white,
              child:
                  Text(detailRow, //deleted patientData.name+patientData.surname
                      style: double.parse(detailRow.split(' ')[0]) > highlightSystolicBoundary ?  purple_style :grey_style,)
            ),
          ),
        ],
      ),
    );
  }

  Widget listViewItem(BuildContext context, int index, List patientInfo,
      double avg, bool showCholesterol, bool showBloodPressure) {

    final grey_style =
        TextStyle(color: Colors.grey[700], fontFamily: regularFont);
    final red_style = TextStyle(
        color: Colors.red, fontFamily: boldFont, fontWeight: FontWeight.w500);
    final purple_style = TextStyle(
        color: Colors.purple,
        fontFamily: boldFont,
        fontWeight: FontWeight.w500);

    Patient patientdata = patientInfo[index]; //data retrieved from constant
    final patientName = patientdata.getName(); //patientName

    final patientCholesterol =
        patientdata.getCholesterol(); //patient cholesterol level
    final patientEffectiveDateTime = patientdata.getEffectiveDateTime();

    String patientSystolic = '0';
    String patientDiastolic = '0';
    String patientBPTime = '0';

    try {
      patientSystolic = patientdata.getSystolicData()[0];
      patientDiastolic = patientdata.getDiastolicData()[0];
      patientBPTime = patientdata.getBPEffectiveTime()[0];
    } catch (e) {}

    List displayAllItem = [
      patientName,
      patientCholesterol,
      patientEffectiveDateTime,
      patientSystolic,
      patientDiastolic,
      patientBPTime
    ];
    List displayCholesterolItem = [
      patientName,
      patientCholesterol,
      patientEffectiveDateTime
    ];
    List displayBPItem = [
      patientName,
      patientSystolic,
      patientDiastolic,
      patientBPTime
    ];
    List displayItemList;

    if (showCholesterol == true && showBloodPressure == true) {
      displayItemList = displayAllItem;
    } else if (showCholesterol == true) {
      displayItemList = displayCholesterolItem;
    } else {
      displayItemList = displayBPItem;
    }

    List<TextStyle> textStyleList = [];

    void textStyleDeterminer(displayItemList) {
      for (dynamic displayItem in displayItemList) {
        if (displayItem == patientName || displayItem == patientCholesterol) {
          if (patientCholesterol > avg) {
            textStyleList.add(red_style);
          } else {
            textStyleList.add(grey_style);
          }
        } else if (displayItem == patientEffectiveDateTime ||
            displayItem == patientBPTime) {
          textStyleList.add(grey_style);
        } else if (displayItem == patientSystolic) {
          if (double.parse(patientSystolic) > highlightSystolicBoundary) {
            textStyleList.add(purple_style);
          } else {
            textStyleList.add(grey_style);
          }
        } else {
          if (double.parse(patientDiastolic) > highlightDiastolicBoundary) {
            textStyleList.add(purple_style);
          } else {
            textStyleList.add(grey_style);
          }
        }
      }
    }

    textStyleDeterminer(
        displayItemList); //invoke textStyleDeterminer to generate list of textStyle

    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        _tapPosition = details.globalPosition;
        setState(() {
          patientdata.setIsHighLighted(false);
        });
      },
      onTapCancel: () {
        setState(() {
          patientdata.setIsHighLighted(true);
        });
      },
      onTap: () {
        setState(() {
          patientdata.setIsHighLighted(true);
        });

        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (ctxt) => patientDetailDialog(patientdata, context));
      },
      onLongPress: () {
        final RenderBox overlay =
            Overlay.of(context).context.findRenderObject();

        showMenu(
            context: context,
            items: <PopupMenuEntry>[
              PopupMenuItem(
                value: "Delete",
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return showDeleteDialog(
                              patientName, patientdata, context);
                        }).then((value) => Navigator.pop(context));
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.delete),
                      SizedBox(
                        width: 5,
                      ),
                      Text("Delete"),
                    ],
                  ),
                ),
              )
            ],
            position: RelativeRect.fromRect(
                _tapPosition & Size(40, 40), // smaller rect, the touch area
                Offset.zero &
                    overlay
                        .semanticBounds.size // Bigger rect, the entire screen
                ));
      },
      child: Container(
          margin: EdgeInsets.only(top: 3, bottom: 3),
          height: 60,
          width: 1000,
          decoration: BoxDecoration(
              color: patientdata.getIsHighlighted()
                  ? Colors.white
                  : Colors.grey[200],
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
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                for (int i = 0; i < displayItemList.length; i++)
                  Expanded(
                    flex: 3,
                    child: Text(
                      displayItemList[i].toString(),
                      style: textStyleList[i],
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          )),
    );
  }

  AlertDialog showDeleteDialog(
      String patientName, Patient patientdata, BuildContext context) {
    return AlertDialog(
      title: const Text("Remove Confirmation"),
      content: const Text("Are you sure you wish to delete this item?"),
      actions: <Widget>[
        RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2.0),
                side: BorderSide(color: Colors.red[700])),
            color: Colors.red[700],
            onPressed: () {
              _scaffoldKey.currentState.showSnackBar(
                  SnackBar(content: Text("$patientName's data removed")));
              setState(() {
                patientdata.setIsHighLighted(false);
                patientObj.removePatientsMonitored(patientdata);
              });

              Navigator.of(context).pop();

              // Show a snackbar. This snackbar could also contain "Undo" actions.
            },
            child: const Text("DELETE")),
        RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2.0),
              side: BorderSide(color: Colors.blue[900])),
          color: Colors.blue[900],
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text("CANCEL"),
        ),
      ],
    );
  }

  Widget listViewTitle(
      BuildContext context, bool showCholesterol, bool showBloodPressure) {
    List displayAllList = [
      "Name",
      "Cholesterol",
      "Time",
      "Systolic BP",
      "Diastolic BP",
      "Time"
    ];
    List displayCholesterolList = ["Name", "Cholesterol", "Time"];
    List displayBloodPressureList = [
      "Name",
      "Systolic BP",
      "Diastolic BP",
      "Time"
    ];

    List displayTitle;

    if (showCholesterol == true && showBloodPressure == true) {
      displayTitle = displayAllList;
    } else if (showCholesterol == true) {
      displayTitle = displayCholesterolList;
    } else {
      displayTitle = displayBloodPressureList;
    }

    final grey_style = TextStyle(
        color: Colors.grey[900],
        fontFamily: regularFont,
        fontWeight: FontWeight.w600);

    return Container(
        height: 30,
        width: 1000,
        decoration: BoxDecoration(color: Colors.grey[200], boxShadow: [
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
        child: Padding(
          padding: const EdgeInsets.only(left: 14.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              for (String title in displayTitle)
                Expanded(
                  flex: 3,
                  child: Text(
                    title,
                    style: grey_style,
                    textAlign: TextAlign.start,
                  ),
                )
            ],
          ),
        ));
  }

  Widget statisticTab(BuildContext context){
    return GestureDetector(
      child: Scaffold(
          appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: mainPageAppbar(context),
        ),
        bottomNavigationBar: monitorBloodPressure || monitorCholesterol ? bottomBar():null,
          body: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            "Patient's Cholesterol Levels",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.grey[800],
                                fontFamily: semiboldFont,
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        FutureBuilder(
                          future: retrievePatientList(),
                          builder: (context, snapshot) {
                            if(snapshot.data == null){
                              List<Patient> patientlist = [];
                              return Column(
                              children: [
                                cholesterolChart(patientlist),
                              ],
                            );
                            }
                            return Column(
                              children: [
                                cholesterolChart(snapshot.data),
                              ],
                            );
                          },
                        )
                      ]),
          )),
    );
  }
}
