import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:street_fighter/street_fighter.dart';

enum PlayerState { walkFront, walkBack, jump, punch, kick, standing, duckDown, hadoken }

class Player extends SpriteAnimationGroupComponent<PlayerState>
    with HasGameRef<StreetFighter>, CollisionCallbacks, KeyboardHandler {
  // final int walkSpeed;
  late SpriteAnimation walking;

  double frameTimer = 0;
  double frameInterval = 0.2; // Adjust the interval as needed
  int currentAnimationFrame = 0; // Define the currentAnimationFrame variable
  int gravity = 5;
  bool isJump = false;
  bool isGravity = true;
  double actualHeight = 250;

  Player({super.position});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await add(CircleHitbox());

    await _loadCharacterSprites();
    current = PlayerState.standing;
  }

  void resetPosition() {
    position = Vector2(150, actualHeight);
  }

  @override
  void update(double dt) {
    super.update(dt);

    frameTimer += dt;
    if (frameTimer >= frameInterval) {
      frameTimer = 0;

      final animation = animations?[current];

      if (animation != null) {
        currentAnimationFrame++;

        if (currentAnimationFrame >= animation.frames.length) {
          currentAnimationFrame = 0;
        }
      }
    }

    if (isJump) {
      if (actualHeight - 100 < position.y) {
        position.y -= 3;
      } else {
        isGravity = true;
      }
    }

    if (isGravity && current == PlayerState.jump){
     if(actualHeight != position.y){
       position.y += 3;
       isJump = false;
     } else{
       current = PlayerState.standing;
     }
    }
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      moveLeft();
      current = PlayerState.walkBack;
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      moveRight();
      current = PlayerState.walkFront;
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      isJump = true;
      isGravity = false;
      current = PlayerState.jump;
    } else if(keysPressed.contains(LogicalKeyboardKey.arrowDown)){
      current = PlayerState.duckDown;
    }else if(event.logicalKey.keyId == 97 ){
      current = PlayerState.hadoken;
    }

    if(event is RawKeyUpEvent && current != PlayerState.jump){
      current = PlayerState.standing;
      animation?.reset();
    }

    return true;
  }

  void jump() {
    position.x -= 3;
  }

  void moveLeft() {
    position.x -= 4;
  }

  void moveRight() {
    position.x += 4;
  }

  Future<void> _loadCharacterSprites() async {
    //load sprites  assets
    double areaWidth = 40;
    double areaHeight = 59;

    double expandWidth = 58;
    double expandHeight = 56;

    final ryu1 = await Flame.images.load('ryu/ryu1.png');
    final ryu2 = await Flame.images.load('ryu/ryu2.png');
    final ryu3 = await Flame.images.load('ryu/ryu3.png');

    SpriteAnimation standing = SpriteAnimation.spriteList([
      Sprite(ryu1,
          srcPosition: Vector2(areaWidth + 2, areaHeight + 2),
          srcSize: Vector2(areaWidth, areaHeight)),
    ], stepTime: 0.2, loop: false);

    SpriteAnimation walkBack = SpriteAnimation.spriteList([
      Sprite(ryu1,
          srcPosition: Vector2(areaWidth + 2, areaHeight + 2),
          srcSize: Vector2(areaWidth, areaHeight)),
      Sprite(ryu1,
          srcPosition: Vector2(areaWidth + 45, areaHeight + 2),
          srcSize: Vector2(areaWidth, areaHeight)),
      Sprite(ryu1,
          srcPosition: Vector2(areaWidth + 95, areaHeight + 2),
          srcSize: Vector2(areaWidth, areaHeight)),
      Sprite(ryu1,
          srcPosition: Vector2(areaWidth + 141, areaHeight + 2),
          srcSize: Vector2(areaWidth, areaHeight)),
      Sprite(ryu1,
          srcPosition: Vector2(areaWidth + 186, areaHeight + 2),
          srcSize: Vector2(areaWidth, areaHeight)),
    ], stepTime: 0.1, loop: true);

    SpriteAnimation walkFront = SpriteAnimation.spriteList([
      Sprite(ryu1,
          srcPosition: Vector2(0, 60), srcSize: Vector2(areaWidth, areaHeight)),
      Sprite(ryu1,
          srcPosition: Vector2(38, 60),
          srcSize: Vector2(areaWidth, areaHeight)),
      Sprite(ryu1,
          srcPosition: Vector2(82, 60),
          srcSize: Vector2(areaWidth, areaHeight)),
      Sprite(ryu1,
          srcPosition: Vector2(130, 60),
          srcSize: Vector2(areaWidth, areaHeight)),
      Sprite(ryu1,
          srcPosition: Vector2(176, 60),
          srcSize: Vector2(areaWidth, areaHeight)),
      Sprite(ryu1,
          srcPosition: Vector2(217, 60),
          srcSize: Vector2(areaWidth, areaHeight)),
    ], stepTime: 0.1, loop: true);

    SpriteAnimation jump = SpriteAnimation.spriteList([
      Sprite(ryu2,
          srcPosition: Vector2(3, 21), srcSize: Vector2(areaWidth, areaHeight)),
      Sprite(ryu2,
          srcPosition: Vector2(41, 18),
          srcSize: Vector2(areaWidth, areaHeight)),
      Sprite(ryu2,
          srcPosition: Vector2(78, 4), srcSize: Vector2(areaWidth, areaHeight)),
      Sprite(ryu2,
          srcPosition: Vector2(111, 0),
          srcSize: Vector2(areaWidth, areaHeight)),
      Sprite(ryu2,
          srcPosition: Vector2(151, 4),
          srcSize: Vector2(areaWidth, areaHeight)),
      Sprite(ryu2,
          srcPosition: Vector2(184, 11),
          srcSize: Vector2(areaWidth, areaHeight)),
      Sprite(ryu2,
          srcPosition: Vector2(218, 19),
          srcSize: Vector2(areaWidth, areaHeight)),
    ], stepTime: 0.4, loop: true);


    SpriteAnimation duckDown = SpriteAnimation.spriteList([
      Sprite(ryu2,
          srcPosition: Vector2(9, 200), srcSize: Vector2(areaWidth, areaHeight)),
      Sprite(ryu2,
          srcPosition: Vector2(49, 197),
          srcSize: Vector2(areaWidth, areaHeight)),
      Sprite(ryu2,
          srcPosition: Vector2(90, 198), srcSize: Vector2(areaWidth, areaHeight)),
    ], stepTime: 0.3, loop:false);


    SpriteAnimation hadoken = SpriteAnimation.spriteList([
      Sprite(ryu2,
          srcPosition: Vector2(0, 363), srcSize: Vector2(areaWidth, areaHeight)),
      Sprite(ryu2,
          srcPosition: Vector2(53, 363),
          srcSize: Vector2(expandWidth, expandHeight)),
      Sprite(ryu2,
          srcPosition: Vector2(109, 363), srcSize: Vector2(expandWidth, expandHeight)),
      Sprite(ryu2,
          srcPosition: Vector2(169, 363), srcSize: Vector2(expandWidth, expandHeight)),
    ], stepTime: 0.3, loop:false);



    animations = <PlayerState, SpriteAnimation>{
      PlayerState.walkFront: walkFront,
      PlayerState.walkBack: walkBack,
      PlayerState.standing: standing,
      PlayerState.jump: jump,
      PlayerState.duckDown: duckDown,
      PlayerState.hadoken: hadoken
    };
    final walkFrontAnimation = animations?[PlayerState.walkFront]!;
    walkFrontAnimation?.onComplete = () {
      currentAnimationFrame = 0;
    };
  }
}
