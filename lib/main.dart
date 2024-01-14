import 'package:aiproject/project1/mainPage.dart';
import 'package:aiproject/project2/project2.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'project1/Algorithm.dart';

void main()async{
  runApp(MaterialApp(home: const myMainPage(),));
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = WindowOptions(
    size: Size(800, 600),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );
  WindowManager.instance.setResizable(false);
}

class myMainPage extends StatelessWidget {
  const myMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.blue,Colors.yellow])),
        child: Stack(
          children: [
            Row(children: [Text("AI",style: TextStyle(color: Colors.white,fontSize: 40),),],mainAxisAlignment: MainAxisAlignment.center,),
            Positioned(
              top: MediaQuery.sizeOf(context).height/2,
              child: Container(
                width: MediaQuery.sizeOf(context).width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    algorithmType("lib/images/intro.png","Illuminating Connections",(){Navigator.push(context, MaterialPageRoute(builder: (context)=>mainPage()));}),
                    SizedBox(width: 20,),
                    algorithmType("lib/images/tic.png","tic tac toe",(){Navigator.push(context, MaterialPageRoute(builder: (context)=>Prj2()));}),//Navigator.push(context, MaterialPageRoute(builder: (context)=>myMainPage()));
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  Column algorithmType(String image,String Name,Function function){
    return Column(
      children: [
        InkWell(
          onTap: (){function();},
          child:Card(elevation: 10,
            child: Container(alignment: Alignment.center,
              height: 100,width: 100,
              decoration: BoxDecoration(image: DecorationImage(image: AssetImage(image),fit: BoxFit.fill),borderRadius: BorderRadius.circular(15),),
            ),
          ),
        ),
        Text(Name,style: TextStyle(color: Colors.white,fontSize: 20),)
      ],
    );
  }
}