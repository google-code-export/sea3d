package sunag.sea3d.modules
{
	import away3d.containers.ObjectContainer3D;
	import away3d.controllers.LookAtController;
	import away3d.materials.IPassMaterial;
	import away3d.materials.methods.DynamicFogMethod;
	import away3d.materials.methods.EffectMethodBase;
	import away3d.materials.methods.FogMethod;
	import away3d.primitives.SkyBox;
	
	import sunag.sea3d.SEA;
	import sunag.sea3d.SEA3D;
	import sunag.sea3d.modules.objects.ISEARTT;
	import sunag.sea3d.modules.objects.SEAAction;
	import sunag.sunag;

	use namespace sunag;
	
	public class ActionModule extends ActionModuleBase
	{
		sunag var sea3d:SEA3D;
		
		protected var _container:*;
		protected var _skyBox:SkyBox;
		
		public function ActionModule()
		{			
			regRead(SEAAction.TYPE, readAction);
		}
		
		override sunag function reset():void
		{
			_skyBox = null;		
			_container = sea3d.container;
		}
		
		protected function applyMethod(method:EffectMethodBase):void
		{
			for each(var mat:IPassMaterial in sea3d.materials)
			{
				mat.addMethod(method);
			}
		}
		
		protected function readAction(sea:SEAAction):void
		{			
			for each(var act:Object in sea.action)
			{
				switch (act.kind)
				{					
					case SEAAction.LOOK_AT:
						act.source.tag.controller = new LookAtController(act.target.tag);		
						break;
					
					case SEAAction.RTT_TARGET:				
						act.source.tag.target = act.target.tag;						
						break;
					
					case SEAAction.FOG:				
						DynamicFogMethod.instance.enabled = true;
						DynamicFogMethod.instance.fogColor = act.color;
						DynamicFogMethod.instance.minDistance = act.min;
						DynamicFogMethod.instance.maxDistance = act.max;					
						break;
					
					case SEAAction.ENVIRONMENT:
						if (_skyBox) 
							_skyBox.dispose();
						
						_skyBox = new SkyBox(act.texture.tag)
						
						if (_container) 
							_container.addChild(_skyBox);				
						break;
				}
			}
		}
		
		public function get skyBox():SkyBox
		{
			return _skyBox;
		}
		
		override public function dispose():void
		{
			if (_skyBox)
				_skyBox.dispose();
			
			super.dispose();
		}
		
		//
		//	Init
		//
		
		override sunag function init(sea:SEA):void
		{
			this.sea = sea;
			sea3d = sea as SEA3D;			
		}
	}
}