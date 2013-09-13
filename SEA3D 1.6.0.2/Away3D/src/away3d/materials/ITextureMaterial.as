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

	public interface ITextureMaterial extends IPassMaterial
	{		
		 function get animateUVs() : Boolean
		 
		 function set animateUVs(value : Boolean) : void
		 
		 function get texture() : Texture2DBase
		 
		 function set texture(value : Texture2DBase) : void
		 
		 function get ambientTexture() : Texture2DBase
		 
		 function set ambientTexture(value : Texture2DBase) : void
	}
}