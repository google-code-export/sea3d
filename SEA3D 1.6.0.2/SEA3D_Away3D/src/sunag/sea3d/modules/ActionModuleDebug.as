package sunag.sea3d.modules
{
	import sunag.sea3d.SEA3DDebug;
	import sunag.sea3d.modules.objects.SEAAction;
	import sunag.sunag;

	use namespace sunag;
	
	public class ActionModuleDebug extends ActionModule
	{
		override protected function readAction(sea:SEAAction):void
		{
			super.readAction(sea);
			
			for each(var act:Object in sea.action)
			{
				switch (act.type)
				{					
					case SEAAction.LOOK_AT:								
						(this.sea as SEA3DDebug).debug.creatLookAt(act.source.tag, act.target.tag);	
						break;
				}
			}						
		}
	}
}