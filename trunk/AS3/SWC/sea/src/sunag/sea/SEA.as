package sunag.sea
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.ByteArray;
	import flash.utils.CompressionAlgorithm;
	import flash.utils.Endian;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import sunag.utils.ByteArrayUtils;
	
	public class SEA extends EventDispatcher
	{					
		private var _type:String = "unknown";
		private var _time:uint = 0;
		private var _startTime:uint = 0;
		private var _endTime:uint = 0;
		private var _data:ByteArray;
		private var _protectMethod:uint = 0;
		private var _compressMethod:uint = 0;
		private var _timer:Timer;
		private var _objectsTag:Array = [];
		private var _objects:Vector.<SEAObject> = new Vector.<SEAObject>();
		private var _objectsDict:Array = [];
		private var _position:uint = 0;
		private var _length:uint = 0;
		private var _loaded:Boolean = false;
		private var _version:int = 1;
		private var _subversion:int = 0
		
		public function get position():uint
		{
			return _position;
		}
		
		public function get length():uint
		{
			return _objectsTag.length;
		}
			
		public function load(bytes:ByteArray):void
		{		
			bytes.position = 0;
			readHead(bytes);
			readBody(bytes);									
		}				
		
		protected function readHead(bytes:ByteArray):void
		{
			_loaded = false;
			_time = getTimer();
			_startTime = getTimer();			
			_position = 0;
			_objectsTag.length = 0;			
			_objects.length = 0;
			_objectsDict = [];					
			
			if (bytes.readUTFBytes(3) !== "SEA")
				throw new Error("Invalid format.");
			
			_version = bytes.readUnsignedByte();
			_subversion = bytes.readUnsignedByte();
			
			_type = ByteArrayUtils.readUTFTiny(bytes);
			
			_protectMethod = bytes.readUnsignedByte();
			_compressMethod = bytes.readUnsignedByte();
		}
		
		protected function readBody(bytes:ByteArray):void
		{
			_data = ByteArrayUtils.split(bytes, bytes.position);
			
			if (_compressMethod > 0)
			{
				if (_compressMethod == CompressMethod.ZLIB) _data.uncompress();
				else if (_compressMethod == CompressMethod.DEFLATE) _data.inflate();
			}
			
			var len:uint = 0;
			var count:uint = _data.readUnsignedShort();
			for(var i:int=0;i<count;i++)
			{
				var name:String = ByteArrayUtils.readUTFTiny(_data);
				var type:String = ByteArrayUtils.readUTFTiny(_data);
				var size:uint = _data.readUnsignedInt();
				
				_objectsTag[i] = {name:name, type:type, position:len, size:size};
				
				len += size;
			}
						
			onRead(null, false);
		}
		
		protected function process(name:String, type:String, data:ByteArray):SEAObject
		{
			return new SEAObject(name, type, data, this);
		}
		
		private function onRead(e:TimerEvent=null, updateTime:Boolean=true):void
		{			
			if (updateTime) _time = getTimer();
			
			dispatchEvent(new SEAEvent(SEAEvent.PROGRESS));
			
			var obj:Object = _objectsTag[_position++];
			var pos:uint = _data.position;
			var bytes:ByteArray = ByteArrayUtils.split(_data, pos + obj.position, obj.size);			
			var seaObject:SEAObject = process(obj.name, obj.type, bytes); 
			
			dispatchEvent(new SEAEvent(SEAEvent.PROGRESS_OBJECT, seaObject));
			
			if (_timer)
			{
				_timer.removeEventListener(TimerEvent.TIMER, onRead);
				_timer.stop();
				_timer = null;
			}
			
			if (seaObject.loaded)
			{
				dispatchEvent(new SEAEvent(SEAEvent.COMPLETE_OBJECT, seaObject));
				
				_time = getTimer() - _time;
				
				if (_position < _objectsTag.length)
				{
					if (_time > 16)
					{
						if (!_timer)
						{
							_timer = new Timer(1);
							_timer.addEventListener(TimerEvent.TIMER, onRead);
							_timer.start();
						}
					}		
					else onRead(e, false);
				}
				else
				{
					complete();
				}
			}			
			else
			{
				seaObject.addEventListener(Event.COMPLETE, onObjectComplete);
			}
		}
		
		private function onObjectComplete(e:Event):void
		{
			var seaObject:SEAObject = e.currentTarget as SEAObject;			
			
			_objectsDict[seaObject.ns] = seaObject;
			
			_objects.push(seaObject);
			
			seaObject.removeEventListener(Event.COMPLETE, onObjectComplete);			
			dispatchEvent(new SEAEvent(SEAEvent.COMPLETE_OBJECT, seaObject));						
			
			if (_position < _objectsTag.length)
			{
				onRead();
			}			
			else
			{
				complete();
			}
		}
		
		private function complete():void
		{
			_loaded = true;
			_objectsTag.length = 0;
			_endTime = getTimer();
			dispatchEvent(new SEAEvent(SEAEvent.COMPLETE));
		}
		
		public function get totalTime():uint
		{
			if (_startTime === 0) return 0;
			else if (_endTime === 0) return getTimer() - _startTime;
			return _endTime - _startTime;
		}
		
		public function get protectMethod():uint
		{
			return _protectMethod;
		}
		
		public function get compressMethod():uint
		{
			return _compressMethod;
		}
		
		public function get type():String
		{
			return _type;
		}			
		
		public function get loaded():Boolean
		{
			return _loaded;
		}
		
		public function dispose():void
		{
			for each(var obj:SEAObject in _objects)
			{
				obj.dispose();
			}
		}
		
		public function get objects():Vector.<SEAObject>
		{
			return _objects;
		}
		
		public function getObject(ns:String):SEAObject
		{
			for each(var obj:SEAObject in _objects)
			{
				if (obj.ns === ns) return obj;
			}
			return null;
		}
	}
}