package substates;

import backend.Highscore;
import backend.Song;
import backend.WeekData;
import flixel.addons.display.FlxBackdrop;

import flixel.util.FlxStringUtil;
import flixel.math.FlxMath;
import states.StoryMenuState;
import states.FreeplayState;

class NewPauseSubState extends MusicBeatSubstate
{
	var grpMenuItems:FlxTypedGroup<FlxSprite>;
	var curSelected:Int = 1;

	var pauseMusic:FlxSound;
	var bg:FlxSprite;
	var dots:FlxBackdrop;
    var paperObject:PaperObject;
    var isResumeSelected:Bool = true;
    var isRestartSelected:Bool = true;

    override function create()
    {
        super.create();

		pauseMusic = new FlxSound();
		try {
			var pauseSong:String = getPauseSong();
			if (pauseSong != null) pauseMusic.loadEmbedded(Paths.music(pauseSong), true, true);
		} catch (e:Dynamic) {}
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));
		pauseMusic.fadeIn(4);
		FlxG.sound.list.add(pauseMusic);

		bg = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
		bg.scale.set(FlxG.width, FlxG.height);
		bg.updateHitbox();
		bg.alpha = 0; // empieza invisible para el fade in
		bg.scrollFactor.set();
		bg.antialiasing = ClientPrefs.data.antialiasing;
		add(bg);

		FlxTween.tween(bg, {alpha: 0.6}, 0.5, {ease: FlxEase.linear});

		dots = new FlxBackdrop(Paths.image('gallery/lines'), XY);
		dots.velocity.set(10, 10);
		dots.alpha = 0;
		dots.antialiasing = ClientPrefs.data.antialiasing;
		add(dots);

		FlxTween.tween(dots, {alpha: 0.25}, 0.5, {ease: FlxEase.linear});

        paperObject = new PaperObject(0, 0, PlayState.instance.songPercent);
        paperObject.screenCenter();
        add(paperObject);

        camera = FlxG.cameras.list[FlxG.cameras.list.length - 1];
    }

	public static var songName:String = null;
	function getPauseSong()
	{
		var formattedSongName:String = (songName != null ? Paths.formatToSongPath(songName) : '');
		var formattedPauseMusic:String = Paths.formatToSongPath(ClientPrefs.data.pauseMusic);
		if (formattedSongName == 'none' || (formattedSongName != 'none' && formattedPauseMusic == 'none')) return null;
		return (formattedSongName != '') ? formattedSongName : formattedPauseMusic;
	}

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if(controls.UI_UP_P || controls.UI_DOWN_P)
        {
            FlxG.sound.play(Paths.sound('scrollMenu'), 1);
            isResumeSelected = !isResumeSelected;
        }

        if(controls.UI_LEFT_P || controls.UI_RIGHT_P)
        {
            FlxG.sound.play(Paths.sound('scrollMenu'), 1);
            isRestartSelected = !isRestartSelected;
        }

        if(controls.ACCEPT)
        {
            if(isResumeSelected) closePauseMenu();
            else if(isRestartSelected) restartSong();
            else
            {
				#if DISCORD_ALLOWED DiscordClient.resetClientID(); #end
				PlayState.deathCounter = 0;
				PlayState.seenCutscene = false;
				Mods.loadTopMod();
				if (PlayState.isStoryMode)
					MusicBeatState.switchState(new StoryMenuState());
				else
					MusicBeatState.switchState(new FreeplayState());
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
				PlayState.changedDifficulty = false;
				PlayState.chartingMode = false;
				FlxG.camera.followLerp = 0;
            }
        }

        if(isResumeSelected)
        {
            paperObject.resumeButton.alpha = 1;
            paperObject.restartButton.alpha = 0.6;
            paperObject.exitButton.alpha = 0.6;
        }
        else if(isRestartSelected)
        {
            paperObject.resumeButton.alpha = 0.6;
            paperObject.restartButton.alpha = 1;
            paperObject.exitButton.alpha = 0.6;
        }
        else
        {
            paperObject.resumeButton.alpha = 0.6;
            paperObject.restartButton.alpha = 0.6;
            paperObject.exitButton.alpha = 1;
        }
    }

	public static function restartSong(noTrans:Bool = false)
	{
		PlayState.instance.paused = true;
		FlxG.sound.music.volume = 0;
		PlayState.instance.vocals.volume = 0;
		if(noTrans) {
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
		}
		MusicBeatState.resetState();
	}

    function closePauseMenu()
    {
			pauseMusic.stop();
            close();
    }
}

class PaperObject extends FlxSpriteGroup
{
    var paperBack:FlxSprite;
    public var resumeButton:FlxSprite;
    public var restartButton:FlxSprite;
    public var exitButton:FlxSprite;
    var progressArrow:FlxSprite;
    var progressBar:FlxSprite;

    public function new(x:Float = 0, y:Float = 0, progress:Float)
    {
        super(x, y);

        function centerSprite(spr1:FlxSprite, spr2:FlxSprite)
        {
            spr1.x = spr2.x + (spr2.width / 2) - (spr1.width / 2);
            spr1.y = spr2.y + (spr2.height / 2) - (spr1.height / 2);
        }

        paperBack = new FlxSprite();
        //paperBack.loadGraphic(Paths.image('pause/new/paper'));
        paperBack.frames = Paths.getSparrowAtlas('pause/new/paper');
        paperBack.animation.addByPrefix('idle', 'papersos', 24, true);
        paperBack.animation.play('idle');
        paperBack.antialiasing = ClientPrefs.data.antialiasing;
        add(paperBack);

        resumeButton = new FlxSprite();
        resumeButton.loadGraphic(Paths.image('pause/new/resume'));
        centerSprite(resumeButton, paperBack);
        resumeButton.antialiasing = ClientPrefs.data.antialiasing;
        resumeButton.y += -110;
        add(resumeButton);

        restartButton = new FlxSprite();
        restartButton.loadGraphic(Paths.image('pause/new/restart'));
        centerSprite(restartButton, paperBack);
        restartButton.antialiasing = ClientPrefs.data.antialiasing;
        restartButton.y += 10;
        restartButton.x += -90;
        add(restartButton);

        exitButton = new FlxSprite();
        exitButton.loadGraphic(Paths.image('pause/new/exit'));
        centerSprite(exitButton, paperBack);
        exitButton.antialiasing = ClientPrefs.data.antialiasing;
        exitButton.y += 10;
        exitButton.x += 90;
        add(exitButton);

        progressBar = new FlxSprite();
        progressBar.loadGraphic(Paths.image('pause/new/progressbar'));
        centerSprite(progressBar, paperBack);
        progressBar.y += 150;
        progressBar.antialiasing = ClientPrefs.data.antialiasing;
        add(progressBar);

        progressArrow = new FlxSprite();
        progressArrow.loadGraphic(Paths.image('pause/new/progressarrow'));
        progressArrow.antialiasing = ClientPrefs.data.antialiasing;
        progressArrow.y = progressBar.y - 25;
        progressArrow.x = progressBar.x;
        add(progressArrow);

        var distance:Float = progressBar.width;
        //FlxTween.tween(progressArrow, {x: progressBar.x + (progressBar.width * progress)}, 0.9, {ease: FlxEase.quartOut});
        progressArrow.x = progressBar.x + (progressBar.width * progress);
    }
}