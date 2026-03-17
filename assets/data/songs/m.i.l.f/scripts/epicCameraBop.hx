function beatHit() {
    if (curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
    {
        FlxG.camera.zoom += 0.015;
        camHUD.zoom += 0.03;
    }
}