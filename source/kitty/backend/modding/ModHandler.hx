package kitty.backend.modding;

import openfl.display.BitmapData;
import flixel.graphics.FlxGraphic;
import sys.FileSystem;
import sys.io.File;
import haxe.Json;
import kitty.backend.modding.scripting.ModState;
import kitty.backend.modding.scripting.HScript;

typedef ModMeta =
{
	modName:String,
	modVersion:String,
	modMetaVersion:String,
	stateOverrides:Array<StateOverride>
};

typedef StateOverride =
{
	state:String,
	stateOverride:String
};

class ModHandler
{
	/**
	 * Metadata For The Current Mod
	 */
	public static var modMeta:ModMeta;

	/**
	 * The Current Mod Meta Data Version, If A Mod Is Out Of Date From This It Will Have A Lil Warning Saying It Might Be Unstable/Wont Work
	 */
	public static var modMetaVersion:String = "1.0.0";

	/**
	 * Initializes Things For Modding, Such As Scripting Stuff, And More
	 */
	public static function initialize()
	{
		if (FlxG.save.data.modSelected == null)
			FlxG.save.data.modSelected = "Base Game";

		Paths.ASSETS_PATH = ["mods/" + FlxG.save.data.modSelected, "assets"];
		modMeta = Paths.json("metadata");

		if (HScript.parser == null)
		{
			HScript.parser = new hscript.Parser();
			HScript.parser.allowJSON = true;
			HScript.parser.allowMetadata = true;
			HScript.parser.allowTypes = true;
			HScript.parser.preprocesorValues = [
				"desktop" => #if (desktop) true #else false #end,
				"windows" => #if (windows) true #else false #end,
				"mac" => #if (mac) true #else false #end,
				"linux" => #if (linux) true #else false #end,
				"debugBuild" => #if (debug) true #else false #end
			];
		}

		FlxG.signals.preStateSwitch.removeAll();

		FlxG.signals.preStateSwitch.add(() ->
		{
			if (Main.dumpNextState)
				Paths.dumpCache();
			else
				Main.dumpNextState = true;

			if (modMeta.stateOverrides != null)
			{
				var game:flixel.FlxGame = cast FlxG.game;
				var nextStateFunc:Dynamic = Reflect.field(game, "_nextState");

				if (nextStateFunc != null)
				{
					var nextStateInstance:Dynamic = nextStateFunc();
					var className = Type.getClassName(Type.getClass(nextStateInstance));

					for (state in modMeta.stateOverrides)
					{
						if (state.state == className)
						{
							Reflect.setField(game, "_nextState", () -> new ModState(state.stateOverride));
							break;
						}
					}
				}
			}
		});
	}

	public static function getModMeta(mod:String):ModMeta
	{
		return FileSystem.exists('./mods/$mod/metadata.json') ? Json.parse(File.getContent('mods/$mod/metadata.json')) : {
			modName: mod,
			modVersion: "Unknown",
			modMetaVersion: "Unknown",
			stateOverrides: []
		};
	}

	public static function getModIcon(mod:String):FlxGraphic
	{
		if (!FileSystem.exists('./mods/$mod/modIcon.png'))
		{
			return Paths.image('week54prototype');
		}
		else
		{
			if (Paths.epicCacheFromOhio.exists('mods/$mod/modIcon.png'))
			{
				return FlxGraphic.fromGraphic(Paths.epicCacheFromOhio.get('mods/$mod/modIcon.png'));
			}
			else
			{                
				var epicImage:FlxGraphic = FlxGraphic.fromBitmapData(BitmapData.fromFile('mods/$mod/modIcon.png'), true, null, false); // , true, null, false
				Paths.epicCacheFromOhio.set('mods/$mod/modIcon.png', epicImage);
				epicImage.persist = true;
				return epicImage;
			}
		}
	}
}