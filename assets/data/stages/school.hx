// var bgGirls:FlxSprite;

// function create()
// {
// 	var bgSky = new FlxSprite().loadGraphic(Paths.image('stages/weeb/weebSky'));
// 	bgSky.scrollFactor.set(0.1, 0.1);
// 	add(bgSky);

// 	var repositionShit = -200;

// 	var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('stages/weeb/weebSchool'));
// 	bgSchool.scrollFactor.set(0.6, 0.90);
// 	add(bgSchool);

// 	var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('stages/weeb/weebStreet'));
// 	bgStreet.scrollFactor.set(0.95, 0.95);
// 	add(bgStreet);

// 	var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('stages/weeb/weebTreesBack'));
// 	fgTrees.scrollFactor.set(0.9, 0.9);
// 	add(fgTrees);

// 	var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
// 	var treetex = Paths.getPackerAtlas('stages/weeb/weebTrees');
// 	bgTrees.frames = treetex;
// 	bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
// 	bgTrees.animation.play('treeLoop');
// 	bgTrees.scrollFactor.set(0.85, 0.85);
// 	add(bgTrees);

// 	var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
// 	treeLeaves.frames = Paths.getSparrowAtlas('stages/weeb/petals');
// 	treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
// 	treeLeaves.animation.play('leaves');
// 	treeLeaves.scrollFactor.set(0.85, 0.85);
// 	add(treeLeaves);

// 	var widShit = Std.int(bgSky.width * 6);

// 	bgSky.setGraphicSize(widShit);
// 	bgSchool.setGraphicSize(widShit);
// 	bgStreet.setGraphicSize(widShit);
// 	bgTrees.setGraphicSize(Std.int(widShit * 1.4));
// 	fgTrees.setGraphicSize(Std.int(widShit * 0.8));
// 	treeLeaves.setGraphicSize(widShit);

// 	fgTrees.updateHitbox();
// 	bgSky.updateHitbox();
// 	bgSchool.updateHitbox();
// 	bgStreet.updateHitbox();
// 	bgTrees.updateHitbox();
// 	treeLeaves.updateHitbox();

// 	if (FlxG.save.data.distractions)
// 	{
//         bgGirls = new FlxSprite(-100, 190);
// 		bgGirls.frames = Paths.getSparrowAtlas('stages/weeb/bgFreaks');
//         bgGirls.scrollFactor.set(0.9, 0.9);
//         bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
//         bgGirls.updateHitbox();
//         bgGirls.animation.addByIndices('danceLeft', 'BG girls group', CoolUtil.numberArray(14), "", 24, false);
//         bgGirls.animation.addByIndices('danceRight', 'BG girls group', CoolUtil.numberArray(30, 15), "", 24, false);
//         bgGirls.animation.play('danceLeft');
// 		add(bgGirls);
// 	}
// }

// function postCreate()
// {
//     boyfriend.x += 200;
//     boyfriend.y += 220;
//     gf.x += 180;
//     gf.y += 300;
// }

// var danceDir:Bool = false;

// function beatHit() {
//     danceDir = !danceDir;

//     if (FlxG.save.data.distractions)
//         bgGirls.animation.play(danceDir ? 'danceRight' : 'danceLeft', true);
// }