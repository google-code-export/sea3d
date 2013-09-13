package sunag.sea3d
{
	import away3d.entities.Entity;
	
	import sunag.animation.IAnimationPlayer;
	import sunag.sea3d.config.IConfig;
	import sunag.sea3d.debug.IDebug;
	import sunag.sea3d.objects.SEACamera;
	import sunag.sea3d.objects.SEADirectionalLight;
	import sunag.sea3d.objects.SEAObject3D;
	import sunag.sea3d.objects.SEAPointLight;
	import sunag.sunag;
	
	use namespace sunag;
	
	public class SEA3DDebug extends SEA3D
	{
		protected var _debug:IDebug
		
		/**
		 * Creates a new SEA3D loader 
		 * @param config Settings of loader
		 * @param player If you have a player all animations will be automatically added to it
		 * @param debug Creates Dummy and Log for the objects of the scene.
		 * 
		 * @see SEA3D
		 * @see SEA3DManager
		 */
		public function SEA3DDebug(debug:IDebug, config:IConfig=null)
		{
			super(config);
			_debug = debug;
			if (!_debug) throw new Error("Debug can not be null.");
		}
		
		override protected function readCamera(sea:SEACamera):void
		{
			super.readCamera(sea);
			_debug.creatCamera(sea.tag);
		}
		
		override protected function readPointLight(sea:SEAPointLight):void
		{
			super.readPointLight(sea);
			_debug.creatPointLight(sea.tag);
		}
		
		override protected function readDirectionalLight(sea:SEADirectionalLight):void
		{
			super.readDirectionalLight(sea);
			_debug.creatDirectionalLight(sea.tag);
		}
		
		/**
		 * Debug object  
		 */
		public function get debug():IDebug
		{
			return _debug;
		}
	}
}