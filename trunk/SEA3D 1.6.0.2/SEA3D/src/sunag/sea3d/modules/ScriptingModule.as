package sunag.sea3d.modules
{
	import sunag.sea3d.modules.objects.SEAData;
	import sunag.sea3d.modules.objects.SEAScript;
	import sunag.sunag;

	use namespace sunag;
	
	public class ScriptingModule extends ModuleBase
	{
		public function ScriptingModule()
		{
			regClass(SEAData);
			regClass(SEAScript);
		}		
	}
}