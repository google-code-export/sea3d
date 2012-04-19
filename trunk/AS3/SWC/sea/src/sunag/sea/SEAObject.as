package sunag.sea
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;
	
	public class SEAObject extends EventDispatcher
	{
		private var _loaded:Boolean = false;
		private var _name:String;
		private var _type:String;
		private var _ns:String;
		private var _data:ByteArray;
		private var _sea:SEA;
		
		public function SEAObject(name:String, type:String, data:ByteArray, sea:SEA, loaded:Boolean=true):void
		{
			_name = name;
			_type = type;
			_data = data;
			_ns = _type + '/' + _name;
			_loaded = loaded; 
		}
		
		public function get sea():SEA
		{
			return _sea;
		}
		
		public function dispose():void
		{
			
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function get type():String
		{
			return _type;
		}
		
		protected function get data():ByteArray
		{
			return _data;
		}
		
		protected function complete():void
		{
			_data = null;
			_loaded = true;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function get ns():String
		{
			return _ns;
		}
		
		public function get loaded():Boolean
		{
			return _loaded;
		}
	}
}