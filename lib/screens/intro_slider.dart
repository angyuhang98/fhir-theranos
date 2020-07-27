import 'package:Theranos/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:Theranos/constant.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:intro_slider/dot_animation_enum.dart';


class IntroPageScreen extends StatefulWidget {
  static const String id = "intro_page";
  IntroPageScreen({Key key}) : super(key: key);

  @override
  IntroPageScreenState createState() => new IntroPageScreenState();
}

class IntroPageScreenState extends State<IntroPageScreen> {
  double sliderIndex;
  double initial;
  double distance;
  Function goToTab;
  List<Slide> slides = [Slide(), Slide(),Slide()];

  static const List<String> imageURIs = [
    "assets/images/healthcare.jpg",
    "assets/images/karen-wilcox-123.jpg",
    "assets/images/colorful_gradient_hd_5k-5120x2880.jpg"
  ];
  static const List<String> image_place_holder_URIs = [
    "assets/images/healthcare_s.jpg",
    "assets/images/karen-wilcox-123_s.jpg",
    "assets/images/colorful_gradient_hd_5k-5120x2880_s.jpg"
  ];

  List<Widget> images;

  int max = 3;
  @override
  void initState() {
    super.initState();
    sliderIndex = 0;
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
  }


  Widget renderNextBtn() {
    return Text(
      "Skip",
      style:
      TextStyle(color: Colors.white, fontFamily: regularFont, fontSize: 20),
    );
  }

  Widget renderDoneBtn() {
    return Text(
      "Skip",
      style:
      TextStyle(color: Colors.white, fontFamily: regularFont, fontSize: 20),
    );
  }

  List<Widget> renderListCustomTabs() {
    List<Widget> tabs = new List();
    for (int i = 0; i<imageURIs.length;i++){
      tabs.add(Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Stack(children: [
            Container(
                decoration: BoxDecoration(color: Colors.black),
                height: MediaQuery.of(context).size.height,
                child: ColorFiltered(
                  child: FadeInImage(
                    //fadeInDuration: Duration(milliseconds: 500),
                      placeholder: AssetImage(image_place_holder_URIs[i]),
                      image: AssetImage(imageURIs[i]),
                      fit: BoxFit.cover),
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.6), BlendMode.srcOver),
                )),
            Container(
              decoration: BoxDecoration(
                //image: images[sliderIndex.round()]
              ),
              height: 800,
              padding: EdgeInsets.only(top: 40, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      children: [
                        Text(
                          "Your HealthCare Assistant",
                          style: TextStyle(
                              fontSize: 50,
                              color: Colors.white,
                              fontFamily: regularFont,
                              fontWeight: FontWeight.w300),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "An extremely handy tool to monitor patients' health details.",
                          style: TextStyle(
                              letterSpacing: 1,
                              wordSpacing: 1,
                              height: 1,
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: regularFont,
                              fontWeight: FontWeight.w300),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ])));

    }



    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IntroSlider(
            shouldHideStatusBar: false,
            isShowSkipBtn: false,
            isShowPrevBtn: false,
            isShowNextBtn: false,
            isShowDoneBtn: false,
            listCustomTabs: renderListCustomTabs(),

            slides: this.slides,
            highlightColorSkipBtn: Colors.white,
            renderDoneBtn: this.renderDoneBtn(),

            colorDoneBtn: Colors.transparent,
            highlightColorDoneBtn: Colors.grey[300].withOpacity(0.5),
            colorActiveDot: Colors.white.withOpacity(0.9),
            colorDot: Colors.grey[300].withOpacity(0.8),
            sizeDot: 13.0,
            typeDotAnimation: dotSliderAnimation.SIZE_TRANSITION,
            refFuncGoToTab: (refFunc) {
              this.goToTab = refFunc;
            },
          ),
          Container(
            height: 200,
            width: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "THERANOS",
                    style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontFamily: "Futura Light",
                        fontWeight: FontWeight.w600),
                  ),
                ]),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 15),
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(),
                    ),
                    Expanded(
                      flex: 1,
                      child: FlatButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, LoginPage.id);
                        },

                        splashColor: Colors.grey[300].withOpacity(0.5),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(25.0)),
                        child: Container(
                            height: 45,
                            width: 65,
                            alignment: FractionalOffset.center,
                            decoration: new BoxDecoration(
                              color: Colors.grey[100].withOpacity(0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Skip",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: regularFont,
                                      fontSize: 18),
                                ),
                                Icon(
                                  Icons.navigate_next,
                                  size: 27,
                                  color: Colors.white,
                                ),
                              ],
                            )),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}