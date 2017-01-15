// Player.hx
// Matt Grant(teamuba@gmail.com)

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
    private var jCount   : Float = 0;
    private var jCountMax: Float = 2;
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
        animation.add("lr", [0, 1, 2, 3], 8, false);
        animation.add("i",  [0], 1, false);
        animation.add("u",  [5], 4, false);
        animation.add("d",  [6], 4, false);
        ////// Movement
        drag.x = drag.y = 1600;

    }

    override public function update(elapsed : Float) : Void{
        super.update(elapsed);
        if(onGround){
            jTime = 0;
            jCount = 0;
        }
        pAnimation(movement(elapsed));
    }

    private function pAnimation(move : Pmove) : Void{
        //if((velocity.x != 0 || velocity.y != 0) &&
        //touching == FlxObject.NONE){
            switch(move){
                case Left, Right:
                    if(onGround){ animation.play("lr"); }
                default:
                    if(!onGround){
                        if(velocity.y < -0.5){ animation.play("u"); }
                        else                 { animation.play("d"); }
                    }
                    else { animation.play("i"); }
            }
        //}
    }

    private function movement(elapsed : Float) : Pmove {
        var toReturn : Pmove = None;
        /////// Input
        var up    : Bool = false;
        var down  : Bool = false;
        var left  : Bool = false;
        var right : Bool = false;
        var jrel  : Bool = false;
        up    = FlxG.keys.anyPressed([SPACE, UP, W]);
        down  = FlxG.keys.anyPressed([DOWN,  S]);
        left  = FlxG.keys.anyPressed([LEFT,  A]);
        right = FlxG.keys.anyPressed([RIGHT, D]);
        jrel  = FlxG.keys.anyJustReleased([SPACE, UP, W]);

        if(up && down){
            up = down = false;
            return toReturn;
        }
        if(left && right){
            left = right = false;
            return toReturn;
        }
        if(jrel && !onGround){
            jCount++;
            jTime = 0;
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
            if(up && jCount < jCountMax){
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
