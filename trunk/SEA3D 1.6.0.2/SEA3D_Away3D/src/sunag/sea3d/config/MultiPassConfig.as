package sunag.sea3d.config
{
	import away3d.materials.ColorMultiPassMaterial;
	import away3d.materials.IColorMaterial;
	import away3d.materials.ITextureMaterial;
	import away3d.materials.TextureMultiPassMaterial;

	public class MultiPassConfig extends DefaultConfig
	{		
		override public function creatMaterial():ITextureMaterial
		{
			return new TextureMultiPassMaterial();
		}
	}
}