package kitty.backend;

import flixel.graphics.FlxGraphic;
import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import haxe.Json;
import openfl.media.Sound;
import openfl.display.BitmapData;
import sys.io.File;
import sys.FileSystem;

class Paths
{
	static var epicCacheFromOhio:Map<String, Dynamic> = [];

	inline public static var SOUND_EXT:String = #if web "mp3" #else "ogg" #end;
	public static var ASSETS_PATH:Array<String> = ["assets"];

	inline static public function sound(key:String)
	{
		if (epicCacheFromOhio.exists('sounds/$key.$SOUND_EXT'))
		{
			return epicCacheFromOhio.get('sounds/$key.$SOUND_EXT');
		}
		else
		{
			var epicSound:Sound = Sound.fromFile(rawFile('sounds/$key.$SOUND_EXT'));
			epicCacheFromOhio.set('sounds/$key.$SOUND_EXT', epicSound);
			return epicSound;
		}
	}

	inline static public function soundRandom(key:String, min:Int, max:Int)
		return sound('$key${FlxG.random.int(min, max)}');

	inline static public function music(key:String)
	{
		if (epicCacheFromOhio.exists('music/$key.$SOUND_EXT'))
		{
			return epicCacheFromOhio.get('music/$key.$SOUND_EXT');
		}
		else
		{
			var epicMusic:Sound = Sound.fromFile(rawFile('music/$key.$SOUND_EXT'));
			epicCacheFromOhio.set('music/$key.$SOUND_EXT', epicMusic);
			return epicMusic;
		}
	}

	inline static public function inst(key:String, variant:String)
	{
		var songLowercase = StringTools.replace(key, " ", "-").toLowerCase();

		if (exists('songs/$songLowercase/Inst-${variant.toLowerCase()}.$SOUND_EXT'))
			variant = "-" + variant.toLowerCase();
		else
			variant = "";

		if (epicCacheFromOhio.exists('songs/$songLowercase/Inst$variant.$SOUND_EXT'))
		{
			return epicCacheFromOhio.get('songs/$songLowercase/Inst$variant.$SOUND_EXT');
		}
		else
		{
			var epicInst:Sound = Sound.fromFile(rawFile('songs/$songLowercase/Inst$variant.$SOUND_EXT'));
			epicCacheFromOhio.set('songs/$songLowercase/Inst$variant.$SOUND_EXT', epicInst);
			return epicInst;
		}
	}

	inline static public function voices(key:String, character:String, variant:String)
	{
		var songLowercase = StringTools.replace(key, " ", "-").toLowerCase();
		if (character != null && character != "")
			character = "-" + character.toLowerCase();
		else
			character = "";

		if (exists('songs/$songLowercase/Voices$character-${variant.toLowerCase()}.$SOUND_EXT'))
			variant = "-" + variant.toLowerCase();
		else
			variant = "";

		if (epicCacheFromOhio.exists('songs/$songLowercase/Voices$character$variant.$SOUND_EXT'))
		{
			return epicCacheFromOhio.get('songs/$songLowercase/Voices$character$variant.$SOUND_EXT');
		}
		else
		{
			var epicVoices:Sound = Sound.fromFile(rawFile('songs/$songLowercase/Voices$character$variant.$SOUND_EXT'));
			epicCacheFromOhio.set('songs/$songLowercase/Voices$character$variant.$SOUND_EXT', epicVoices);
			return epicVoices;
		}
	}

	inline static public function image(key:String)
	{
		if (epicCacheFromOhio.exists('images/$key.png'))
		{
			return FlxGraphic.fromGraphic(epicCacheFromOhio.get('images/$key.png'));
		}
		else
		{
			var epicImage:FlxGraphic = FlxGraphic.fromBitmapData(BitmapData.fromFile(rawFile('images/$key.png'))); //, true, null, false
			epicCacheFromOhio.set('images/$key.png', epicImage);
			epicImage.persist = true;
			return epicImage;
		}
	}

	inline static public function getSparrowAtlas(key:String)
		return FlxAtlasFrames.fromSparrow(image(key), xml('images/$key'));

	inline static public function getPackerAtlas(key:String)
		return FlxAtlasFrames.fromSpriteSheetPacker(image(key), fileData('images/$key.txt'));

	inline static public function xml(key:String)
		return fileData('$key.xml');

	inline static public function txt(key:String)
		return fileData('$key.txt');

	inline static public function json(key:String)
		return Json.parse(fileData('$key.json'));

	inline static public function lua(key:String)
		return fileData('$key.lua');

	inline static public function hx(key:String)
		return fileData('$key.hx');

	inline static public function font(key:String)
		return rawFile('fonts/$key');

	inline static public function fileData(key:String)
		return Paths.exists(key) ? File.getContent(rawFile(key)) : null;

	static public function exists(key:String):Bool
	{
		#if sys
		for (path in ASSETS_PATH)
		{
			if (FileSystem.exists('$path/$key'))
				return true;
		}
		return false;
		#else
		return true;
		#end
	}

	static public function rawFile(key:String):String
	{
		for (path in ASSETS_PATH)
		{
			#if sys
			if (FileSystem.exists('$path/$key'))
				return '$path/$key';
			#end
		}

		return 'assets/$key';
	}

	static public function readDirectory(key:String):Array<String>
	{
		#if sys
		for (path in ASSETS_PATH)
			if (FileSystem.exists('$path/$key'))
				return FileSystem.readDirectory('$path/$key');

		return [];
		#else
		return [];
		#end
	}

	inline static public function dumpCache():Void
	{
		for (key => value in epicCacheFromOhio)
		{
			if (Std.isOfType(value, BitmapData))
			{
				cast(value, BitmapData).dispose();
			}

			if (Std.isOfType(value, FlxGraphic))
			{
				// cast(value, FlxGraphic).dump();
				cast(value, FlxGraphic).destroy();
			}

			if (Std.isOfType(value, FlxAtlasFrames))
			{
				cast(value, FlxAtlasFrames).destroy();
			}
		}
		epicCacheFromOhio.clear();

		#if cpp
		cpp.vm.Gc.run(true);
		#end
	}
}
