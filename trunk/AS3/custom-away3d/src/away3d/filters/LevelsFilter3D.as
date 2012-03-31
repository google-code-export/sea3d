package away3d.filters
{
	import away3d.filters.tasks.Filter3DLevelsTask;
	
	import flash.geom.Point;

	public class LevelsFilter3D extends Filter3DBase
	{
		private var _levels : Filter3DLevelsTask;

		public function LevelsFilter3D(red:Point=null, green:Point=null, blue:Point=null, rgb:Point=null)
		{
			super();
			_levels = new Filter3DLevelsTask(red,green,blue,rgb);
			addTask(_levels);			
		}
		
		public function set red(value:Point):void
		{
			_levels.red = value;
		}
		
		public function get red():Point
		{
			return _levels.red;
		}
		
		public function set green(value:Point):void
		{
			_levels.green = value;
		}
		
		public function get green():Point
		{
			return _levels.green;
		}
		
		public function set blue(value:Point):void
		{
			_levels.blue = value;
		}
		
		public function get blue():Point
		{
			return _levels.blue;
		}
		
		public function set rgb(value:Point):void
		{
			_levels.rgb = value;
		}
		
		public function get rgb():Point
		{
			return _levels.rgb;
		}
	}
}
