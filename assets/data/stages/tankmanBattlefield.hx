import flixel.math.FlxAngle;

var watchtower:FlxSprite;
var clouds:FlxTiledSprite;
var tankRolling:FlxSprite;
var tankmanAudience:Array<FlxSprite> = [];

function create()
{
	stageDefaultCamZoom = 0.9;

	var solid:FlxSprite = new FlxSprite(-500, -1000);
	solid.makeGraphic(2400, 2000, 0xFFE3A26D);
	solid.scrollFactor.set(0, 0);
	add(solid);

	var tankSky:FlxSprite = new FlxSprite(-1000, -400);
	tankSky.loadGraphic(Paths.image('stages/tankmanBattlefield/tankSky'));
	tankSky.scale.set(3000, 1);
	tankSky.updateHitbox();
	tankSky.scrollFactor.set(0, 0);
	add(tankSky);

	var mountains:FlxSprite = new FlxSprite(-500, -35);
	mountains.loadGraphic(Paths.image('stages/tankmanBattlefield/mountains2'));
	mountains.scale.set(1.2, 1.2);
	mountains.updateHitbox();
	mountains.scrollFactor.set(0.2, 0.2);
	add(mountains);

	var buildings:FlxSprite = new FlxSprite(-260, -35);
	buildings.loadGraphic(Paths.image('stages/tankmanBattlefield/tankBuildings'));
	buildings.scale.set(1.1, 1.1);
	buildings.updateHitbox();
	buildings.scrollFactor.set(0.3, 0.3);
	add(buildings);

	var ruins:FlxSprite = new FlxSprite(-200, 150);
	ruins.loadGraphic(Paths.image('stages/tankmanBattlefield/cityruins2'));
	ruins.scale.set(1.1, 1.1);
	ruins.updateHitbox();
	ruins.scrollFactor.set(0.35, 0.35);
	add(ruins);

	var clouds2:FlxSprite = new FlxSprite(0, 0);
	clouds2.loadGraphic(Paths.image('stages/tankmanBattlefield/tankClouds'));
	clouds2.scale.set(1, 1);
	clouds2.updateHitbox();
	clouds2.scrollFactor.set(0.4, 0.4);
	clouds2.alpha = 0;
	add(clouds2);

	var smokeLeft:FlxSprite = new FlxSprite(-380, -40);
	smokeLeft.frames = Paths.getSparrowAtlas('stages/tankmanBattlefield/smokeLeft');
	smokeLeft.animation.addByPrefix('smokeLeft', 'SmokeBlurLeft', 24, true);
	smokeLeft.animation.play('smokeLeft');
	smokeLeft.scale.set(1, 1);
	smokeLeft.updateHitbox();
	smokeLeft.scrollFactor.set(0.4, 0.4);
	add(smokeLeft);

	var smokeRight:FlxSprite = new FlxSprite(1050, -35);
	smokeRight.frames = Paths.getSparrowAtlas('stages/tankmanBattlefield/smokeRight');
	smokeRight.animation.addByPrefix('smokeRight', 'SmokeRight', 24, true);
	smokeRight.animation.play('smokeRight');
	smokeRight.scale.set(1, 1);
	smokeRight.updateHitbox();
	smokeRight.scrollFactor.set(0.4, 0.4);
	add(smokeRight);

	clouds = new FlxTiledSprite(Paths.image('stages/tankmanBattlefield/tankClouds'), 3200, 235, true, false);
	clouds.setPosition(-1100, 20);
	clouds.scrollFactor.set(0.25, 0.25);
	clouds.velocity.x = 8;
	add(clouds);

	watchtower = new FlxSprite(-35, 110);
	watchtower.frames = Paths.getSparrowAtlas('stages/tankmanBattlefield/tankWatchtower');
	watchtower.animation.addByPrefix('idle', 'watchtower gradient color', 24, false);
	watchtower.animation.play('idle');
	watchtower.scale.set(0.85, 0.85);
	watchtower.updateHitbox();
	watchtower.scrollFactor.set(0.5, 0.5);
	add(watchtower);

	tankRolling = new FlxSprite(300, 300);
	tankRolling.frames = Paths.getSparrowAtlas('stages/tankmanBattlefield/tankRolling');
	tankRolling.animation.addByPrefix('roll', 'BG tank w lighting', 24, true);
	tankRolling.animation.play('roll');
	tankRolling.scale.set(1, 1);
	tankRolling.updateHitbox();
	tankRolling.scrollFactor.set(0.5, 0.5);
	add(tankRolling);

	var tankGround:FlxSprite = new FlxSprite(-420, -150);
	tankGround.loadGraphic(Paths.image('stages/tankmanBattlefield/tankGround'));
	tankGround.scale.set(1.15, 1.15);
	tankGround.updateHitbox();
	tankGround.scrollFactor.set(1, 1);
	add(tankGround);
}

