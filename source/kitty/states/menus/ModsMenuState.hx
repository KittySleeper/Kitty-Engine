package kitty.states.menus;

import sys.FileSystem;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import kitty.objects.Alphabet;

class ModsMenuState extends MusicBeatState
{
	var curSelected:Int = 0;
	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var grpIcons:Array<FlxSprite> = [];
	var modList:Array<String> = ["Base Game"];

	override function create()
	{
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'));
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i => mod in FileSystem.readDirectory("./mods"))
			if (!modList.contains(mod))
				modList.push(mod);

		for (i => mod in modList)
		{
			var modIcon:FlxSprite = new FlxSprite(0, 0, ModHandler.getModIcon(mod));
			grpIcons.push(modIcon);
			add(modIcon);

			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, ModHandler.getModMeta(mod).modName, true, false, true);
			songText.color = mod == FlxG.save.data.modSelected ? FlxColor.LIME : FlxColor.WHITE;
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

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
			changeSelection(-1);
		if (downP)
			changeSelection(1);

		if (controls.BACK)
			FlxG.switchState(() -> new MainMenuState());

		if (accepted)
		{
			FlxG.save.data.modSelected = modList[curSelected];
			ModHandler.initialize();

			for (i => item in grpSongs.members)
				item.color = i == curSelected ? FlxColor.LIME : FlxColor.WHITE;
		}

		for (i => modIcon in grpIcons)
		{
			modIcon.setPosition(grpSongs.members[i].x + grpSongs.members[i].width + 30, grpSongs.members[i].y - 30);
			modIcon.alpha = grpSongs.members[i].alpha;
		}
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		curSelected = FlxMath.wrap(curSelected + change, 0, grpSongs.length - 1);

		var bullShit:Int = 0;

		for (i => item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
				item.alpha = 1;
		}
	}
}