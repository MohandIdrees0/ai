import 'package:aiproject/commonWidget.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'DFS.dart';

class mainPage extends StatefulWidget {
  const mainPage({super.key,});
  @override
  State<mainPage> createState() => _mainPageState();
}

class _mainPageState extends State<mainPage>
    with TickerProviderStateMixin,WindowListener{
  late Map<String,int> map={};
  late AnimationController waterFlowController;
  late AnimationController boatController;
  late Animation<double> WaterFlowTween;
  late Animation<double> boatTween;
  late List<CurrentState> list;
  String description="";
  bool firstTime=true;
  bool IsDFS=true;
  Map<String,double> sizes={};
  @override
  void initState() {
    super.initState();
    WindowManager.instance.addListener(this);
    fillMap(map);
  }
  @override
  void onWindowEvent(String eventName) {
    if(eventName.compareTo("maximize")==0 || eventName.compareTo("unmaximize")==0){
      firstTime=true;
    }
    super.onWindowEvent(eventName);
  }
  void implementSizeAndAnimation(){
    fillSizes(sizes,MediaQuery.of(context).size);
    implementAnimation();
  }
  void isDFS(bool bool){
    list=bool?MissionariesAndCannibals().findSolutonByDFS():MissionariesAndCannibals().findSolutionByBFS();
  }
  @override
  Widget build(BuildContext context) {
    if(firstTime){
      implementSizeAndAnimation();
      firstTime=false;
    }
    return Scaffold(
      body: Container(
        width: sizes["width"],
        height: sizes["height"],
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.blueGrey, Colors.amber])),
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 25,
                ),
                Text(
                  'Missionaries and Cannibals',
                  style: TextStyle(fontSize: 35, color: Colors.white,fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: sizes["height"]! / 5,
                ),
                Expanded(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            AnimatedBuilder(
                              animation: boatController,
                              builder: (BuildContext context, Widget? child) {
                                return Positioned(
                                  top: sizes["width"]!/10,
                                  left:boatTween.value,
                                  child: Stack(alignment: Alignment.topCenter,
                                    children: [
                                      elements(map["humanAtBoat"]!,map["monsterAtBoat"]!,MediaQuery.of(context).size),
                                      Container(
                                        child: Row(
                                          children: [
                                            Image(image: AssetImage('lib/boat.png'),width: sizes["boatWidth"],height: sizes["width"]!/6,fit: BoxFit.fitWidth,),
                                          ],
                                          mainAxisAlignment: MainAxisAlignment.center,
                                        ),

                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            AnimatedBuilder(
                                animation: waterFlowController,
                                builder: (context, _) {
                                  return Positioned(
                                    left: WaterFlowTween.value,
                                    top: sizes["height"]! /3,
                                    child: ClipPath(
                                      clipper: StarClipper(),
                                      child: Container(
                                          decoration: BoxDecoration(color: Colors.blue),
                                          height: sizes["height"]! * 0.8,
                                          width: sizes["width"]!-40),
                                    ),
                                  );
                                })
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          LandAndHumanOrMonsters(map["humanAtLeft"]!,map["monsterAtLeft"]!),
                          LandAndHumanOrMonsters(map["humanAtRight"]!,map["monsterAtRight"]!),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            IconButton(onPressed: (){
              boatController.isAnimating?boatController.stop():boatController.status==AnimationStatus.forward?boatController.forward():boatController.reverse();
            }, icon: Icon(Icons.pause)),
            Positioned(child:  Text(description,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color:Colors.white),),left: 100,top: 100,),
            Positioned(top: sizes["height"]!*0.3,
              right: sizes["width"]!*0.45,child: Row(
              children: [
                textButton("DFS", (){
                  boatController.reset();
                  implementSizeAndAnimation();
                  fillMap(map);
                  isDFS(true);
                  list.removeLast();
                  description=reSetElements(list, map);
                  addLisntear();
                  setState(() {});
                }),
                SizedBox(width: 20,),
                textButton("BFS", (){
                  boatController.reset();
                  implementSizeAndAnimation();
                  fillMap(map);
                  isDFS(false);
                  list.removeLast();
                  print(list.length);
                  description=reSetElements(list, map);
                  addLisntear();
                  setState(() {});
                })
              ],
            ),
            ),
            Positioned(child: TextButton(onPressed: (){
              success(context);
            },child: Text("Execution Time"),),right: 20,top: 100,),
          ],
        ),
      ),
    );

  }
  void implementAnimation(){
    boatController=AnimationController(vsync: this,duration: Duration(seconds: 3));
    waterFlowController = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
    WaterFlowTween = Tween<double>(begin: 0,end: 40).animate(waterFlowController);
    boatTween = Tween<double>(end: sizes["landSize"]!-10,begin: sizes["width"]!-sizes["landSize"]!-sizes["boatWidth"]!+10).animate(boatController);
    waterFlowController.addStatusListener((status) {
      if(status.name.compareTo("completed")==0){
        waterFlowController.reverse();
      }
      else if(status.index==0){
        waterFlowController.forward();
      }
    });
  }
  void addLisntear(){
    boatController.addStatusListener((status) {
      if(status.index==0){
        if(list.isEmpty)
          return;
        description=reSetElements(list,map);
        setState(() {});
        Future.delayed(Duration(seconds: 1)).then((value) =>
            boatController.forward());
      }
      else if(status.index==3){
        if(list.isEmpty){
          map["humanAtLeft"]=map["humanAtLeft"]!+(map["humanAtBoat"]!);
          map["monsterAtLeft"]=map["monsterAtLeft"]!+(map["monsterAtBoat"]!);
          map['humanAtBoat']=0;
          map['monsterAtBoat']=0;
          description="finish";
          setState(() {});
        }else {
          description=reSetElements(list,map);
          setState(() {});
          Future.delayed(Duration(seconds: 1)).then((value) =>
              boatController.reverse());
        }
      }
    });
    waterFlowController.forward();
    boatController.forward();
  }
  Column LandAndHumanOrMonsters(int human,int monster){
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(child: Image.asset('lib/tree.png',width: 110,),),
            elements(human,monster,MediaQuery.sizeOf(context)),
          ],
        ),
        Container(
          decoration: BoxDecoration(image: DecorationImage(image: AssetImage("lib/ground.jpg"),fit: BoxFit.fill),
            color: Colors.grey,),
          height: MediaQuery.of(context).size.height * 0.45,
          width: sizes["landSize"],
          alignment: Alignment.topRight,
          child: Container(
            decoration: BoxDecoration(image: DecorationImage(image: AssetImage('lib/grass.jpeg'),fit: BoxFit.fill)),
            height: 20,
            width: sizes["landSize"],
          ),
        ),
      ],
    );
  }
}