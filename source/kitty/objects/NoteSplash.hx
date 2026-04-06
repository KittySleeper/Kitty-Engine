package kitty.objects;

class NoteSplash extends FlxSprite {
    public var animNames:Array<String> = ["left", "down", "up", "right"];
    public var daNote:Note;

    public function new(x:Float, y:Float, daNote:Note) {
        super(x, y);

        this.daNote = daNote;

        if (daNote.isSustainNote) {
            frames = Paths.getSparrowAtlas("holdsplashes");
            animation.addByPrefix(animNames[daNote.noteData], "holdCover" + (daNote.isSustainEnd() ? "End" : daNote.isSustainStart() ? "Start" : "") + animNames[daNote.noteData], 24, false);
        } else {
            frames = Paths.getSparrowAtlas("splashes");
            animation.addByPrefix(animNames[daNote.noteData], "note splash " + (FlxG.random.bool(50) ? "1 " : "2 ") + animNames[daNote.noteData], 24, false);
            alpha = 0.5;
        }
        updateHitbox();

        animation.onFinish.add(name -> destroy());
        animation.play(animNames[daNote.noteData], true);
    }
}