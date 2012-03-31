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
	import flash.utils.getTimer;
	
	import sunag.sea3d.token.Token;
	import sunag.utils.MathHelper;

	public class AnimationSequence
	{
		private static const _libType:Array = (function():Array
		{
			var data:Array = [];
			data[InterpolationType.LINEAR] = MathHelper.interpolation;
			data[InterpolationType.LINEAR_ANGLE] = MathHelper.interpolationAngle;
			data[InterpolationType.LINEAR_COLOR] = MathHelper.interpolationColor;
			return data;
		})();
		
		public var name:String;
		public var type:uint;
		
		public var frameRate:uint;				
		public var repeat:Boolean = true;
		public var count:int;
		
		public var data:Vector.<Number>;
		
		private var _time:Number = 0;
		
		public function AnimationSequence(frameRate:int=30, count:int=0, data:*=0, name:String=null, type:uint=0)
		{						
			this.name = name;
			this.type = type;
			this.frameRate = frameRate;
			this.count = count;			
			this.data = data is Vector.<Number> ? data : new Vector.<Number>(int(data));
		}
		
		public function getFrameAt(at:uint):AnimationFrame
		{
			at *= count;
			var vec:Vector.<Number> = new Vector.<Number>(count);
			
			for(var i:int=0;i<count;i++)
			{
				vec[i] = data[at + i];
			}
			
			return new AnimationFrame(vec);
		}
		
		public function getFrame():AnimationFrame
		{
			if (length === 0) 
				return getNull();
			
			var tf:uint = int(frame);
			
			return getFrameAt(tf);
		}
		
		public function getInterpolationFrame(type:String="linear"):AnimationFrame
		{
			if (length === 0) 
				return getNull();
			
			var tf:Number = frame;
			
			var prevFrame:uint = int(tf);
			var multipler:Number = tf - prevFrame;
			var result:AnimationFrame = getFrameAt(prevFrame);
			
			if (multipler > 0)
			{
				var nextFrame:uint = validFrame(prevFrame + 1);					
				_libType[type](result.data, getFrameAt(nextFrame).data, multipler);
			}						
			
			return result;
		}

		protected function getNull():AnimationFrame
		{
			return new AnimationFrame(new Vector.<Number>());
		}
		
		public function step(value:Number):void
		{			
			_time += value;
		}
		
		public function get time():Number
		{
			return _time;
		}
		
		public function nextFrame():void
		{
			step(1000 / frameRate);
		}
		
		public function prevFrame():void
		{
			step(-(1000 / frameRate));
		}
			
		public function get frame():Number
		{
			return validFrame( roundAt(_time / (1000 / frameRate), .00001) );
		}
		
		public function set frame(value:Number):void
		{
			_time = value * (1000 / frameRate);
		}
		
		public function get position():Number
		{
			return frame / Number(length);
		}
		
		public function set position(value:Number):void
		{
			frame = value * Number(length);
		}
		
		private function roundAt(value:Number, limit:Number):Number
		{
			var pValue:Number = value < 0 ? -value : value;
			
			if (int(pValue) + 1 < pValue + limit || int(pValue) > pValue - limit)
			{
				value = Math.round(value);
			}
			
			return value;
		}		
		
		private function validFrame(value:Number):Number
		{			
			var inverse:Boolean = value < 0;
			
			if (inverse) value = -value;			
			
			if (repeat) value %= length;				
			else if (value >= length) value = length - 1;	
			
			if (inverse) value = Number(length) - value;
			
			return value;
		}
		
		public function get length():int
		{
			return data.length / count;
		}
		
		public function clone():AnimationSequence
		{
			return new AnimationSequence(frameRate, count, data, name, type);
		}
	}
}