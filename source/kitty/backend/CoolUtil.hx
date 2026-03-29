package kitty.backend;

import flixel.FlxG;
import flixel.math.FlxMath;
import lime.utils.Assets;

using StringTools;

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
}