function postCreate()
{
	var tankBricks = new FlxSprite(438, 715);
	tankBricks.loadGraphic(Paths.image('stages/tankmanBattlefield/bricksGround'));
	tankBricks.scale.set(1.15, 1.15);
	tankBricks.updateHitbox();
	tankBricks.scrollFactor.set(1, 1);
	insert(members.indexOf(gf) + 1, tankBricks);

	var tankmanAudience0:FlxSprite = new FlxSprite(-500, 650);
	tankmanAudience0.frames = Paths.getSparrowAtlas('stages/tankmanBattlefield/tank0');
	tankmanAudience0.animation.addByPrefix('idle', 'fg tankhead far right', 24, false);
	tankmanAudience0.animation.play('idle');
	tankmanAudience0.scale.set(1, 1);
	tankmanAudience0.updateHitbox();
	tankmanAudience0.scrollFactor.set(1.7, 1.5);
	add(tankmanAudience0);
	tankmanAudience.push(tankmanAudience0);

	var tankmanAudience1:FlxSprite = new FlxSprite(-300, 750);
	tankmanAudience1.frames = Paths.getSparrowAtlas('stages/tankmanBattlefield/tank1');
	tankmanAudience1.animation.addByPrefix('idle', 'fg tankhead 5', 24, false);
	tankmanAudience1.animation.play('idle');
	tankmanAudience1.scale.set(1, 1);
	tankmanAudience1.updateHitbox();
	tankmanAudience1.scrollFactor.set(2.0, 0.2);
	add(tankmanAudience1);
	tankmanAudience.push(tankmanAudience1);

	var tankmanAudience2:FlxSprite = new FlxSprite(360, 980);
	tankmanAudience2.frames = Paths.getSparrowAtlas('stages/tankmanBattlefield/tank2');
	tankmanAudience2.animation.addByPrefix('idle', 'foreground man 3', 24, false);
	tankmanAudience2.animation.play('idle');
	tankmanAudience2.scale.set(1, 1);
	tankmanAudience2.updateHitbox();
	tankmanAudience2.scrollFactor.set(1.5, 1.5);
	add(tankmanAudience2);
	tankmanAudience.push(tankmanAudience2);

	var tankmanAudience3:FlxSprite = new FlxSprite(1050, 1240);
	tankmanAudience3.frames = Paths.getSparrowAtlas('stages/tankmanBattlefield/tank3');
	tankmanAudience3.animation.addByPrefix('idle', 'fg tankhead 4', 24, false);
	tankmanAudience3.animation.play('idle');
	tankmanAudience3.scale.set(1, 1);
	tankmanAudience3.updateHitbox();
	tankmanAudience3.scrollFactor.set(3.5, 2.5);
	add(tankmanAudience3);
	tankmanAudience.push(tankmanAudience3);

	var tankmanAudience4:FlxSprite = new FlxSprite(1200, 900);
	tankmanAudience4.frames = Paths.getSparrowAtlas('stages/tankmanBattlefield/tank4');
	tankmanAudience4.animation.addByPrefix('idle', 'fg tankman bobbin 3', 24, false);
	tankmanAudience4.animation.play('idle');
	tankmanAudience4.scale.set(1, 1);
	tankmanAudience4.updateHitbox();
	tankmanAudience4.scrollFactor.set(1.5, 1.5);
	add(tankmanAudience4);
	tankmanAudience.push(tankmanAudience4);

	var tankmanAudience5:FlxSprite = new FlxSprite(1550, 700);
	tankmanAudience5.frames = Paths.getSparrowAtlas('stages/tankmanBattlefield/tank5');
	tankmanAudience5.animation.addByPrefix('idle', 'fg tankhead far right', 24, false);
	tankmanAudience5.animation.play('idle');
	tankmanAudience5.scale.set(1, 1);
	tankmanAudience5.updateHitbox();
	tankmanAudience5.scrollFactor.set(1.5, 1.5);
	add(tankmanAudience5);
	tankmanAudience.push(tankmanAudience5);

	gf.x -= 200;
	gf.y -= 60;

	dad.x -= 85;
	dad.y -= 15;

	boyfriend.x += 100;
	boyfriend.camPositionOffset[0] -= 85;
}

function update(elapsed)
{
	moveTank(elapsed);
}

var tankMoving:Bool = false;
var tankAngle:Float = FlxG.random.int(-90, 45);
var tankSpeed:Float = FlxG.random.float(5, 7);
var tankX:Float = 400;

function moveTank(elapsed:Float):Void
{
	var daAngleOffset:Float = 1;
	tankAngle += elapsed * tankSpeed;

	tankRolling.angle = tankAngle - 90 + 15;
	tankRolling.x = tankX + Math.cos(FlxAngle.asRadians((tankAngle * daAngleOffset) + 180)) * 1500;
	tankRolling.y = 1300 + Math.sin(FlxAngle.asRadians((tankAngle * daAngleOffset) + 180)) * 1100;
}

function beatHit()
{
	for (tankman in tankmanAudience)
		tankman.animation.play("idle");

	watchtower.animation.play("idle");
}