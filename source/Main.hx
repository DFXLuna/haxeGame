// Main.hx
// Matt Grant(teamuba@gmail.com)

package;

import flixel.FlxGame;
import openfl.Lib;
import openfl.display.Sprite;

// Real Res is 640 x 480

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(320, 240, MenuState, 1, 60, 60, true));
	}
}
