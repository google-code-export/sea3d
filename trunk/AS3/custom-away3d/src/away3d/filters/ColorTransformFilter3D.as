package away3d.filters
{
	import away3d.filters.tasks.Filter3DColorTransformTask;
	
	import flash.geom.ColorTransform;

	public class ColorTransformFilter3D extends Filter3DBase
	{
		private var _colorTransform : Filter3DColorTransformTask;

		public function ColorTransformFilter3D(filter : ColorTransform = null)
		{
			super();
			_colorTransform = new Filter3DColorTransformTask(filter);
			addTask(_colorTransform);			
		}

		public function get colorTransform():ColorTransform
		{
			return _colorTransform.colorTransform;
		}
		
		public function set colorTransform(filter:ColorTransform):void
		{
			_colorTransform.colorTransform = filter;
		}
	}
}
