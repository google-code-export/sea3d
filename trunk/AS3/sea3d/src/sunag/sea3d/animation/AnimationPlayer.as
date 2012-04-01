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

	public class AnimationPlayer
	{
		private var _list:Vector.<Animation> = new Vector.<Animation>();		
		private var _timeElapsed:Number = 0;
		private var _realTimeElapsed:Number = 0;
		private var _startTime:uint = 0;
		
		public function AnimationPlayer(list:Vector.<Animation>=null)
		{
			_list = list || new Vector.<Animation>();
		}
		
		public function get list():Vector.<Animation>
		{
			return _list;
		}
		
		public function get numAnimation():uint
		{
			return _list.length;
		}
		
		public function addAnimation(anm:Animation):void
		{
			_list.push(anm);
		}
		
		public function removeAnimation(anm:Animation):void
		{
			removeAnimationAt(getAnimationIndex(anm));
		}
		
		public function removeAnimationAt(value:int):Animation
		{
			return _list.splice(value,1)[0];
		}
		
		public function getAnimationAt(value:int):Animation
		{
			return _list[value];
		}
		
		public function getAnimationIndex(anm:Animation):int
		{
			return _list.indexOf(anm);
		}
		
		public function getAnimationByName(name:String):Animation
		{
			for each(var anm:Animation in _list)
			{
				if (anm.name === name) return anm;
			}
			return null;
		}
		
		public function getAnimationByTarget(target:*):Animation
		{
			for each(var anm:Animation in _list)
			{
				if (anm.target === target) return anm;
			}
			return null;
		}
		
		public function get timeElapsed():Number
		{
			return _timeElapsed;
		}
		
		public function get realTimeElapsed():Number
		{
			return _realTimeElapsed;
		}
		
		public function updateTime(timeScale:Number=1):void
		{
			_realTimeElapsed = Number(getTimer() - _startTime);
			_timeElapsed = _realTimeElapsed * timeScale;
			_startTime = getTimer();
		}
		
		public function resetTime():void
		{
			_realTimeElapsed = _timeElapsed = 0
			_startTime = getTimer();
		}
		
		public function get position():Number
		{
			return _list.length > 0 ? _list[0].position : 0;
		}
		
		public function set position(value:Number):void
		{
			for each(var anm:Animation in _list)
			{
				anm.position = value;
			}
		}
		
		public function get frameRate():uint
		{
			return _list.length > 0 ? _list[0].frameRate : 0;
		}
		
		public function get frame():Number
		{
			return _list.length > 0 ? _list[0].frame : 0;
		}
		
		public function set frame(value:Number):void
		{
			for each(var anm:Animation in _list)
			{
				anm.frame = value;
			}
		}
		
		public function get repeat():Boolean
		{
			return _list.length > 0 ? _list[0].repeat : 0;
		}
		
		public function set repeat(value:Boolean):void
		{
			for each(var anm:Animation in _list)
			{
				anm.repeat = value;
			}
		}
		
		public function get length():uint
		{
			return _list.length > 0 ? _list[0].length : 0;
		}
		
		public function set length(value:uint):void
		{
			_list.length = value;
		}
		
		public function update():void
		{
			for each(var anm:Animation in _list)
			{
				anm.realTimeElapsed = _realTimeElapsed;
				anm.timeElapsed = _timeElapsed;
				anm.update();
			}
		}
	}
}