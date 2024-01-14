import 'package:flutter/material.dart';

import 'TicTacClass.dart';

class Prj2 extends StatefulWidget {
  const Prj2({super.key});

  @override
  State<Prj2> createState() => _Prj2State();
}

class _Prj2State extends State<Prj2> {
  TicTacToe game=TicTacToe();
  Size size = Size(0, 0);
  bool isPlaying=false;
  List wins=[];
  bool showNext=false;
  @override
  Widget build(BuildContext context) {
    print(wins.contains([0,2]));
    print(wins);
    size = MediaQuery.sizeOf(context);
    return Scaffold(
        body: Container(
      padding: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.yellow, Color(0xfffe9923)])),
      height: size.height,
      child: Stack(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Tic Tac Toe",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: size.width*0.04,
                        color: Color(0xff5dc0f2)),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.1,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Player(1),
                  Container(
                    height: size.height * 0.7,
                    width: size.width / 3,
                    child: GridView(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: size.width * 0.051,
                            mainAxisSpacing: size.width * 0.051),
                        children: XOrO()),
                  ),
                  Player(2),
                ],
              ),
            ],
          ),
          Container(child: CustomPaint(painter: line(size,false),),),
          Positioned(
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.black,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            left: 10,
          ),
          Positioned(
              bottom: 0,
              child:
                  Container(
                    width: size.width,
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                    Text(
                    game.AiScore.toString(),
                    style: TextStyle(fontSize: size.width * 0.05),
                                    ),
                                    Text(
                    ':',
                    style: TextStyle(fontSize: size.width * 0.05),
                                    ),
                                    Text(game.humanScore.toString(),
                      style: TextStyle(
                        fontSize: size.width * 0.05,
                      ))
                                  ]),
                  )),
          Positioned(child: Text("Round "+game.round.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),top: size.height*0.2,left: size.width*0.15,),
          Visibility(
            visible: showNext,
            child: Positioned(child: TextButton(child: Text(game.round>=5?"restart":"next",style: TextStyle(fontSize: 20,color: Colors.red),),
              onPressed: (){
              if(game.round>=5){
                game.round=0;
                game.humanScore=0;
                game.AiScore=0;
                showNext=false;
                wins.clear();
                game.nextGame();
                setState(() {});

              }
              else{
                game.nextGame();
                showNext=false;
                wins.clear();
                setState(() {});
              }
            },
            ),top: size.height*0.25,left: size.width*0.15,),
          )
        ],
      ),
    ));
  }
  Container Player(int n) {
    return Container(
      width: size.width * 0.3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            n == 1 ? "lib/images/close.png" : "lib/images/o.png",
            width: size.width * 0.051,
            color: n==1?Colors.blue:Colors.red,
          ),
          SizedBox(
            height: 20,
          ),
          CircleAvatar(
            child: n==1?Icon(
              Icons.account_circle,
              size: size.width * 0.1,
            ):Image.asset('lib/images/robot.png'),
            radius: size.width * 0.05,
            backgroundColor: Colors.transparent,
          ),
          Text(
            n==1?
            'You ':"AI",
            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
  List<Widget> XOrO() {
    List<Widget> list = [];
    for (int i = 0; i < 9; i++) {
      int answer = game.board[(i / 3).floor()][i % 3];
      if (answer!=0) {
        list.add(
            Container(
              color: contains([(i / 3).floor(),i % 3])?Colors.greenAccent:null,
          child: Image(
            image: AssetImage(
                answer == 1 ? "lib/images/o.png" : "lib/images/close.png"),
            color: Color(answer == 1 ? 0xfff15f25 : 0xff1e8ffa
            ),

          ),
        ));
      } else {
        list.add(
            InkWell(
              onTap: (){
                if(!isPlaying) {
                  isPlaying = true;
                  game.board[(i / 3).floor()][i % 3] = -1;
                  setState(() {});
                  if (game.check(false)) {
                    paintWin(game.handlefinish(false));
                    isPlaying=false;
                  }
                  else{
                    Future.delayed(const Duration(milliseconds: 500)).then((value){
                      game.getBestMove();
                      setState(() {});
                      if(game.check(true)){
                        paintWin(game.handlefinish(true));
                      }
                      isPlaying=false;
                    });
                  }
                }
                },
              child: Container(
                        height: size.width,
                        width: size.width,
                        decoration: BoxDecoration(
              color: Colors.grey.shade700,borderRadius: BorderRadius.circular(15)),
                      ),
            ));
      }
    }
    return list;
  }
  void paintWin(List list){
    if(game.round>=5){
      handleFinish(context,game.AiScore);
    }
    if(list.isNotEmpty){
      wins=(list);
      showNext=true;
    }else{
      showNext=true;
    }
    setState(() {});
  }

  bool contains(List list){
    for(List x in wins){
      if(x[0]==(list[0]) && x[1]==(list[1])){
        return true;
      }
    }
    return false;
  }
}
class line extends CustomPainter{
  Size size;
  bool win;
  line(this.size,bool this.win) {
  }
  @override
  void paint(Canvas canvas, Size size) {
    size=this.size;
    Paint paint = Paint()..color = Colors.black..style = PaintingStyle.stroke..strokeWidth = 8.0;
    canvas.drawLine(Offset(size.width*0.33,size.height*0.4),Offset(size.width*0.67,size.height*0.4), paint);
    canvas.drawLine(Offset(size.width*0.33,size.height*0.63),Offset(size.width*0.67,size.height*0.63), paint);
    canvas.drawLine(Offset(size.width*0.43,size.height*0.19),Offset(size.width*0.43,size.height*0.82), paint);
    canvas.drawLine(Offset(size.width*0.56,size.height*0.19),Offset(size.width*0.56,size.height*0.82), paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}
void handleFinish(context,AiScore){
  showDialog(context: context, builder: (context){
    return Dialog(child: Container(
      width: 200,
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  AiScore>0?"you have Lost":"Nobody Win!",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            ],
          ),

          Container(child: TextButton(onPressed: (){Navigator.pop(context);}, child: Text("Continue",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),),color: Colors.blue,)
        ],
      ),
    ),
    );
  });
}