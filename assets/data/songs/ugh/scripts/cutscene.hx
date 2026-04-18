function create() {
    startCallback = () -> {
        var cutsceneSong:FlxSound = FlxG.sound.play(Paths.music("DISTORTO"), 0, true);
		cutsceneSong.fadeIn(1, 0, 0.5);

        FlxG.sound.play(Paths.sound('week7scenes/ugh/well'));

        camHUD.alpha = 0;
        camZooming = dad.visible = false;
        camFollow.setPosition(dad.camPositionOffset[0] + dad.getMidpoint().x + 150, dad.camPositionOffset[1] + dad.getMidpoint().y - 100);

        FlxG.camera.zoom *= 1.2;

        var tankmanFag:FlxAnimate = add(new FlxAnimate(dad.x - 85, dad.y - 20));
        tankmanFag.frames = Paths.getAnimateAtlas("characters/tankman cutscenes");
        tankmanFag.anim.addBySymbol("P1", "TANK TALK 1 P1", 24, false);
        tankmanFag.anim.addBySymbol("P2", "TANK TALK 1 P2", 24, false);
        tankmanFag.anim.play("P1");

        tankmanFag.anim.finishCallback = (n) -> {
            tankmanFag.anim.finishCallback = (n) -> {};
            FlxTween.tween(camFollow, {x: boyfriend.camPositionOffset[0] + boyfriend.getMidpoint().x - 100, y: boyfriend.camPositionOffset[1] + boyfriend.getMidpoint().y - 100}, 2, {ease: FlxEase.expoOut, onComplete: (t) -> {
                FlxG.sound.play(Paths.sound('week7scenes/ugh/beep'));

                boyfriend.playAnim("singUP", true);
                boyfriend.holdTimer = -0.5;

                new FlxTimer().start(1.35, (t) -> {
                    FlxTween.tween(camFollow, {x: dad.camPositionOffset[0] + dad.getMidpoint().x + 150, y: dad.camPositionOffset[1] + dad.getMidpoint().y - 100}, 4, {ease: FlxEase.expoOut});

                    FlxG.sound.play(Paths.sound('week7scenes/ugh/killYou'));
                    tankmanFag.x -= 35;
                    tankmanFag.y -= 25;
                    tankmanFag.anim.play("P2");

                    tankmanFag.anim.finishCallback = (n) -> {
                        tankmanFag.kill();
                        dad.visible = true;
                        inCutscene = false;
                        startCountdown();

                        cutsceneSong.destroy();
                        FlxTween.tween(camHUD, {alpha: 1}, 2, {ease: FlxEase.expoOut});
                        FlxTween.tween(FlxG.camera, {zoom: stageDefaultCamZoom}, 2, {ease: FlxEase.expoOut});
                    };
                });
            }});
        };
    };

    inCutscene = true;
}