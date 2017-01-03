package;

import flixel.FlxObject;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;

class Player extends FlxSprite{
    private var speed    : Float = 200;
    private var jTime    : Float = 0;
    private var jMax     : Float = .2;
    public var onGround  : Bool  = true;

    public function new(?X:Float=0, ?Y:Float=0){
        super(X, Y);
        loadGraphic(AssetPaths.p__png, true, 32, 32);
        ////// Hitbox Placement
        setSize(10, 13);
        centerOffsets();
        offset.y = 19;
        ////// Animation
        setFacingFlip(FlxObject.LEFT,  true, false);
        setFacingFlip(FlxObject.RIGHT, false, false);
        animation.add("lr", [1, 2, 3, 4], 4, false);
        animation.add("i",  [1], 1, false);
        animation.add("p",  [5], 4, false);
        ////// Movement
        drag.x = drag.y = 1600;

    }

    override public function update(elapsed : Float) : Void{
        super.update(elapsed);
        if(onGround){
            jTime = 0;
        }
        pAnimation(movement(elapsed));
    }
    // TODO
    // Jump stops 1 frame above ground
    // Collision callback
    // Idle frame offset
    // Jump mechanics( ya function?, 2x, wall jump?)
    // Tune vars

    private function pAnimation(move : Pmove) : Void{
        if((velocity.x != 0 || velocity.y != 0) &&
        touching == FlxObject.NONE){
            switch(move){
                case Left, Right:
                    if(onGround){ animation.play("lr"); }
                case Jump:
                    if(onGround){ animation.play("p"); }
                default:
                    if(onGround){ animation.play("i"); }
            }
        }
    }

    private function movement(elapsed : Float) : Pmove {
        var toReturn : Pmove = None;
        /////// Input
        var up    : Bool = false;
        var down  : Bool = false;
        var left  : Bool = false;
        var right : Bool = false;
        up    = FlxG.keys.anyPressed([SPACE, UP, W]);
        down  = FlxG.keys.anyPressed([DOWN,  S]);
        left  = FlxG.keys.anyPressed([LEFT,  A]);
        right = FlxG.keys.anyPressed([RIGHT, D]);

        if(up && down){
            up = down = false;
            return toReturn;
        }
        if(left && right){
            left = right = false;
            return toReturn;
        }

        ////// Handle movement
        var xa : Float  = 0;
        var ya : Float  = 0;
        if( up || down || left || right){
            if(left){
                xa = -1;
                facing = FlxObject.LEFT;
                velocity.x = xa * speed;
                toReturn = Left;
            }
            else if(right){
                xa = 1;
                facing = FlxObject.RIGHT;
                velocity.x = xa * speed;
                toReturn = Right;
            }
            if(up){
                if(!onGround){
                    jTime += elapsed;
                }
                if(jTime < jMax){
                    if(ya == 0){ ya = -2; }
                    else{ ya *= .5;}
                    velocity.y = ya * speed;
                }
                toReturn = Jump;
            }
        }
        return toReturn;
    }

}

enum Pmove {
    Left;
    Right;
    Jump;
    Down;
    None;
}
