package backend;

import flixel.util.FlxSave;

class PlayedTime
{
    /**
     * The save file where played time is saved
    **/
    public static var timeSave:FlxSave;
    /**
     * Total time you have been playing the game (in seconds)
    **/
    public static var time:Int = 0;

    public static function loadPlayedTime():Void
    {
        timeSave = new FlxSave();
        timeSave.bind('playedTime', CoolUtil.getSavePath());
        timeSave.data.playedTime = timeSave.data.playedTime == null ? 0 : timeSave.data.playedTime;
        time = timeSave.data.playedTime;

        #if debug 
        trace('Loaded play time (current played time is $time seconds)');
        #end
    }

    public static function updateTime():Void
    {
        // avoid crash (just in case)
        if(timeSave == null) return;

        time++;
        timeSave.data.playedTime = time;
        timeSave.flush();

        #if debug 
        trace('You have played for $time seconds! (${time/60} minutes) (${time/3600} hours)');
        #end
    }
}