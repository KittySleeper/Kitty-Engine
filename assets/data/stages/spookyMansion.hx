var halloweenBG:FlxSprite;

var lightningStrikeBeat:Int = 0;
var lightningOffset:Int = 8;

function create() {
    halloweenBG = new FlxSprite(-200, -100);
    halloweenBG.frames = Paths.getSparrowAtlas('stages/spooky/halloween_bg');
    halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
    halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
    halloweenBG.animation.play('idle');
    halloweenBG.antialiasing = true;
    add(halloweenBG);
}

function beatHit() {
    if (FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
    {
        if (FlxG.save.data.distractions)
        {
            lightningStrikeShit();
        }
    }
}

function lightningStrikeShit():Void
{
    FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
    halloweenBG.animation.play('lightning');

    lightningStrikeBeat = curBeat;
    lightningOffset = FlxG.random.int(8, 24);

    boyfriend.playAnim('scared', true);
    gf.playAnim('scared', true);
}