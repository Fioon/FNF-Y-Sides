package states.stages;

import openfl.filters.ShaderFilter;
import shaders.BloomShader;

class HalloweenCreepyStage extends BaseStage
{
	override function create()
	{
                var sky:BGSprite = new BGSprite('spooky/monster/sky', -1248, -1041, 1, 1);
                add(sky);

                var moon:BGSprite = new BGSprite('spooky/monster/moon', -1315, -995, 0.1, 0.1);
                add(moon);

                var clouds:BGSprite = new BGSprite('spooky/monster/clouds', -1286, -1146, 0.2, 0.2);
                add(clouds);
                
                var buildings:BGSprite = new BGSprite('spooky/monster/buildings', -1288, -1235, 0.6, 0.6);
                add(buildings);

                var bgmain:BGSprite = new BGSprite('spooky/monster/bgmain', -1230, -1378, 1, 1);
                add(bgmain);
	}

	override function createPost()
	{
                var bloom = new BloomShader();

		bloom.dim.value = [1.8]; // 1.8
		bloom.Directions.value = [4.0]; // 2.0, 100.0 to remove
		bloom.Quality.value = [8.0]; //8.0
		bloom.Size.value = [4.0]; // 8.0, 1.0

                var shaderFilter = new ShaderFilter(bloom);
                FlxG.camera.filters = [shaderFilter];
	}
}