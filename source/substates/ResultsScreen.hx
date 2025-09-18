package substates;

import flixel.addons.display.FlxBackdrop;

import states.StoryMenuState;
import states.FreeplayState;

class ResultsScreen extends MusicBeatSubstate
{
    override function create() 
    {
        super.create();

        var bg = new FlxSprite();
        bg.makeGraphic(FlxG.width, FlxG.height, 0xFFCFC6F3);
        add(bg);

        var patternDown = new ResultsScreenPattern(0, 0);
        patternDown.y = FlxG.height - patternDown.height;
        patternDown.velocity.set(10, 0);
        add(patternDown);

        var patternUp = new ResultsScreenPattern(0, 0, true);
        patternUp.y = 0;
        patternUp.flipY = true;
        patternUp.velocity.set(-10, 0);
        add(patternUp);
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if(controls.BACK)
        {
            if(PlayState.isStoryMode)
            {
		    	FlxTransitionableState.skipNextTransIn = true;
		    	FlxTransitionableState.skipNextTransOut = true;
                MusicBeatState.switchState(new StoryMenuState());
            }
            else
            {
		    	FlxTransitionableState.skipNextTransIn = true;
		    	FlxTransitionableState.skipNextTransOut = true;
                MusicBeatState.switchState(new FreeplayState());
            }
        }
    }
}

/**
 * Lettabox
 */
class ResultsScreenPattern extends FlxSpriteGroup
{
    var darkPattern:FlxBackdrop;
    var lightPattern:FlxBackdrop;

    public function new(x:Float, y:Float, flipPatternY:Bool = false)
    {
        super(x, y);

        darkPattern = new FlxBackdrop(Paths.image('resultsScreen/newResultsScreen/lettaBoxDark'), #if (flixel <= "5.0.0") 0.2, 0.2, true, true #else X #end);
        add(darkPattern);

        lightPattern = new FlxBackdrop(Paths.image('resultsScreen/newResultsScreen/lettaBoxLight'), #if (flixel <= "5.0.0") 0.2, 0.2, true, true #else X #end);
        lightPattern.y = flipPatternY ? darkPattern.y : darkPattern.y + darkPattern.height - lightPattern.height;
        add(lightPattern);
    }
}