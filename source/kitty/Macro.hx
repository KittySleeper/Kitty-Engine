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
		Compiler.addMetadata('@:build($classPath.rebuildBitmapData())', 'openfl.display.BitmapData');
		Compiler.include('kitty', true, ['*Macro']);
		Compiler.include('haxe', true, ['haxe.atomic.*', 'haxe.macro.*']);
		Compiler.include('flixel', true, ['flixel.addons.editors.spine.*', 'flixel.addons.nape.*', 'flixel.system.macros.*', 'flixel.addons.tile.FlxRayCastTilemap', 'flixel.addons.weapon.*']);
		Compiler.include('moonchart', true, ['moonchart.backend.*']);
	}

	// fix for pixel font related shenanigans
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

	// fix for GPU rendering related shenanigans
	public static macro function rebuildBitmapData():Array<Field> {
		var classFields = Context.getBuildFields();
		var tempClass = macro class TempClass {
			/**
			 * If true, the bitmap data will render to your GPU.
			 * NOTE: ISN'T WORKING RIGHT FOR SOME REASON, ALSO DON'T SET IT TO TRUE HERE, IT CRASHES
			 */
			public var renderToGPU:Bool = false;
		}

		var fromImageFunc = classFields.filter(field -> return field.name == '__fromImage')[0];
		switch (fromImageFunc.kind) {
			case FFun(f):
				var initExpr:Expr = f.expr;
				f.expr = macro {
					if (!renderToGPU) {
						$initExpr;
						return;
					}
					if (image != null && image.buffer != null) {
						this.image = image;

						width = image.width;
						height = image.height;
						rect = new Rectangle(0, 0, image.width, image.height);

						__textureWidth = width;
						__textureHeight = height;

						#if sys
						image.format = BGRA32;
						image.premultiplied = true;
						#end

						readable = true;
						__isValid = true;

						// https://github.com/CodenameCrew/CodenameEngine/blob/main/source/funkin/backend/system/OptimizedBitmapData.hx#L9L46
						if (flixel.FlxG.stage.context3D != null) {
							lock();
							getTexture(flixel.FlxG.stage.context3D);
							getSurface();
							readable = true;
							this.image = null;
						}
					}
				}
				fromImageFunc.kind = FFun(f);
			default:
		}
		var getSurfaceFunc = classFields.filter(field -> return field.name == 'getSurface')[0];
		switch (getSurfaceFunc.kind) {
			case FFun(f):
				var initExpr:Expr = f.expr;
				f.expr = macro {
					// https://github.com/CodenameCrew/CodenameEngine/blob/main/source/funkin/backend/system/OptimizedBitmapData.hx#L48L61
					if (renderToGPU)
						return __surface ??= CairoImageSurface.fromImage(image);
					$initExpr;
				}
				getSurfaceFunc.kind = FFun(f);
			default:
		}

		return classFields.concat(tempClass.fields);
	}
}
#end