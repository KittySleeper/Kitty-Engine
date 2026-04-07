package kitty.backend;

import flixel.math.FlxMath;
import lime.utils.Assets;

class CoolUtil
{
	public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = Paths.txt(path).trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}

	public static function coolStringFile(path:String):Array<String>
		{
			var daList:Array<String> = path.trim().split('\n');

			for (i in 0...daList.length)
			{
				daList[i] = daList[i].trim();
			}

			return daList;
		}

	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max)
		{
			dumbArray.push(i);
		}
		return dumbArray;
	}

	public static function toTitleCase(input:String):String {
		var re = ~/(\b\w)/g;
		return re.map(input.toLowerCase(), r -> r.matched(0).toUpperCase());
	}

	/**
	 * Gets the FlxEase from a string.
	 * @param mainEase Main ease
	 * @param suffix Suffix (Ignored if `mainEase` is `linear`)
	 * Taken From https://github.com/CodenameCrew/CodenameEngine/blob/cd7c9f1afce8a938f7ea7962dafbcca6e2221e78/source/funkin/backend/utils/CoolUtil.hx#L968
	 */
	@:noUsing public static inline function flxeaseFromString(mainEase:String, ?suffix:String)
		return Reflect.field(FlxEase, mainEase + (mainEase == "linear" || suffix == null ? "" : suffix));
}
