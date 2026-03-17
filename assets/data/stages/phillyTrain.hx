var light:FlxSprite;
var phillyTrain:FlxSprite;
var trainSound:FlxSound;

var curLight:Int = 0;
var lightColors:Array<Int> = [
    0xFF31A2FD,
    0xFF31FD8C,
    0xFFFB33F5,
    0xFFFBA633,
    0xFFFD4531
];

var trainMoving:Bool = false;
var trainFrameTiming:Float = 0;

var trainCars:Int = 8;
var trainFinishing:Bool = false;
var trainCooldown:Int = 0;

function create() {
    var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('stages/philly/sky'));
    bg.scrollFactor.set(0.1, 0.1);
    add(bg);

    var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('stages/philly/city'));
    city.scrollFactor.set(0.3, 0.3);
    city.setGraphicSize(Std.int(city.width * 0.85));
    city.updateHitbox();
    add(city);

    light = new FlxSprite(city.x).loadGraphic(Paths.image('stages/philly/win'));
    light.scrollFactor.set(0.3, 0.3);
    light.setGraphicSize(Std.int(light.width * 0.85));
    light.updateHitbox();
    light.antialiasing = true;
    light.alpha = 0.001;
    if (FlxG.save.data.distractions)
        add(light);

    var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('stages/philly/behindTrain'));
    add(streetBehind);

    phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('stages/philly/train'));
    if (FlxG.save.data.distractions)
        add(phillyTrain);

    var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('stages/philly/street'));
    add(street);

    trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
    FlxG.sound.list.add(trainSound);
}

function update(elapsed:Float) {
    if (trainMoving && !PlayStateChangeables.Optimize)
    {
        trainFrameTiming += elapsed;

        if (trainFrameTiming >= 1 / 24)
        {
            updateTrainPos();
            trainFrameTiming = 0;
        }
    }
}

function beatHit() {
    if (FlxG.save.data.distractions)
    {
        if (!trainMoving)
            trainCooldown += 1;

        if (curBeat % 4 == 0)
        {
            curLight = FlxG.random.int(0, lightColors.length - 1);
            light.color = lightColors[curLight];
            light.alpha = 1;
            FlxTween.tween(light, {alpha: 0.35}, (Conductor.crochet / 1000) * 1.5, {ease: FlxEase.quadOut});
        }

        if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
        {
            trainCooldown = FlxG.random.int(-4, 0);
            trainStart();
        }
    }
}

function trainStart():Void
{
    if (FlxG.save.data.distractions)
    {
        trainMoving = true;
        trainSound.play(true);
    }
}

var startedMoving:Bool = false;

function updateTrainPos():Void
{
    if (FlxG.save.data.distractions)
    {
        if (trainSound.time >= 4700)
        {
            startedMoving = true;
            gf.playAnim('hairBlow');
        }

        if (startedMoving)
        {
            phillyTrain.x -= 400;

            if (phillyTrain.x < -2000 && !trainFinishing)
            {
                phillyTrain.x = -1150;
                trainCars -= 1;

                if (trainCars <= 0)
                    trainFinishing = true;
            }

            if (phillyTrain.x < -4000 && trainFinishing)
                trainReset();
        }
    }
}

function trainReset():Void
{
    if (FlxG.save.data.distractions)
    {
        gf.playAnim('hairFall');
        phillyTrain.x = FlxG.width + 200;
        trainMoving = false;
        trainCars = 8;
        trainFinishing = false;
        startedMoving = false;
    }
}