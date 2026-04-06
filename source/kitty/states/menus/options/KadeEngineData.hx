package kitty.states.menus.options;

import kitty.states.menus.options.Options;
import kitty.backend.KeyBinds;
import kitty.states.menus.options.OptionsMenu;
import flixel.input.gamepad.FlxGamepad;
import openfl.Lib;
import flixel.FlxG;

class KadeEngineData
{
	public static var kittyOptions:Map<String, Dynamic> = [];

    public static function initSave()
    {
		if (FlxG.save.data.downscroll == null)
			FlxG.save.data.downscroll = false;

		if (FlxG.save.data.dfjk == null)
			FlxG.save.data.dfjk = false;

		if (FlxG.save.data.accuracyDisplay == null)
			FlxG.save.data.accuracyDisplay = true;

		if (FlxG.save.data.offset == null)
			FlxG.save.data.offset = 0;

		if (FlxG.save.data.songPosition == null)
			FlxG.save.data.songPosition = false;

		if (FlxG.save.data.fps == null)
			FlxG.save.data.fps = false;

		if (FlxG.save.data.changedHit == null)
		{
			FlxG.save.data.changedHitX = -1;
			FlxG.save.data.changedHitY = -1;
			FlxG.save.data.changedHit = false;
		}

		if (FlxG.save.data.fpsRain == null)
			FlxG.save.data.fpsRain = false;

		if (FlxG.save.data.fpsCap == null)
			FlxG.save.data.fpsCap = 120;

		if (FlxG.save.data.fpsCap > 285 || FlxG.save.data.fpsCap < 60)
			FlxG.save.data.fpsCap = 120; // baby proof so you can't hard lock ur copy of kade engine

		if (FlxG.save.data.scrollSpeed == null)
			FlxG.save.data.scrollSpeed = 1;

		if (FlxG.save.data.npsDisplay == null)
			FlxG.save.data.npsDisplay = false;

		if (FlxG.save.data.frames == null)
			FlxG.save.data.frames = 10;

		if (FlxG.save.data.accuracyMod == null)
			FlxG.save.data.accuracyMod = 1;

		if (FlxG.save.data.watermark == null)
			FlxG.save.data.watermark = true;

		if (FlxG.save.data.distractions == null)
			FlxG.save.data.distractions = true;

		if (FlxG.save.data.flashing == null)
			FlxG.save.data.flashing = true;

		if (FlxG.save.data.resetButton == null)
			FlxG.save.data.resetButton = false;

		if (FlxG.save.data.botplay == null)
			FlxG.save.data.botplay = false;

		if (FlxG.save.data.cpuStrums == null)
			FlxG.save.data.cpuStrums = true;

		if (FlxG.save.data.iconColor == null)
			FlxG.save.data.iconColor = true;

		if (FlxG.save.data.strumline == null)
			FlxG.save.data.strumline = false;

		if (FlxG.save.data.customStrumLine == null)
			FlxG.save.data.customStrumLine = 0;

		if (FlxG.save.data.camzoom == null)
			FlxG.save.data.camzoom = true;

		if (FlxG.save.data.scoreScreen == null)
			FlxG.save.data.scoreScreen = true;

		if (FlxG.save.data.inputShow == null)
			FlxG.save.data.inputShow = false;

		if (FlxG.save.data.optimize == null)
			FlxG.save.data.optimize = false;

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		KeyBinds.gamepad = gamepad != null;

		Conductor.recalculateTimings();
		PlayerSettings.player1.controls.loadKeyBinds();
		KeyBinds.keyCheck();

		Main.watermarks = FlxG.save.data.watermark;

		(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);

		OptionsMenu.options = [
			new OptionCategory("Gameplay", [
				new DFJKOption(),
				new DownscrollOption("Change the layout of the strumline."),
				new SoftOption("ghost_tap", "Ghost Tapping", "Ghost Tapping is when you tap a direction and it doesn't give you a miss.", true, "bool"),
				new Judgement("Customize your Hit Timings (LEFT or RIGHT)"),
				new OffsetMenu("Callibrate your offset here."),
				#if desktop
				new FPSCapOption("Cap your FPS"),
				#end
				new ScrollSpeedOption("Change your scroll speed (1 = Chart dependent)"),
				new AccuracyDOption("Change how accuracy is calculated. (Accurate = Simple, Complex = Milisecond Based)"),
				new ResetButtonOption("Toggle pressing R to gameover."),
				new CustomizeGameplay("Drag'n'Drop Gameplay Modules around to your preference")
			]),
			new OptionCategory("Appearance", [
				new DistractionsAndEffectsOption("Toggle stage distractions that can hinder your gameplay."),
				new CamZoomOption("Toggle the camera zoom in-game."),
				#if desktop
				new RainbowFPSOption("Make the FPS Counter Rainbow"),
				#end
				new AccuracyOption("Display accuracy information."),
				new NPSDisplayOption("Shows your current Notes Per Second."),
				new SongPositionOption("Show the songs current position (as a bar)"),
				new CpuStrums("CPU's strumline lights up when a note hits it."),
				new IconColor("Make the Health Bar match the Icon's colors."),
			]),

			new OptionCategory("Misc", [
				#if desktop
				new FPSOption("Toggle the FPS Counter"),
				new ReplayOption("View replays"),
				#end
				new FlashingLightsOption("Toggle flashing lights that can cause epileptic seizures and strain."),
				new WatermarkOption("Enable and disable all watermarks from the engine."),
				new ScoreScreen("Show the score screen after the end of a song"),
				new ShowInput("Display every single input in the score screen."),
				new Optimization("No backgrounds, no characters, centered notes, no player 2."),
				new BotPlay("Showcase your charts and mods with autoplay."),
			]),
		];

		initKittyOptions();
	}

	public static function initKittyOptions() {
		// holy shit this thing questionable:sob:
		for (cat in OptionsMenu.options) {
			for (option in cat.getOptions()) {
				if (Type.getClass(option) != SoftOption)
					continue;
			
				var kittyOption:Dynamic = option;

				if (!kittyOptions.exists(kittyOption.id) && kittyOption.defaultValue != null)
					kittyOptions.set(kittyOption.id, kittyOption.defaultValue);
			}
		}

		if (FlxG.save.data.kittyOptions == null)
			FlxG.save.data.kittyOptions = kittyOptions;

		for (option in kittyOptions.keys()) { // this stupid but it work ig
			if (FlxG.save.data.kittyOptions.get(option) == null || !FlxG.save.data.kittyOptions.exists(option) || Type.typeof(FlxG.save.data.kittyOptions.get(option)) != Type.typeof(kittyOptions.get(option)))
				FlxG.save.data.kittyOptions.set(option, kittyOptions.get(option));
		}

		kittyOptions = FlxG.save.data.kittyOptions;
		trace(kittyOptions);
	}

	public static function saveKittyOption(optionID:String, value:Dynamic) {
		try {
			kittyOptions.set(optionID, value);
			FlxG.save.data.kittyOptions.set(optionID, value);
			FlxG.save.flush();
		} catch (e:Dynamic) {
			trace("Error saving option " + optionID + ": " + e + "\nTry Initializing First???");
		}
	}
}