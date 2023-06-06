import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:street_fighter/sprites/player.dart';

class StreetFighter extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection{
  StreetFighter();

  // @override
  // Color backgroundColor() => const Color(0xffffffff);

  late Player player;

  @override
  Future<void> onLoad() async{
    overlays.add('gameOverlay');
  }

  @override
  void update(double dt){
    super.update(dt);
  }

  void startGame(){
    initializeGameStart();
    overlays.remove('gameOverlay');
    player.resetPosition();
  }

  void resetGame(){
    startGame();
  }

  void initializeGameStart(){
    setCharacter();
  }

  void setCharacter(){
    player = Player(
      // character:
    );
    add(player);
  }

}
