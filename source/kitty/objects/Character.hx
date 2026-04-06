package kitty.objects;

import flixel.graphics.frames.FlxAtlasFrames;

class Character extends FlxSprite
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

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		var charJson:Dynamic = Paths.json('data/characters/' + character) == null ? Paths.json('data/characters/bf') : Paths.json('data/characters/'
		+ character);
		positionOffset = charJson.position;
		camPositionOffset = charJson.camera_position;
		iconName = charJson.healthicon;
		iconColor = FlxColor.fromRGB(charJson.healthbar_colors[0], charJson.healthbar_colors[1], charJson.healthbar_colors[2]);

		super(x + positionOffset[0], y + positionOffset[1]);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		frames = Paths.getSparrowAtlas(charJson.image);
		setGraphicSize(width * charJson.scale);
		flipX = charJson.flip_x;

		var charAnims:Array<Dynamic> = [];
		charAnims = charJson.animations;

		for (anim in charAnims) {
			if (anim.indices.length == 0 || anim.indices == null)
				animation.addByPrefix(anim.anim, anim.name, anim.fps, anim.loop);
			else
				animation.addByIndices(anim.anim, anim.name, anim.indices, "", anim.fps, anim.loop);
			addOffset(anim.anim, anim.offsets[0], anim.offsets[1]);
		}

		antialiasing = !charJson.no_antialiasing;

		dance();

		if (isPlayer)
		{
			flipX = !flipX;

			if (!curCharacter.startsWith('bf'))
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
	}

	override function update(elapsed:Float)
	{
		if (!isPlayer)
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 4;

			if (curCharacter == 'dad')
				dadVar = 6.1;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				dance();
				holdTimer = 0;
			}
		} else {
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}
			else
				holdTimer = 0;

			if (animation.curAnim.name.endsWith('miss') && animation.curAnim.finished && !debugMode)
			{
				playAnim('idle', true, false, 10);
			}

			if (animation.curAnim.name == 'firstDeath' && animation.curAnim.finished)
			{
				playAnim('deathLoop');
			}
		}

		switch (curCharacter)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance()
	{
		if (!debugMode)
		{
			if (animation.exists("danceLeft"))
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
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);

		if (curCharacter == 'gf')
		{
			if (AnimName == 'singLEFT')
			{
				danced = true;
			}
			else if (AnimName == 'singRIGHT')
			{
				danced = false;
			}

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
			{
				danced = !danced;
			}
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}
