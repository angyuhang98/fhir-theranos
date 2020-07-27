import 'package:Theranos/model/patient.dart';
import 'package:flutter/material.dart';
import 'package:Theranos/screens/login_page.dart';
import 'package:Theranos/screens/main_page.dart';
import 'package:Theranos/screens/add_patient_page.dart';
import 'package:flutter/services.dart';
import 'package:Theranos/constant.dart';
import 'package:Theranos/server/server.dart';
import 'package:Theranos/screens/intro_slider.dart';
import 'dart:async';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:Theranos/constant.dart';

void main() {
  CustomImageCache();
  SyncfusionLicense.registerLicense("NT8mJyc2IWhia31ifWN9ZmBoYmF8YGJ8ampqanNiYmlmamlmanMDHmgyPTQqJjsyPTRqaxM0PjI6P30wPD4="); 
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        
        primarySwatch: Colors.grey,
      ),
      //initialRoute: LoginPage.id,
      initialRoute: IntroPageScreen.id,
      onGenerateRoute: (RouteSettings routeSettings){
          return new PageRouteBuilder<dynamic>(
              settings: routeSettings,
              pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                switch (routeSettings.name){
                  case IntroPageScreen.id:  return IntroPageScreen();
                  case LoginPage.id: return LoginPage();
                  case MainPage.id:  return MainPage();
                  case AddPatientPage.id: return AddPatientPage();
                  default: return null;
                }
              },
              transitionDuration:  Duration(milliseconds: getTransitionLatency(routeSettings)),
              transitionsBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation, Widget child, ) {
                    switch (routeSettings.name){
                  case IntroPageScreen.id:  return effectMap[PageTransitionType.slideInLeft](Curves.linear, animation, secondaryAnimation, child);
                  case LoginPage.id: return effectMap[PageTransitionType.slideInLeft](Curves.linear, animation, secondaryAnimation, child);
                  case MainPage.id:  return effectMap[PageTransitionType.slideInLeft](Curves.linear, animation, secondaryAnimation, child);
                  case AddPatientPage.id: return effectMap[PageTransitionType.slideInLeft](Curves.linear, animation, secondaryAnimation, child);
                  default: return null;
                }
                  
                    
                
              }
          );
        }
    );
  }
}

class CustomImageCache extends WidgetsFlutterBinding {
  @override
  ImageCache createImageCache() {
    ImageCache imageCache = super.createImageCache();
    // Set your image cache size
    imageCache.maximumSizeBytes = 1024 * 1024 * 10; // 100 MB
    return imageCache;
  }
}

int getTransitionLatency(RouteSettings routeSettings){
  switch (routeSettings.name){
                  case IntroPageScreen.id:  return 0;
                  case LoginPage.id: return 500;
                  case MainPage.id:  return 0;
                  case AddPatientPage.id: return 0;
                  default: return null;
                }
}



