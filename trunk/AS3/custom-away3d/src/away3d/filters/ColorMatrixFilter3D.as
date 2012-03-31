package away3d.filters
{
	import away3d.filters.tasks.Filter3DColorMatrixTask;
	
	import flash.filters.ColorMatrixFilter;

	public class ColorMatrixFilter3D extends Filter3DBase
	{
		private var _colorMatrix : Filter3DColorMatrixTask;

		public function ColorMatrixFilter3D(filter : ColorMatrixFilter = null)
		{
			super();
			_colorMatrix = new Filter3DColorMatrixTask(filter);
			addTask(_colorMatrix);			
		}

		public function get colorMatrixFilter():ColorMatrixFilter
		{
			return _colorMatrix.colorMatrixFilter;
		}
		
		public function set colorMatrixFilter(filter:ColorMatrixFilter):void
		{
			_colorMatrix.colorMatrixFilter = filter;
		}
	}
}
