package;

import flixel.util.FlxColor;
import sys.FileSystem;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;

using StringTools;

class ModsMenuState extends MusicBeatState
{
	var curSelected:Int = 0;
	private var grpSongs:FlxTypedGroup<Alphabet>;

	override function create()
	{
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'));
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i => mod in FileSystem.readDirectory("./mods"))
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, mod, true, false, true);
			songText.color = songText.text == FlxG.save.data.modSelected ? FlxColor.LIME : FlxColor.WHITE;
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);
		}

		changeSelection();

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var upP = FlxG.keys.justPressed.UP;
		var downP = FlxG.keys.justPressed.DOWN;
		var accepted = controls.ACCEPT;

		if (upP)
			changeSelection(-1);
		if (downP)
			changeSelection(1);

		if (controls.BACK)
			FlxG.switchState(() -> new MainMenuState());

		if (accepted)
		{
			FlxG.save.data.modSelected = grpSongs.members[curSelected].text;
			Paths.ASSETS_PATH = ["mods/" + FlxG.save.data.modSelected, "assets"];

			for (item in grpSongs.members)
				item.color = item.text == FlxG.save.data.modSelected ? FlxColor.LIME : FlxColor.WHITE;
		}
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected = FlxMath.wrap(curSelected + change, 0, grpSongs.length - 1);

		var bullShit:Int = 0;

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