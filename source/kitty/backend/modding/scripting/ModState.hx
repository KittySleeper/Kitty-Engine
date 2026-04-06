package kitty.backend.modding.scripting;

class ModState extends MusicBeatState {
    public static var epicState:String;
    private var script:HScript;

    override public function new(epicState:String) {
        super();
        ModState.epicState = epicState;
    }

    override public function create() {
        super.create();

        script = new HScript(epicState);
		if (!script.isBlank && script.expr != null)
		{
			script.interp.scriptObject = this;
			script.setValue('add', add);
			script.setValue('remove', remove);
			script.interp.execute(script.expr);
		}
        script.callFunction("create");
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
        script.callFunction("update", [elapsed]);
    }

    override public function beatHit() {
        super.beatHit();
        script.callFunction("beatHit");
    }

    override public function stepHit() {
        super.stepHit();
        script.callFunction("stepHit");
    }
}