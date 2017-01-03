package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.addons.ui.FlxUIButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class MenuState extends FlxState{
    ////// Buttons
    private var play : FlxUIButton;
    private var opt  : FlxUIButton;



	override public function create() : Void{
        ////// Sizes
        var buttonSize = [ FlxG.width / 2, FlxG.height / 6];
        var padding    = buttonSize[1] / 2;
        ////// Play Button
        play = new FlxUIButton(0, 0, "Play", onPlay);
        play.resize(buttonSize[0],buttonSize[1]);
        play.screenCenter(X);
        play.y = (FlxG.height / 2);
        add(play);
        ////// Option Button
        opt = new FlxUIButton(0, 0, "Options", onOpt);
        opt.resize(buttonSize[0],buttonSize[1]);
        opt.screenCenter(X);
        opt.y = (FlxG.height / 2) + buttonSize[1] + padding;
        add(opt);
        //////
		super.create();
	}

	override public function update(elapsed : Float) : Void{
		super.update(elapsed);
	}

    private function onPlay(){
        FlxG.camera.fade(FlxColor.BLACK,.33, false, function(){
            FlxG.switchState(new PlayState());
        });
    }

    private function onOpt(){

    }
}
