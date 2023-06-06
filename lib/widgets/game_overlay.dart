import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:street_fighter/street_fighter.dart';

class GameOverlay extends StatefulWidget {
  const GameOverlay(this.game, {Key? key}) : super(key: key);

  final Game game;

  @override
  State<GameOverlay> createState() => _GameOverlayState();
}

class _GameOverlayState extends State<GameOverlay> {
  bool isPaused = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          ElevatedButton(
              onPressed:(){
                (widget.game as StreetFighter).startGame();
              },
              child: Text("PLAY")
          )
        ],
      ),
    );
  }
}

