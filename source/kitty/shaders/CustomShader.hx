package kitty.shaders;

import flixel.system.FlxAssets.FlxShader;

class CustomShader extends FlxShader
{
    public var shaderPath:String = "";
    public var shader:String;

    public function new(shaderPath:String = "")
    {
        this.shaderPath = shaderPath;
        trace(Paths.shader(shaderPath));
        glFragmentSource = shader = Paths.shader(shaderPath);
        super();
    }
}