package substates;

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
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

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