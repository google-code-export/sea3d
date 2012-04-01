package away3d.filters.tasks
{
	import away3d.cameras.Camera3D;
	import away3d.core.managers.Stage3DProxy;
	
	import flash.display3D.Context3DProgramType;
	import flash.display3D.textures.Texture;
	import flash.geom.ColorTransform;

	public class Filter3DColorTransformTask extends Filter3DTaskBase
	{				
		private var _filter : ColorTransform;
		private var _data : Vector.<Number>;
		
		public function Filter3DColorTransformTask(filter : ColorTransform = null)
		{
			super();
			
			_filter = filter ? filter : new ColorTransform();
			
			_data = new Vector.<Number>(8, true);
		}
	
		public function get colorTransform():ColorTransform
		{
			return _filter;
		}
		
		public function set colorTransform(filter:ColorTransform):void
		{
			_filter = filter;
		}
		
		override protected function getFragmentCode() : String
		{
			return "tex ft0, v0, fs0 <2d,linear,clamp>	\n" +
				"mul ft0, ft0, fc0						\n" +
				"add ft0, ft0, fc1						\n" +
				"mov oc, ft0							\n";
		}
		
		override public function activate(stage3DProxy : Stage3DProxy, camera3D : Camera3D, depthTexture : Texture) : void
		{	
			var inv : Number = 1/0xff;
			_data[0] = _filter.redMultiplier;
			_data[1] = _filter.greenMultiplier;
			_data[2] = _filter.blueMultiplier;
			_data[3] = _filter.alphaMultiplier;
			_data[4] = _filter.redOffset*inv;
			_data[5] = _filter.greenOffset*inv;
			_data[6] = _filter.blueOffset*inv;
			_data[7] = _filter.alphaOffset*inv;
			stage3DProxy.context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, _data, 2);
		}
	}
}
