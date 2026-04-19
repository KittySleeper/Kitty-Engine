// TODO: make it so this can work on any song cuz rn this only works on VSlicey Charts
// holy shit this code is messy:sob:

var epicChart:Dynamic;
var randomGuys:Array = [];

function postCreate() {
    epicChart = Paths.json('data/songs/' + PlayState.instance.SONG.song.toLowerCase() + '/chart').notes.picospeaker;
    playAnim("shoot0-loop", true);

    for (i => note in epicChart) {
        if (FlxG.random.bool(16) && FlxG.save.data.distractions) {
            var tankmanGuy = new FlxAnimate(500, 200 + FlxG.random.int(50, 100));
            tankmanGuy.frames = Paths.getAnimateAtlas("stages/tankmanBattlefield/tankman_stress");
            tankmanGuy.anim.addBySymbol("walk", "tankman running", 24, true);
            tankmanGuy.anim.addBySymbol("shot", "John Shot " + FlxG.random.int(1, 2), 24, false);
            tankmanGuy.anim.play("walk", true);
            tankmanGuy.flipX = note.d < 2;
            tankmanGuy.visible = false;
            FlxG.state.insert(11, tankmanGuy);

            randomGuys.push([note.t, {
                "guy": tankmanGuy,
                "endOffset": FlxG.random.float(50, 200),
                "speed": FlxG.random.float(0.6, 1)
            }]);
        }
    }
}

function update(elapsed) {
    for (meow in randomGuys) {
        if (meow[1].guy.anim.curAnim.name == "walk") {
            if (meow[1].guy.x >= FlxG.width * 1.2 || meow[1].guy.x <= FlxG.width * -0.5)
                meow[1].guy.visible = false;
            else
                meow[1].guy.visible = true;

            var endDirection:Float = (FlxG.width * 0.74) + meow[1].endOffset;

            if (meow[1].guy.flipX)
            {
                endDirection = (FlxG.width * 0.02) - meow[1].endOffset;

                meow[1].guy.x = (endDirection + (Conductor.songPosition - meow[0]) * meow[1].speed);
            }
            else
            {
                meow[1].guy.x = (endDirection - (Conductor.songPosition - meow[0]) * meow[1].speed);
            }
        } else {
            if (meow[1].guy.anim.curAnim.finished)
                meow[1].guy.kill();
        }
    }

    for (note in epicChart) {
        if (Conductor.songPosition > note.t) {
            epicChart.remove(note);

            for (meow in randomGuys) {
                if (meow[0] == note.t) {
                    meow[1].guy.anim.play("shot", true);
                    if (meow[1].guy.flipX)
                    {
                        meow[1].guy.offset.y = 200;
                        meow[1].guy.offset.x = 300;
                    }

                    randomGuys.remove(moew);
                }
            }

            playAnim("shoot" + note.d, true);
            animation.finishCallback = (n) -> {
                playAnim(animation.curAnim.name + "-loop", true);
                animation.finishCallback = (n) -> {};
            };
        }
    }
}