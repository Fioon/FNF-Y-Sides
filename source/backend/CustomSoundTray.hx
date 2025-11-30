package backend;

import flixel.system.FlxAssets.FlxSoundAsset;
import openfl.utils.Assets;
import openfl.display.Bitmap;
import flixel.system.ui.FlxSoundTray;

class CustomSoundTray extends FlxSoundTray
{
    var graphicScale:Float = 0.30;
    var volumeMaxSound:String;

    public function new()
    {
        super();
        removeChildren();

        var bg:Bitmap = new Bitmap(Assets.getBitmapData(Paths.simpleImage("soundtray/volumeBg")));
        bg.scaleX = graphicScale;
        bg.scaleY = graphicScale;
        addChild(bg);

        y = -height;
        visible = false;

        var volume:Bitmap = new Bitmap(Assets.getBitmapData(Paths.simpleImage("soundtray/volumeText")));
        volume.scaleX = graphicScale;
        volume.scaleY = graphicScale;
        addChild(volume);

        var backingBar:Bitmap = new Bitmap(Assets.getBitmapData(Paths.simpleImage("soundtray/bars_10")));
        backingBar.x = 2;
        backingBar.y = 0;
        backingBar.scaleX = graphicScale;
        backingBar.scaleY = graphicScale;
        addChild(backingBar);
        backingBar.alpha = 0.4;

        _bars = [];

        for (i in 1...11)
        {
          var bar:Bitmap = new Bitmap(Assets.getBitmapData(Paths.simpleImage("soundtray/bars_" + i)));
          bar.x = 2;
          bar.y = 0;
          bar.scaleX = graphicScale;
          bar.scaleY = graphicScale;
          addChild(bar);
          _bars.push(bar);
        }

        y = -height;
        screenCenter();
    
        volumeUpSound = Paths.simpleSound("Volup");
        volumeDownSound = Paths.simpleSound("Voldown");
        volumeMaxSound = Paths.simpleSound("VolMAX");
        
        trace("Custom sound tray added!");
    }

    /**
     * This function updates the soundtray object.
     */
    public override function update(MS:Float):Void
    {
        // Animate sound tray thing
        if (_timer > 0)
        {
            _timer -= (MS / 1000);
        }
        else if (y > -height)
        {
            y -= (MS / 1000) * height * 0.5;

            if (y <= -height)
            {
                visible = false;
                active = false;

                #if FLX_SAVE
                // Save sound preferences
                if (FlxG.save.isBound)
                {
                    FlxG.save.data.mute = FlxG.sound.muted;
                    FlxG.save.data.volume = FlxG.sound.volume;
                    FlxG.save.flush();
                }
                #end
            }
        }
    }

    /**
     * Shows the volume animation for the desired settings
     * @param   volume    The volume, 1.0 is full volume
     * @param   sound     The sound to play, if any
     * @param   duration  How long the tray will show
     * @param   label     The test label to display
     */
    public override function showAnim(volume:Float, ?sound:FlxSoundAsset, duration = 1.0, label = "VOLUME")
    {
        if (sound != null)
            FlxG.sound.play(FlxG.assets.getSoundAddExt(sound));
        
        _timer = duration;
        y = 0;
        visible = true;
        active = true;
        
        final numBars = Math.round(volume * 10);
        for (i in 0..._bars.length)
        {
            if (i < numBars)
            {
                _bars[i].visible = true;
                _bars[i].alpha = 1.0;
            }
            else
            {
                _bars[i].visible = false;
                _bars[i].alpha = 0.5;
            }
        }
    }

    /**
     * Makes the little volume tray slide out.
     *
     * @param   up  Whether the volume is increasing.
     */
    override public function show(up:Bool = false):Void
    {
        if (up)
            showIncrement();
        else
            showDecrement();
    }
    
    override function showIncrement():Void
    {
        final volume = FlxG.sound.muted ? 0 : FlxG.sound.volume;
        var sound = silent ? null : volumeUpSound;
        
        // Check if volume is maxed out
        if (Math.round(volume * 10) == 10)
            sound = volumeMaxSound;
            
        showAnim(volume, sound);
    }
    
    override function showDecrement():Void
    {
        final volume = FlxG.sound.muted ? 0 : FlxG.sound.volume;
        showAnim(volume, silent ? null : volumeDownSound);
    }
}