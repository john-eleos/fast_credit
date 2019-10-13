
import 'dart:math' as prefix0;

import 'package:fast_credit/models/networkProvider.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

bool working = false;
Directory fileDirectory;
String text;

class OcrRoom extends StatelessWidget {
  final NetworkProvider networkProvider;
  final CameraDescription camera;
  OcrRoom({Key key, @required this.networkProvider, @required this.camera}):super (key:key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fast Credit',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.white,
      ),
      home: OcrRoomState(title: 'Fast Credit',networkProvider:networkProvider, camera:camera ),
    );
  }

}

class OcrRoomState extends StatefulWidget {
  final CameraDescription camera;
  File file;
  String scannerType = 'TEXT_SCANNER';
  final String title;
  final NetworkProvider networkProvider;
  OcrRoomState({this.file, this.scannerType,this.title, this.networkProvider, this.camera});



  @override
  State<StatefulWidget> createState() {
//    return _OcrRoomState(networkProvider: networkProvider);
    return _OcrRoomState(networkProvider: networkProvider, camera:camera);
  }

}

class _OcrRoomState extends State<OcrRoomState>{


  final CameraDescription camera;
final NetworkProvider networkProvider;
_OcrRoomState({this.networkProvider, this.camera});
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  List texts = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.ultraHigh,
    );
    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }
  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: Container(
          decoration:BoxDecoration( image: DecorationImage(
            image: AssetImage("assets/images/network.png"),
            fit: BoxFit.cover,
          ),
          ),
          child: Padding(
            padding:EdgeInsets.only(top:MediaQuery.of(context).size.height*0.1),
            child: ListView(
              scrollDirection: Axis.vertical,
//              child: Column(
                children: <Widget>[
//            for fast credit logo
                  Padding(
                    padding:EdgeInsets.only(bottom:MediaQuery.of(context).size.height*0.1),
                    child: Container(
                      padding: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width*0.6,

                      ),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height*0.15,
                      child: Image.asset("assets/images/app_logo.png", fit: BoxFit.contain,),
                    ),
                  ),
//            for the OCR port /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                  (working==false?Container(
                    child:FutureBuilder<void>(
                      future: _initializeControllerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
//                          final size = MediaQuery.of(context).size;
//                          final deviceRatio = size.width / size.height;
                          var size = MediaQuery.of(context).size.height*0.09;
                          return Transform.scale(
                            scale: 0.9,
                            child: Container(
                              width: size,
                              height: size,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: OverflowBox(
                                  alignment: Alignment.center,
                                  child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Container(
                                      width: size,
                                      height: size / _controller.value.aspectRatio,
                                      child: CameraPreview(
                                        _controller,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          // Otherwise, display a loading indicator.
                          return Container(
                            width: 100,
                              height: 100,
                              child: Center(child: CircularProgressIndicator()));
                        }
                      },
                    ),
                  ):Container(
                      width: 100,
                      height: 100,
                      child: Center(child: CircularProgressIndicator()))),

              Center(
                child: RaisedButton(
//              onPressed:null,
                    onPressed: (){
                      this.ocrWork();
                    },

                  child: Text("Recharge"),color: networkProvider.buttoncolor,),
              ),
                Text("the things is shady: ${text}"),

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//            for the ad
                  Padding(
                    padding:EdgeInsets.only(bottom:MediaQuery.of(context).size.height*0.1),
                    child: Container(
                      width: MediaQuery.of(context).size.width*0.8,
                      height: MediaQuery.of(context).size.width*0.3,
                      child: Center(child: Text("advert here")),
                    ),
                  ),
//            for the network logo
                  Padding(
                    padding: EdgeInsets.only(bottom: 2, left: MediaQuery.of(context).size.width*0.6,
                    right: MediaQuery.of(context).size.width*0.05),
                    child: Container(
                      width: MediaQuery.of(context).size.width*0.3,
                      height: MediaQuery.of(context).size.width*0.3,
                      child: Image.asset(networkProvider.networkProviderImage, fit: BoxFit.cover,),
                    ),
                  ),
                ],
              ),
            ),
          ),
//        ),
      ),
    );
  }

  Future ocrWork() async{
    setState(() {
      working = true;
    });
    try{
      await _initializeControllerFuture;
      final path = join(
          (await getTemporaryDirectory()).path,"${DateTime.now()}.png"

      );
      await _controller.takePicture(path);
      final File imageFile = File(path);
      String d = "";
      final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(imageFile);
      final TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
      final VisionText visionText = await textRecognizer.processImage(visionImage);
      for(TextBlock a in visionText.blocks){
        for(TextLine b in a.lines){
          for(TextElement c in b.elements){
//             for airtel of 16 digits ^(?:[[[[[[[[[[0]1]2]3]4]5]6]7]8]9])?[0-9]{16}$
//             for glo of 15 digits  ^(?:[[[[[[[[[[0]1]2]3]4]5]6]7]8]9])?[0-9]{15}$
//             for mtn of  17  digits  ^(?:[[[[[[[[[[0]1]2]3]4]5]6]7]8]9])?[0-9]{17}$
//             for 9mobile of 15   digits  ^(?:[[[[[[[[[[0]1]2]3]4]5]6]7]8]9])?[0-9]{15}$
//            if(){
//
//            }
            d = d + " " + c.text;
            texts.add(c.text);
            print("doing ${c.text}");
            UrlLauncher.launch('tel:08188952342');
            
          }
        }
      }
      setState(() {
        text= d;
        this.texts = this.texts;
        working = false;
      });


    }catch (e){
      print("wrong work");


    }


  }

}

