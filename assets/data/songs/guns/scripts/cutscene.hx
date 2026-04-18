function create() {
    startCallback = () -> {
        var cutsceneSong:FlxSound = FlxG.sound.play(Paths.music("DISTORTO"), 0, true);
		cutsceneSong.fadeIn(1, 0, 0.5);

        FlxG.sound.play(Paths.sound('week7scenes/guns/tankSong2'));

        camHUD.alpha = 0;
        camZooming = dad.visible = false;
        camFollow.setPosition(dad.camPositionOffset[0] + dad.getMidpoint().x + 150, dad.camPositionOffset[1] + dad.getMidpoint().y - 100);

        FlxG.camera.zoom *= 1.2;

        var tankmanFag:FlxAnimate = add(new FlxAnimate(dad.x - 95, dad.y - 25));
        tankmanFag.frames = Paths.getAnimateAtlas("characters/tankman cutscenes");
        tankmanFag.anim.addBySymbol("P1", "TANK TALK 2", 24, false);
        tankmanFag.anim.play("P1");

        new FlxTimer().start(4.1, function(ugly:FlxTimer)
        {
            FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom * 1.4}, 0.4, {ease: FlxEase.quadOut});
            FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom * 1.3}, 0.7, {ease: FlxEase.quadInOut, startDelay: 0.45});

            gf.playAnim('sad');
        });

        tankmanFag.anim.finishCallback = (n) -> {
            tankmanFag.kill();
            dad.visible = true;
            inCutscene = false;
            startCountdown();

            cutsceneSong.destroy();
            FlxTween.tween(camHUD, {alpha: 1}, 2, {ease: FlxEase.expoOut});
            FlxTween.tween(FlxG.camera, {zoom: stageDefaultCamZoom}, 2, {ease: FlxEase.expoOut});
        };
    };

    inCutscene = true;
}