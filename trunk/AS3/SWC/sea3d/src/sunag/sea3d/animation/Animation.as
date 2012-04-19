/* Copyright (C) 2012 Sunag Entertainment
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/>. */

package sunag.sea3d.animation
{
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;

	public class Animation extends EventDispatcher
	{
		protected var _data:Vector.<AnimationSequence>;		
		protected var _timeElapsed:Number = 0;
		protected var _realTimeElapsed:Number = 0;
		protected var _startTime:uint = 0;			
		protected var _target:*;
		
		public var name:String;		
		
		public function Animation(data:Vector.<AnimationSequence>, target:*=null)
		{						
			_data = data || new Vector.<AnimationSequence>();
			_target = target;
		}
		
		public function get frameRate():uint
		{
			return data.length > 0 ? data[0].frameRate : 0;
		}
		
		public function set frameRate(value:uint):void
		{
			for each(var anm:AnimationSequence in _data)
			{
				anm.frameRate = value;
			}
		}
		
		public function get frame():Number
		{
			return data.length > 0 ? data[0].frame : 0;
		}
						
		public function set frame(value:Number):void
		{
			for each(var anm:AnimationSequence in _data)
			{
				anm.frame = value;
			}
		}
		
		public function get time():Number
		{
			return data.length > 0 ? data[0].time : 0;
		}
		
		public function set time(value:Number):void
		{
			for each(var anm:AnimationSequence in _data)
			{
				anm.time = value;
			}
		}
		
		public function get repeat():Boolean
		{
			return data.length > 0 ? data[0].repeat : 0;
		}
		
		public function set repeat(value:Boolean):void
		{
			for each(var anm:AnimationSequence in _data)
			{
				anm.repeat = value;
			}
		}
		
		public function get position():Number
		{
			return data.length > 0 ? data[0].position : 0;
		}
		
		public function set position(value:Number):void
		{
			for each(var anm:AnimationSequence in _data)
			{
				anm.position = value;
			}
		}
		
		public function get length():uint
		{
			return data.length > 0 ? data[0].length : 0;
		}
		
		public function get target():*
		{
			return _target;
		}
		
		public function resetTime():void
		{
			_realTimeElapsed = _timeElapsed = _startTime = 0;
		}
		
		public function updateTime(timeScale:Number=1):void
		{
			_realTimeElapsed = getTimer() - _startTime;
			_timeElapsed = _realTimeElapsed * timeScale;
			_startTime = getTimer();
			
			updateTimeSequence();
		}
		
		public function updateTimeSequence():void
		{
			for each(var anm:AnimationSequence in _data)
			{				
				anm.time += _timeElapsed;
			}
		}
		
		public function get timeElapsed():Number
		{
			return _timeElapsed;
		}
		
		public function get realTimeElapsed():Number
		{
			return _realTimeElapsed;
		}
		
		public function set timeElapsed(value:Number):void
		{
			_timeElapsed = value;
		}				
		
		public function set realTimeElapsed(value:Number):void
		{
			_realTimeElapsed = value;
		}
		
		public function getSequeceByKey(key:int):AnimationSequence
		{
			for each(var seq:AnimationSequence in data);
			{
				if (seq.key === key) return seq;
			}
			return null;
		}
		
		public function get data():Vector.<AnimationSequence>
		{
			return _data;
		}
		
		public function update():void
		{
			
		}
		
		public function cloneData():Vector.<AnimationSequence>
		{
			var _data:Vector.<AnimationSequence> = new Vector.<AnimationSequence>(data.length);
			
			for(var i:int = 0; i < data.length; i++)
			{
				_data[i] = data[i].clone();
			}
			
			return _data;
		}
		
		public function clone():Animation
		{
			return new Animation(cloneData());
		}
	}
}