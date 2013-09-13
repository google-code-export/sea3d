package sunag.sea3d.modules
{
	import sunag.sea3d.modules.objects.SEACubeRender;
	import sunag.sea3d.modules.objects.SEAPlanarRender;
	import sunag.sunag;

	use namespace sunag;
	
	public class RTTBase extends ModuleBase
	{
		public function RTTBase()
		{						
			regClass(SEACubeRender);
			regClass(SEAPlanarRender);
		}
	}
}