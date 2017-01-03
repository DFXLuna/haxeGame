package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.FlxObject;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxCollision;
import flixel.math.FlxMath;
import flixel.tile.FlxTilemap;
import flixel.group.FlxGroup;

import flixel.addons.editors.ogmo.FlxOgmoLoader;

class PlayState extends FlxState{
    ////// Player
    private var player  : Player;
    ////// Level
    private var level   : FlxOgmoLoader;
    private var floor   : FlxTilemap;
    private var bg      : FlxTilemap;
    ////// Gravity
    private var gMax    : Float;
    private var grav    : Float;
    private var gobj    : FlxTypedGroup<FlxSprite>;

	override public function create() : Void{
        ////// Level init
        level = new FlxOgmoLoader(AssetPaths.test__oel);
        ////// BG
        bg = level.loadTilemap(AssetPaths.sheet__png, 16, 16, "bg");
        add(bg);
        ////// Floor
        floor = level.loadTilemap(AssetPaths.sheet__png, 16, 16, "floor");
        for(i in 1...136){
            floor.setTileProperties(i, FlxObject.ANY);
        }
        floor.follow();
        add(floor);
        ////// Player
        player = new Player();
        level.loadEntities(placeEntities, "entities");
        add(player);
        ////// Gravity
        grav = 50;
        gMax = 400;
        gobj = new FlxTypedGroup<FlxSprite>();
        gobj.add(player);
        ////// Camera
        FlxG.camera.follow(player, PLATFORMER, 1);
        FlxG.camera.fade(FlxColor.BLACK, .33, true);
		super.create();
	}

    private function placeEntities(entityName : String,
        entityData : Xml) : Void{
            var x : Int = Std.parseInt(entityData.get("x"));
            var y : Int = Std.parseInt(entityData.get("y"));
            if(entityName == "player"){
                player.x = x;
                player.y = y;
            }
    }

	override public function update(elapsed:Float) : Void{
        if(player.y > 480){ FlxG.switchState(new PlayState()); }

        super.update(elapsed);
        gravity();
        player.onGround = false;
        if(FlxG.collide(floor, player)){ player.onGround = true; }


	}

    public function gravity(){
        for(e in gobj){
            if(!e.isTouching(FlxObject.FLOOR)){
                e.velocity.y += grav;
                if(e.velocity.y >= gMax){ e.velocity.y = gMax; }
            }
            // Possibly uneeded
            else{ e.velocity.y = 0; }
        }
    }
}
