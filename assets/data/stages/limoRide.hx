var grpLimoDancers:Array<FlxSprite> = [];
var limo:FlxSprite;
var fastCar:FlxSprite;

var fastCarCanDrive:Bool = true;

function create() {
    defaultCamZoom = 0.90;

    var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('stages/limo/limoSunset'));
    skyBG.scrollFactor.set(0.1, 0.1);
    add(skyBG);

    var bgLimo:FlxSprite = new FlxSprite(-200, 480);
    bgLimo.frames = Paths.getSparrowAtlas('stages/limo/bgLimo');
    bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
    bgLimo.animation.play('drive');
    bgLimo.scrollFactor.set(0.4, 0.4);
    add(bgLimo);

    if (FlxG.save.data.distractions)
    {
        for (i in 0...5)
        {
            var dancer:FlxSprite = new FlxSprite((370 * i) + 130, bgLimo.y - 400);
            dancer.frames = Paths.getSparrowAtlas("stages/limo/limoDancer");
            dancer.animation.addByIndices('danceLeft', 'bg dancer sketch PINK', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
            dancer.animation.addByIndices('danceRight', 'bg dancer sketch PINK', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
            dancer.animation.play('danceLeft');
            dancer.scrollFactor.set(0.4, 0.4);
            dancer.antialiasing = true;
            grpLimoDancers.push(dancer);
            add(dancer);
        }
    }

    limo = new FlxSprite(-120, 550);
    limo.frames = Paths.getSparrowAtlas('stages/limo/limoDrive');
    limo.animation.addByPrefix('drive', "Limo stage", 24);
    limo.animation.play('drive');
    limo.antialiasing = true;
    add(limo);

    fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('stages/limo/fastCarLol'));
    add(fastCar);
}

function postCreate() {
    boyfriend.y -= 220;
	boyfriend.x += 260;
    boyfriend.camPositionOffset[0] -= 250;

    remove(gf);
    insert(PlayState.instance.members.indexOf(limo), gf);

    if (FlxG.save.data.distractions)
        resetFastCar();
}

var danceDir:Bool = false;

function beatHit() {
    danceDir = !danceDir;

    for (dancer in grpLimoDancers)
        dancer.animation.play('dance' + (danceDir ? "Right" : "Left"), true);

    if (FlxG.random.bool(10) && fastCarCanDrive)
        fastCarDrive();
}

function resetFastCar():Void
{
    if (FlxG.save.data.distractions)
    {
        fastCar.x = -12600;
        fastCar.y = FlxG.random.int(140, 250);
        fastCar.velocity.x = 0;
        fastCarCanDrive = true;
    }
}

function fastCarDrive()
{
    if (FlxG.save.data.distractions)
    {
        FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

        fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
        fastCarCanDrive = false;
        new FlxTimer().start(2, function(tmr:FlxTimer)
        {
            resetFastCar();
        });
    }
}