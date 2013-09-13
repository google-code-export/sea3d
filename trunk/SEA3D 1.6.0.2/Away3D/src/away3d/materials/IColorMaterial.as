package away3d.materials
{
	import away3d.materials.lightpickers.LightPickerBase;
	import away3d.materials.methods.BasicAmbientMethod;
	import away3d.materials.methods.BasicDiffuseMethod;
	import away3d.materials.methods.BasicNormalMethod;
	import away3d.materials.methods.BasicSpecularMethod;
	import away3d.materials.methods.EffectMethodBase;
	import away3d.materials.methods.ShadowMapMethodBase;
	import away3d.textures.Texture2DBase;
	
	import flash.geom.ColorTransform;

	public interface IColorMaterial extends IPassMaterial
	{		
		function get color() : uint
		
		function set color(value : uint) : void
	}
}