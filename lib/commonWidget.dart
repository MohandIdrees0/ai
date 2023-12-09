import 'package:flutter/material.dart';

import 'DFS.dart';

var buttonStyle=TextButton.styleFrom(
  primary: Colors.white, // Text color
  backgroundColor: Colors.black, // Button background color
  padding: EdgeInsets.all(16), // Button padding
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8), // Button border radius
  ),
);
var textStyle=TextStyle(color: Colors.white,fontSize: 20);
TextButton textButton(String text,Function function){
  return TextButton(onPressed: (){function();}, child: Text(text),style:  buttonStyle);
}

String  FormAInstuction(bool isRight,int humanAtBoat,int monsterAtBoat){
  print(humanAtBoat);
  print(monsterAtBoat);
  String Direction=isRight?"right":"left";
  String human=humanAtBoat==0?"":" "+humanAtBoat.toString()+" human ,";
  String monster=monsterAtBoat==0?"":" "+monsterAtBoat.toString()+" monster";
  return ("move "+Direction+" with"+human+monster+" at the Boat");
}



class StarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height / 2);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width, 0);
    for (int i = 0; i < 10; i++) {
      path.quadraticBezierTo(size.width * 0.95 - i * 0.15 * size.width,
          size.height * 0.1, size.width * 0.9 - i * 0.15 * size.width, 10);
      path.quadraticBezierTo(size.width * 0.875 - i * 0.15 * size.width, -5,
          size.width * 0.85 - i * 0.15 * size.width, 10);
    }
    path.lineTo(0, 0);
    path.close();

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}


Row elements(int human, int monster,Size size){
  return Row(children: [returnStack(human, true,size),returnStack(monster, false,size)],);
}
Stack returnStack(int number,bool ishuman,Size size){
  Row row1=Row();
  Row row2=Row();
  if(number>=2){
    row1=Row(children: [humanMonsterImage(ishuman,size),humanMonsterImage(ishuman,size)],mainAxisAlignment: MainAxisAlignment.spaceBetween,);
    number-=2;
  }
  if(number==1){
    row2=Row(children: [humanMonsterImage(ishuman,size)],mainAxisAlignment: MainAxisAlignment.center,);
  }
  return Stack(children: [row1,row2],alignment: Alignment.center,);
}

Image humanMonsterImage(bool ishuman,Size size){
  return Image(image: AssetImage(ishuman?"lib/man.png":"lib/ogre.png"),width: size.width*0.05,fit: BoxFit.fill,);
}


void fillSizes(Map sizes,Size size){
  sizes["width"]=size.width;
  sizes["height"]=size.height;
  sizes["landSize"]=size.width*0.20;
  sizes["boatWidth"]=size.width/2.8;
}

String reSetElements(List list,Map map){
  CurrentState state=list.removeLast();
  if(!state.boatAtRight){
    map["humanAtRight"]=map["humanAtRight"]!+(map["humanAtBoat"]!);
    map["monsterAtRight"]=map["monsterAtRight"]!+(map["monsterAtBoat"]!);
    map["monsterAtRight"]=state.monster;
    map["humanAtRight"]=state.human;
    map["monsterAtBoat"]=3-state.monster-map["monsterAtLeft"]!;
    map["humanAtBoat"]=3-state.human-map["humanAtLeft"]!;
  }
  else{
    map["humanAtLeft"]=map["humanAtLeft"]!+(map["humanAtBoat"]!);
    map["monsterAtLeft"]=map["monsterAtLeft"]!+(map["monsterAtBoat"]!);
    map["monsterAtBoat"]=state.monster-map["monsterAtRight"]!;
    map["humanAtBoat"]=state.human-map["humanAtRight"]!;
    map["monsterAtLeft"]=map["monsterAtLeft"]!-map["monsterAtBoat"]!;
    map["humanAtLeft"]=map["humanAtLeft"]!-map["humanAtBoat"]!;
  }
  return FormAInstuction(state.boatAtRight,map["humanAtBoat"]!,map["monsterAtBoat"]!);
}
void fillMap(Map map){
  map['monsterAtRight']=3;
  map['monsterAtLeft']=0;
  map['humanAtRight']=3;
  map['humanAtLeft']=0;
  map['humanAtBoat']=0;
  map['monsterAtBoat']=0;
}

Future success(BuildContext context){
  return showDialog(context: context, builder: (BuildContext context) {
    return  AlertDialog(
      backgroundColor: Colors.amber,
      title: const Center(child: Text('Execution Time',style: TextStyle(color: Colors.white))),
      content:  Wrap(direction: Axis.vertical,
        children: [
          RichText(text: TextSpan(children: [
            TextSpan(text: 'ON Average FBS TAKES ',style: TextStyle(color: Colors.white)),
            TextSpan(text: '1080',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
            TextSpan(text: ' AND DFS TAKES ',style: TextStyle(color: Colors.white)),
            TextSpan(text: '900',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
            TextSpan(text: ' MICROSECNDS',style: TextStyle(color: Colors.white)),
          ]),),
          Text('For more information About Execution Time and more you can read our reoport',style: TextStyle(color: Colors.white),),

        ],
      ),

    );
  },);
}