import 'dart:async';

import 'package:flappybirdclone/barriers.dart';
import 'package:flappybirdclone/bird.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget { 
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double birdYaxis = 0;
  double time = 0;
  double height = 0;
  double initialHeight = birdYaxis;
  bool gameHasStarted = false;
  static double barrierXone = 1;
  double barrierXtwo = barrierXone + 1.5;

  int score = 0;
  int best = 0;



  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Flappy Bird Clone'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Game Over'),
                Text('Score : $score'),
                Text('Play Again?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                setState(() {
                  birdYaxis = 0;
                  time = 0;
                  height = 0;
                  initialHeight = birdYaxis;
                  barrierXone = 1;
                  barrierXtwo = barrierXone + 1.5;
                  if(score >= best){
                    best = score;
                    score = 0;
                  }else{
                    score = 0;
                  }
                  gameHasStarted = false;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void jump(){
    setState(() {
      time = 0;
      initialHeight = birdYaxis;
    });
  }

  void startGame(){
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 60), (timer) {

      time += 0.05;
      height = -4.9 * time * time + 2.8 * time;
      setState(() {
        birdYaxis = initialHeight - height;
      });

      setState(() {
        if(barrierXone < -2){
          barrierXone += 3.5;
          score +=10;
        }else{
          barrierXone -= 0.05;
        }
      });

      setState(() {
        if(barrierXtwo < -2){
          barrierXtwo += 3.5;
          score +=10;
        }else{
          barrierXtwo -= 0.05;
        }
      });

      if(birdYaxis > 1){
        timer.cancel();
        gameHasStarted = false;
        _showMyDialog();
      }



    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(gameHasStarted){
          jump();
        }else{
          startGame();
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 2,
                child: Stack(
                  children: [
                    AnimatedContainer(
                      alignment: Alignment(0,birdYaxis),
                      duration: Duration(milliseconds: 0),
                      color: Colors.blue,
                      child: MyBird(),
                    ),
                    Container(
                      alignment: Alignment(0,-0.3),
                      child: gameHasStarted ? Text("") : Text("T A P   T O   P L A Y",style: TextStyle(
                        fontSize: 20,
                        color: Colors.white
                      ),),
                    ),
                    AnimatedContainer(
                      alignment: Alignment(barrierXone,1.1), // 1.1
                      duration: Duration(milliseconds: 0),
                      child: MyBarrier(
                        size: 150.0, // 200
                      ),
                    ),
                    AnimatedContainer(
                      alignment: Alignment(barrierXone,-1.1), // 1.1
                      duration: Duration(milliseconds: 0),
                      child: MyBarrier(
                        size: 140.0, //200
                      ),
                    ),
                    AnimatedContainer(
                      alignment: Alignment(barrierXtwo,1.1), // 1.1
                      duration: Duration(milliseconds: 0),
                      child: MyBarrier(
                        size: 180.0, //150
                      ),
                    ),
                    AnimatedContainer(
                      alignment: Alignment(barrierXtwo,-1.1), // 1.1
                      duration: Duration(milliseconds: 0),
                      child: MyBarrier(
                        size: 200.0, //250
                      ),
                    ),

                  ],
                )
            ),
            Container(
              height: 15,
              color: Colors.green,
            ),
            Expanded(
                child: Container(
                  color: Colors.brown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("SCORE",style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),),
                          SizedBox(height: 20,),
                          Text("$score",style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                          ),),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("BEST",style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),),
                          SizedBox(height: 20,),
                          Text("$best",style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                          ),),
                        ],
                      )
                    ],
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}
