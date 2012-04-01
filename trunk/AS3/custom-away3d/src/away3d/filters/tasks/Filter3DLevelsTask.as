package away3d.filters.tasks
{
	import away3d.cameras.Camera3D;
	import away3d.core.managers.Stage3DProxy;
	
	import flash.display3D.Context3DProgramType;
	import flash.display3D.textures.Texture;
	import flash.geom.Point;

	public class Filter3DLevelsTask extends Filter3DTaskBase
	{
		private var _data : Vector.<Number>;
		
		public function Filter3DLevelsTask(red:Point=null, green:Point=null, blue:Point=null, rgb:Point=null)
		{
			super();
			_data = new Vector.<Number>(16,true);
			this.red = red ? red : new Point(0,1);
			this.green = green ? green : new Point(0,1);
			this.blue = blue ? blue : new Point(0,1);
			this.rgb = rgb ? rgb : new Point(0,1);
		}
	
		public function set red(value:Point):void
		{
			_data[0] = value.x;
			_data[1] = value.y;
			_data[2] = value.y - value.x;
		}
		
		public function get red():Point
		{
			return new Point(_data[0], _data[1]);
		}
		
		public function set green(value:Point):void
		{
			_data[4] = value.x;
			_data[5] = value.y;
			_data[6] = value.y - value.x;
		}
		
		public function get green():Point
		{
			return new Point(_data[4], _data[5]);
		}
		
		public function set blue(value:Point):void
		{
			_data[8] = value.x;
			_data[9] = value.y;
			_data[10] = value.y - value.x;
		}
		
		public function get blue():Point
		{
			return new Point(_data[8], _data[9]);
		}
		
		public function set rgb(value:Point):void
		{
			_data[12] = value.x;
			_data[13] = value.y;
			_data[14] = value.y - value.x;
		}
		
		public function get rgb():Point
		{
			return new Point(_data[12], _data[13]);
		}
		
		override protected function getFragmentCode() : String
		{
			return ["tex ft0, v0, fs0 <2d,linear,clamp>",
					getLevelFragmentCode(0, "x"),
					getLevelFragmentCode(1, "y"),
					getLevelFragmentCode(2, "z"),
					getLevelFragmentCode(3, "xyz"),
					"mov oc, ft0"].join("\n");
		}
		
		private function getLevelFragmentCode(inputAt:int, color:String):String
		{
			var input:String = "fc" + inputAt.toString() + ".";
			color = "." + color;			
			return ["sub ft1"+color+", "+("ft0"+color)+", "+(input+"x"),
					"div ft0"+color+", "+("ft1"+color)+", "+(input+"z")].join("\n");						
		}
		
		override public function activate(stage3DProxy : Stage3DProxy, camera3D : Camera3D, depthTexture : Texture) : void
		{				
			stage3DProxy.context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, _data, 4);
		}
	}
}
