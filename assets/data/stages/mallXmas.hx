var upperBoppers:FlxSprite;
var bottomBoppers:FlxSprite;
var santa:FlxSprite;

function create() {
    stageDefaultCamZoom = 0.80;

    var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('stages/christmas/bgWalls'));
    bg.antialiasing = true;
    bg.scrollFactor.set(0.2, 0.2);
    bg.active = false;
    bg.setGraphicSize(Std.int(bg.width * 0.8));
    bg.updateHitbox();
    add(bg);

    upperBoppers = new FlxSprite(-240, -90);
    upperBoppers.frames = Paths.getSparrowAtlas('stages/christmas/upperBop');
    upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
    upperBoppers.antialiasing = true;
    upperBoppers.scrollFactor.set(0.33, 0.33);
    upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
    upperBoppers.updateHitbox();
    if (FlxG.save.data.distractions)
        add(upperBoppers);

    var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('stages/christmas/bgEscalator'));
    bgEscalator.antialiasing = true;
    bgEscalator.scrollFactor.set(0.3, 0.3);
    bgEscalator.active = false;
    bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
    bgEscalator.updateHitbox();
    add(bgEscalator);

    var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('stages/christmas/christmasTree'));
    tree.antialiasing = true;
    tree.scrollFactor.set(0.40, 0.40);
    add(tree);

    bottomBoppers = new FlxSprite(-300, 140);
    bottomBoppers.frames = Paths.getSparrowAtlas('stages/christmas/bottomBop');
    bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
    bottomBoppers.antialiasing = true;
    bottomBoppers.scrollFactor.set(0.9, 0.9);
    bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
    bottomBoppers.updateHitbox();
    if (FlxG.save.data.distractions)
        add(bottomBoppers);

    var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('stages/christmas/fgSnow'));
    fgSnow.active = false;
    fgSnow.antialiasing = true;
    add(fgSnow);

    santa = new FlxSprite(-840, 150);
    santa.frames = Paths.getSparrowAtlas('stages/christmas/santa');
    santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
    santa.antialiasing = true;
    if (FlxG.save.data.distractions)
        add(santa);
}

function postCreate() {
    boyfriend.x += 200;
    boyfriend.camPositionOffset[1] -= 100;
}

function beatHit() {
    if (FlxG.save.data.distractions)
    {
        upperBoppers.animation.play('bop', true);
        bottomBoppers.animation.play('bop', true);
        santa.animation.play('idle', true);
    }
}