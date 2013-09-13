package sunag.sea3d.modules
{
	import sunag.sea3d.modules.objects.SEAMP3;
	import sunag.sea3d.modules.objects.SEASoundMixer;
	import sunag.sea3d.modules.objects.SEASoundPoint;
	import sunag.sunag;

	use namespace sunag;
	
	public class SoundModuleBase extends ModuleBase
	{
		public function SoundModuleBase()
		{
			regClass(SEAMP3);
			regClass(SEASoundMixer);
			regClass(SEASoundPoint);
		}	
	}
}