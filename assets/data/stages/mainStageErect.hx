function create() {
    defaultCamZoom = 0.85;

    var solid:FlxSprite = new FlxSprite(-500, -1000);
    solid.makeGraphic(2400, 2000, 0xFF222026);
    solid.scrollFactor.set(0, 0);
    solid.active = false;
    add(solid);

    var crowd:FlxSprite = new FlxSprite(682, 290);
    crowd.frames = Paths.getSparrowAtlas('stages/stageErect/crowd');
    crowd.animation.addByPrefix('idle', 'idle0', 12, true);
    crowd.animation.play('idle');
    crowd.antialiasing = true;
    crowd.scrollFactor.set(0.8, 0.8);
    crowd.active = false;
    add(crowd);

    var brightLightSmall:FlxSprite = new FlxSprite(967, -103);
    brightLightSmall.loadGraphic(Paths.image('stages/stageErect/brightLightSmall'));
    brightLightSmall.antialiasing = true;
    brightLightSmall.scrollFactor.set(1.2, 1.2);
    brightLightSmall.alpha = 1;
    brightLightSmall.active = false;
    add(brightLightSmall);

    var bg:FlxSprite = new FlxSprite(-765, -247);
    bg.loadGraphic(Paths.image('stages/stageErect/bg'));
    bg.antialiasing = true;
    bg.scrollFactor.set(1, 1);
    bg.active = false;
    add(bg);

    var server:FlxSprite = new FlxSprite(-991, 205);
    server.loadGraphic(Paths.image('stages/stageErect/server'));
    server.antialiasing = true;
    server.scrollFactor.set(1, 1);
    server.active = false;
    add(server);

    var lightgreen:FlxSprite = new FlxSprite(-171, 242);
    lightgreen.loadGraphic(Paths.image('stages/stageErect/lightgreen'));
    lightgreen.antialiasing = true;
    lightgreen.scrollFactor.set(1, 1);
    lightgreen.alpha = 1;
    lightgreen.active = false;
    add(lightgreen);

    var lightred:FlxSprite = new FlxSprite(-101, 560);
    lightred.loadGraphic(Paths.image('stages/stageErect/lightred'));
    lightred.antialiasing = true;
    lightred.scrollFactor.set(1, 1);
    lightred.alpha = 1;
    lightred.active = false;
    add(lightred);

    var orangeLight:FlxSprite = new FlxSprite(189, -500);
    orangeLight.loadGraphic(Paths.image('stages/stageErect/orangeLight'));
    orangeLight.scale.set(1, 1700);
    orangeLight.updateHitbox();
    orangeLight.antialiasing = true;
    orangeLight.scrollFactor.set(1, 1);
    orangeLight.alpha = 1;
    orangeLight.active = false;
    add(orangeLight);

    var lights:FlxSprite = new FlxSprite(-847, -245);
    lights.loadGraphic(Paths.image('stages/stageErect/lights'));
    lights.antialiasing = true;
    lights.scrollFactor.set(1.2, 1.2);
    lights.active = false;
    add(lights);

    var lightAbove:FlxSprite = new FlxSprite(804, -117);
    lightAbove.loadGraphic(Paths.image('stages/stageErect/lightAbove'));
    lightAbove.antialiasing = true;
    lightAbove.scrollFactor.set(1, 1);
    lightAbove.alpha = 1;
    lightAbove.active = false;
    add(lightAbove);
}

function postCreate() {
    boyfriend.x += 977.5;
    boyfriend.y += 905;
    boyfriend.camPositionOffset[0] += -170;
    boyfriend.camPositionOffset[1] += -140;

    dad.x += 40;
    dad.y += 885;
    dad.camPositionOffset[0] += 270;
    dad.camPositionOffset[1] += -100;

    gf.x += 501.5;
    gf.y += 815;
}