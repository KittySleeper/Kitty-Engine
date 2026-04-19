package kitty.objects;

import kitty.backend.modding.scripting.HScript;
import animate.FlxAnimate;

class Character extends FlxAnimate
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;

	public var positionOffset:Array<Float> = [];
	public var camPositionOffset:Array<Float> = [];

	public var iconName:String = "";

	public var iconColor:FlxColor = FlxColor.GRAY;

	public var singDuration:Float = 4;

	public var specialAnimation:Bool = false; // basically makes it so no animations can play until whatever current animation is done
	public var singAnimations:Array<String> = ["singLEFT", "singDOWN", "singUP", "singRIGHT"];

	public var sheetType:String = "sparrow";

	public var script:HScript;
	public var danceCallback:Void->Void = null;

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		script = new HScript('data/characters/' + character);
		if (!script.isBlank && script.expr != null)
		{
			script.interp.scriptObject = this;
			script.setValue('add', FlxG.state.add);
			script.setValue('remove', FlxG.state.remove);
			script.interp.execute(script.expr);
		}

		script.callFunction("create");

		var charJson:Dynamic = Paths.json('data/characters/' + character) == null ? Paths.json('data/characters/bf') : Paths.json('data/characters/'
			+ character);
		positionOffset = charJson.position;
		camPositionOffset = charJson.camera_position;
		iconName = charJson.healthicon;
		iconColor = FlxColor.fromRGB(charJson.healthbar_colors[0], charJson.healthbar_colors[1], charJson.healthbar_colors[2]);
		sheetType = charJson.sheetType == null ? "sparrow" : charJson.sheetType;

		super(x + positionOffset[0], y + positionOffset[1]);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		frames = sheetType == "atlas" ? Paths.getAnimateAtlas(charJson.image) : Paths.getSparrowAtlas(charJson.image);
		setGraphicSize(width * charJson.scale);
		flipX = charJson.flip_x;

		var charAnims:Array<Dynamic> = [];
		charAnims = charJson.animations;

		for (anim in charAnims)
		{
			if (sheetType == "atlas")
			{
				if (anim.indices == null || anim.indices.length == 0)
					this.anim.addBySymbol(anim.anim, anim.name, anim.fps, anim.loop);
				else
					this.anim.addBySymbolIndices(anim.anim, anim.name, anim.indices, anim.fps, anim.loop);
			}
			else
			{
				if (anim.indices == null || anim.indices.length == 0)
					animation.addByPrefix(anim.anim, anim.name, anim.fps, anim.loop);
				else
					animation.addByIndices(anim.anim, anim.name, anim.indices, "", anim.fps, anim.loop);
			}

			addOffset(anim.anim, anim.offsets[0], anim.offsets[1]);
		}

		antialiasing = !charJson.no_antialiasing;
		singDuration = charJson.sing_duration;

		danceCallback = dance;
		danceCallback();

		if (isPlayer)
		{
			flipX = !flipX;

			if (animation != null && !curCharacter.startsWith('bf'))
			{
				// var animArray
				var oldRight = animation.getByName("singRIGHT").frames;
				var oldRightOffset = animOffsets.get("singRIGHT");
				animation.getByName("singRIGHT").frames = animation.getByName("singLEFT").frames;
				animOffsets.set("singRIGHT", animOffsets.get("singLEFT"));
				animation.getByName('singLEFT').frames = oldRight;
				animOffsets.set("singLEFT", oldRightOffset);

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName("singRIGHTmiss").frames;
					var oldMissOffset = animOffsets.get("singRIGHTmiss");
					animation.getByName("singRIGHTmiss").frames = animation.getByName("singLEFTmiss").frames;
					animOffsets.set("singRIGHTmiss", animOffsets.get("singLEFTmiss"));
					animation.getByName('singLEFTmiss').frames = oldMiss;
					animOffsets.set("singLEFTmiss", oldMissOffset);
				}
			}
		}

		script.callFunction("postCreate");
	}

	override function update(elapsed:Float)
	{
		script.callFunction("update", [elapsed]);

		if (specialAnimation && animation != null && animation.curAnim != null && animation.curAnim.finished)
			specialAnimation = false;

		if (animation != null && animation.curAnim != null && animation.curAnim.name.startsWith('sing'))
		{
			holdTimer += elapsed;
		}

		if (holdTimer >= Conductor.stepCrochet * singDuration * 0.001)
		{
			danceCallback();
			holdTimer = 0;
		}

		if (isPlayer)
		{
			if (animation != null && animation.curAnim != null && animation.curAnim.name.endsWith('miss') && animation.curAnim.finished && !debugMode)
			{
				playAnim('idle', true, false, 10);
			}

			if (animation != null && animation.curAnim != null && animation.curAnim.name == 'firstDeath' && animation.curAnim.finished)
			{
				playAnim('deathLoop');
			}
		}

		super.update(elapsed);

		script.callFunction("postUpdate", [elapsed]);
	}

	private var danced:Bool = false;

	public function dance()
	{
		script.callFunction("dance");

		if (!debugMode)
		{
			if (animation != null && animation.exists("danceLeft"))
			{
				danced = !danced;

				if (danced)
					playAnim('danceRight');
				else
					playAnim('danceLeft');
			}
			else
			{
				playAnim('idle');
			}
		}

		script.callFunction("postDance");
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		if (specialAnimation || animation == null || !animation.exists(AnimName))
			return;

		script.callFunction("playAnim", [AnimName, Force, Reversed, Frame]);

		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		offset.set(daOffset[0], daOffset[1]);

		script.callFunction("postPlayAnim", [AnimName, Force, Reversed, Frame]);
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}
