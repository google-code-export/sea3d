package sunag.sea3d.modules
{
	import sunag.sea3d.SEA3DDebug;
	import sunag.sea3d.modules.objects.SEASoundPoint;
	import sunag.sunag;

	use namespace sunag;
	
	public class SoundModuleDebug extends SoundModule
	{
		override protected function readSoundPoint(sea:SEASoundPoint):void
		{
			super.readSoundPoint(sea);
			(this.sea as SEA3DDebug).debug.creatPointSound(sea.tag, sea.distance);
		}
	}
}