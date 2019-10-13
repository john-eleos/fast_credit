import 'package:camera/camera.dart';
import 'package:fast_credit/view/network_select.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//void main() => runApp(MyApp());
Future<void> main() async{
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  runApp(MyApp(camera:firstCamera));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final CameraDescription camera;

  const MyApp({
    Key key,
     this.camera,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fast Credit',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.white,
      ),
      home: MyHomePage(title: 'Fast Credit', camera:camera),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final CameraDescription camera;
  MyHomePage({Key key, this.title, @required this.camera}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState(camera:camera);
}

class _MyHomePageState extends State<MyHomePage> {
  final CameraDescription camera;
  _MyHomePageState({ @required this.camera});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
//                  image: DecorationImage(image: image, fit: BoxFit.cover,)
              image: DecorationImage(
                  image: AssetImage("assets/images/network.png"),
                  fit: BoxFit.cover,
              ),
          ),
          child:
          NetworkSelect(camera:camera),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
