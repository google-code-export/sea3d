package away3d.filters
{
	import away3d.filters.tasks.Filter3DColorBalanceTask;
	
	import flash.geom.Vector3D;

	public class ColorBalanceFilter3D extends Filter3DBase
	{
		private var _colorBalance : Filter3DColorBalanceTask;

		public function ColorBalanceFilter3D(preserveLuminance:Boolean=false)
		{
			super();
			_colorBalance = new Filter3DColorBalanceTask(preserveLuminance);
			addTask(_colorBalance);			
		}
		
		public function set shadows(value:Vector3D):void
		{
			_colorBalance.shadows = value;
		}
		
		public function get shadows():Vector3D
		{
			return _colorBalance.shadows;
		}
		
		public function set midtones(value:Vector3D):void
		{
			_colorBalance.midtones = value;
		}
		
		public function get midtones():Vector3D
		{
			return _colorBalance.midtones;
		}
		
		public function set highlights(value:Vector3D):void
		{
			_colorBalance.highlights = value;
		}
		
		public function get highlights():Vector3D
		{
			return _colorBalance.highlights;
		}
		
		public function set amount(value:Number):void
		{
			_colorBalance.amount = value;
		}				
		
		public function get amount():Number
		{
			return _colorBalance.amount;
		}
		
		public function get preserveLuminance():Boolean
		{
			return _colorBalance.preserveLuminance;
		}
	}
}
