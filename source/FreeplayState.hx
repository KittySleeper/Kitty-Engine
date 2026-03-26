package;

import flixel.input.gamepad.FlxGamepad;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var bg:FlxSprite;
	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	var scoreText:FlxText;
	var comboText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;
	var combo:String = '';

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

	override function create()
	{
		var songList:Array<Dynamic> = Paths.json("data/freeplaySongList").songs;

		for (song in songList)
			addSong(song.name, song.storyWeek, song.icon, FlxColor.fromString(song.color), song.difficulties);

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.color = songs[0].songColor;
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false, true);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;
			iconArray.push(icon);
			add(icon);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);

		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		comboText = new FlxText(diffText.x + 100, diffText.y, 0, "", 24);
		comboText.font = diffText.font;
		add(comboText);

		add(scoreText);

		changeSelection();
		changeDiff();

		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";

		super.create();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String, songColor:FlxColor, songDifficulties:Array<Dynamic>)
		songs.push(new SongMetadata(songName, weekNum, songCharacter, songColor, songDifficulties));

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		bg.color = FlxColor.interpolate(bg.color, songs[curSelected].songColor, 0.12);

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "PERSONAL BEST:" + lerpScore;
		comboText.text = combo + '\n';

		var upP = FlxG.keys.justPressed.UP;
		var downP = FlxG.keys.justPressed.DOWN;
		var accepted = controls.ACCEPT;

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.DPAD_UP)
				changeSelection(-1);
			if (gamepad.justPressed.DPAD_DOWN)
				changeSelection(1);
			if (gamepad.justPressed.DPAD_LEFT)
				changeDiff(-1);
			if (gamepad.justPressed.DPAD_RIGHT)
				changeDiff(1);
		}

		if (upP)
			changeSelection(-1);
		if (downP)
			changeSelection(1);
		if (FlxG.keys.justPressed.LEFT)
			changeDiff(-1);
		if (FlxG.keys.justPressed.RIGHT)
			changeDiff(1);
		if (controls.BACK)
			FlxG.switchState(() -> new MainMenuState());

		if (accepted)
		{
			// adjusting the song name to be compatible
			var songFormat = StringTools.replace(songs[curSelected].songName, " ", "-");

			PlayState.SONG = Song.loadFromJson(songFormat, songs[curSelected].songDifficulties[curDifficulty].chartName, songs[curSelected].songDifficulties[curDifficulty].chartVariant);
			PlayState.storyDifficulty = songs[curSelected].songDifficulties[curDifficulty].chartName;
			PlayState.songVariant = songs[curSelected].songDifficulties[curDifficulty].chartVariant;
			PlayState.storyWeek = songs[curSelected].week;
			PlayState.isStoryMode = false;
			FlxG.switchState(() -> new PlayState());
		}
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty = FlxMath.wrap(curDifficulty + change, 0, songs[curSelected].songDifficulties.length - 1);
		trace(songs[curSelected].songDifficulties[curDifficulty], songs[curSelected].songDifficulties[curDifficulty].chartName);

		var songHighscore = StringTools.replace(songs[curSelected].songName, " ", "-");
		
		#if !switch
		intendedScore = Highscore.getScore(songHighscore, songs[curSelected].songDifficulties[curDifficulty].chartName);
		combo = Highscore.getCombo(songHighscore, songs[curSelected].songDifficulties[curDifficulty].chartName);
		#end

		diffText.text = songs[curSelected].songDifficulties[curDifficulty].chartName.toUpperCase();
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected = FlxMath.wrap(curSelected + change, 0, songs.length - 1);
		changeDiff();

		var songHighscore = StringTools.replace(songs[curSelected].songName, " ", "-");

		#if !switch
		intendedScore = Highscore.getScore(songHighscore, songs[curSelected].songDifficulties[curDifficulty].chartName);
		combo = Highscore.getCombo(songHighscore, songs[curSelected].songDifficulties[curDifficulty].chartName);
		#end

		FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName, null), 0);

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
				item.alpha = 1;
		}
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var songColor:FlxColor = FlxColor.WHITE;
	public var songDifficulties:Array<Dynamic> = [];

	public function new(song:String, week:Int, songCharacter:String, songColor:FlxColor, songDifficulties:Array<Dynamic>)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.songColor = songColor;
		this.songDifficulties = songDifficulties;
	}
}