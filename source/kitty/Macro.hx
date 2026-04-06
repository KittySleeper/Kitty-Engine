package kitty;

#if macro
import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr;

using StringTools;
using haxe.macro.ExprTools;

class Macro {
	public static function init():Void {
		var classPath:String = Std.string(Macro).replace('Class<', '').replace('>', '');
		Compiler.addMetadata('@:build($classPath.rebuildFlxText())', 'flixel.text.FlxText');
		Compiler.include('kitty', true, ['*Macro']);
		Compiler.include('haxe', true, ['haxe.atomic.*', 'haxe.macro.*']);
		Compiler.include('flixel', true, ['flixel.addons.editors.spine.*', 'flixel.addons.nape.*', 'flixel.system.macros.*', 'flixel.addons.tile.FlxRayCastTilemap', 'flixel.addons.weapon.*']);
		Compiler.include('moonchart', true, ['moonchart.backend.*']);
	}

	public static macro function rebuildFlxText():Array<Field> {
		var classFields = Context.getBuildFields();
		var tempClass = macro class TempClass {
			/**
			 * If true, the text will be rendered with pixel-perfect sharpness.
			 */
			public var pixelFont(default, set):Bool;
			function set_pixelFont(value:Bool):Bool {
				if (value) {
					textField.antiAliasType = ADVANCED;
					textField.sharpness = 400;
				} else {
					textField.antiAliasType = NORMAL;
					textField.sharpness = 100;
				}
				return pixelFont = value;
			}
		}

		var newConstructor = classFields.filter(field -> return field.name == 'new')[0];
		switch (newConstructor.kind) {
			case FFun(f):
				var initExpr:Expr = f.expr;
				f.expr = macro {
					$initExpr;
					set_pixelFont(false);
				}
				newConstructor.kind = FFun(f);
			default:
		}
		classFields.remove(classFields.filter(field -> return field.name == 'set_antialiasing')[0]);

		return classFields.concat(tempClass.fields);
	}
}
#end