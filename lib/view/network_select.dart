import 'package:camera/camera.dart';
import 'package:fast_credit/ocrRoom.dart';
import 'package:flutter/material.dart';
import 'package:fast_credit/provider/networkList.dart';

AnimationController animationController;
ColorTween colorTween;
CurvedAnimation curvedAnimation;
ScrollController scrollController;

class NetworkSelect extends StatefulWidget {
  final CameraDescription camera;
  NetworkSelect({Key key, @required this.camera}) : super(key: key);

  @override
  _NetworkSelectState createState() => _NetworkSelectState(camera:camera);
}

class _NetworkSelectState extends State<NetworkSelect> with TickerProviderStateMixin{
  final CameraDescription camera;
  _NetworkSelectState({@required this.camera});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.1),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width*0.6,
                ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height*0.1,
            child: Image.asset("assets/images/app_logo.png"),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.7,
              child:ListView.builder(
                  itemCount: networks.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index){
                    return Padding(
                      padding: EdgeInsets.only(left:25.0,
                          right: 8.0,
                          top: MediaQuery.of(context).size.height*0.1,
                          bottom: MediaQuery.of(context).size.height*0.1),
                      child: Container(
                        height: MediaQuery.of(context).size.height*0.8,
                        width: MediaQuery.of(context).size.width *0.8,
                        child: Card(
                          color: networks[index].color,
                          child: FlatButton(onPressed: (){
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => OcrRoom(networkProvider: networks[index],camera:camera)
                            ));
                          }, child: Center(
                            child: Image.asset(networks[index].networkProviderImage),
                          )),
                        ),
                      ),
                    );
                  }
              )
          ),
        ],
      ),
    );
  }
}