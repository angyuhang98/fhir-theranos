import 'package:flutter/material.dart';
import 'package:Theranos/constant.dart';
import 'package:Theranos/screens/main_page.dart';
import 'package:flutter/gestures.dart';
import 'package:pin_view/pin_view.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/services.dart';
import 'package:flushbar/flushbar.dart';


class LoginPage extends StatefulWidget {
  static const String id = "login_page";
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  bool showSpinner = false;
  TextEditingController textController = new TextEditingController();
  FocusNode _focusNode;
  String _hintText = "Enter Your Pin";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(AssetImage('assets/images/healthcare.jpg'), context);
    precacheImage(AssetImage('assets/images/karen-wilcox-123.jpg'), context);
    precacheImage(AssetImage('assets/images/colorful_gradient_hd_5k-5120x2880.jpg'), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: null,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.cyan[800]
                  ),
              padding: const EdgeInsets.all(20.0),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                     flex:1,
                     child: Container()),
                    Expanded(
                      flex:2,
                                          child: Text(
                        "THERANOS",
                        style: TextStyle(
                            fontSize: 50,
                            color: Colors.white,
                            fontFamily: semiboldFont,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                   Expanded(
                     flex:1,
                     child: Container()),
                    
                    Expanded(
                      flex:2,
                                          child: Center(
                        child: Container(
                          padding: EdgeInsets.only(left: 35),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(75),
                              color: Colors.grey[100]),
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Flexible(
                                flex: 7,
                                child: Container(
                                  height: 60,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 3.5),
                                    child: TextField(
                                      focusNode: _focusNode,
                                      inputFormatters: [
                                        WhitelistingTextInputFormatter.digitsOnly
                                      ],
                                      style: TextStyle(
                                          fontSize: 25.0,
                                          fontFamily: regularFont,
                                          color: Colors.black),
                                      controller: textController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintStyle: TextStyle(
                                              color: Colors.grey.withOpacity(.9),
                                              fontSize: 25),
                                          hintText: _hintText),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 3,
                                child: FlatButton(
                                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                  onPressed: () async {
                                    
                                    String pin = textController.text;

                                    if (pin.length == 0) {
                                      myFlushBar(context, "Please Input Your Pin Number");
                                      return;
                                    }

                                    setState(() {
                                      showSpinner = true;
                                      FocusScope.of(context).unfocus();
                                    });

                                    SystemChannels.textInput
                                        .invokeMethod('TextInput.hide');

                                    await practitionerObj
                                        .getData(int.parse(pin))
                                        .then((output) async {

                                      if (output.length == 0) {
                                        setState(() {
                                          showSpinner = false;
                                          textController.clear();
                                          _hintText = "Invalid Pin!";

                                        });
                                        
                                        myFlushBar(context,"Login Failed");
                                        Future.delayed(const Duration(seconds: 3), (){
                                          setState(() {
                                            _hintText = "Enter Your Pin";
                                          });
                                          
                                          });
                                      } else {
                                        practitionerObj.setPin(int.parse(pin));
                                        setState(() {
                                          showSpinner = false;
                                        });

                                        Navigator.pushReplacementNamed(
                                            context, MainPage.id,
                                            arguments: pin);
                                      }
                                    });
                                  },
                                  child: Container(
                                      alignment: FractionalOffset.center,
                                      decoration: new BoxDecoration(
                                        color: Colors.grey[100].withOpacity(0),
                                      ),
                                      child: Icon(Icons.navigate_next, size: 50)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                      ),
                    ),
                    Expanded(
                     flex:2,
                     child: Container()),
                  ],
                ),
              ),
            ),
            showSpinner ?  bodyProgress : Container()
          ],
        ),
      ),
    );
  }

  Flushbar myFlushBar(BuildContext context,String text) {
    return Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      message:
          text,
      icon: Icon(
        Icons.info_outline,
        size: 28.0,
        color: Colors.white,
      ),
      duration: Duration(seconds: 3),
    )..show(context);
  }
   var bodyProgress = new Container(
            child: new Stack(
              children: <Widget>[
                new Container(
                  alignment: AlignmentDirectional.center,
                  decoration: new BoxDecoration(
                    color: Colors.white70,
                  ),
                  child: new Container(
                    
                    width: 300.0,
                    height: 200.0,
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
                              valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
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
                                color: Colors.white,
                                fontFamily: semiboldFont
                              ),
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

