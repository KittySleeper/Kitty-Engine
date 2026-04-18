var lights:FlxSprite;
var lightAbove:FlxSprite;

function create()
{
	stageDefaultCamZoom = 0.85;

	var solid:FlxSprite = new FlxSprite(-500, -1000);
	solid.makeGraphic(2400, 2000, 0xFF222026);
	solid.scrollFactor.set(0, 0);
	add(solid);

	var crowd:FlxSprite = new FlxSprite(682, 290);
	crowd.frames = Paths.getSparrowAtlas("stages/stageErect/crowd");
	crowd.animation.addByPrefix('idle', 'idle', 12, true);
	crowd.animation.play('idle');
	crowd.scrollFactor.set(0.8, 0.8);
	add(crowd);

	var brightLightSmall:FlxSprite = new FlxSprite(967, -103);
	brightLightSmall.loadGraphic(Paths.image('stages/stageErect/brightLightSmall'));
	brightLightSmall.scrollFactor.set(1.2, 1.2);
	add(brightLightSmall);

	var bg:FlxSprite = new FlxSprite(-765, -247);
	bg.loadGraphic(Paths.image('stages/stageErect/bg'));
	add(bg);

	var server:FlxSprite = new FlxSprite(-991, 205);
	server.loadGraphic(Paths.image('stages/stageErect/server'));
	add(server);

	var lightgreen:FlxSprite = new FlxSprite(-171, 242);
	lightgreen.loadGraphic(Paths.image('stages/stageErect/lightgreen'));
	add(lightgreen);

	var lightred:FlxSprite = new FlxSprite(-101, 560);
	lightred.loadGraphic(Paths.image('stages/stageErect/lightred'));
	add(lightred);

	var orangeLight:FlxSprite = new FlxSprite(189, -500);
	orangeLight.loadGraphic(Paths.image('stages/stageErect/orangeLight'));
	orangeLight.scale.set(1, 1700);
	orangeLight.updateHitbox();
	add(orangeLight);

	lights = new FlxSprite(-847, -245);
	lights.loadGraphic(Paths.image('stages/stageErect/lights'));
	lights.scrollFactor.set(1.2, 1.2);

	lightAbove = new FlxSprite(804, -117);
	lightAbove.loadGraphic(Paths.image('stages/stageErect/lightAbove'));
}

function postCreate()
{
	add(lights);
	add(lightAbove);

	dad.x -= 275;
	dad.camPositionOffset[0] += 75;
	dad.camPositionOffset[1] += 35;

	// var dadShader = new CustomShader("adjustColor");
	// // dadShader.data.brightness.value = [-33];
	// // dadShader.data.hue.value = [-32];
	// // dadShader.data.contrast.value = [-23];
	// // dadShader.data.saturation.value = [0];
	// dad.shader = dadShader;

	gf.x -= 250;
	gf.y += 35;

	boyfriend.x -= 15;
	boyfriend.y += 35;
	boyfriend.camPositionOffset[0] -= 85;
	boyfriend.camPositionOffset[1] -= 35;
}