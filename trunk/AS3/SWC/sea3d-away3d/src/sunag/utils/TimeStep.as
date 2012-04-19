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

package sunag.utils
{
	import flash.utils.getTimer;

	public class TimeStep
	{
		private var oldTime:Number=0;
		private var actTime:Number=0;
		
		private var _frameRate:Number=0;		
		private var _step:uint=0;
		private var _timeStep:Number=0;
		
		private var _averagePosition:uint = 0;
		private var _averageStep:Vector.<uint> = new Vector.<uint>(60);
		
		public function TimeStep()
		{
			update();
		}
		
		public function update():void
		{
			actTime = getTimer();		
									
			_step = actTime - oldTime;			
			_timeStep = Number(_step) / 1000.0;			
			_frameRate = 1000.0 / Number(_step);		
						
			_averageStep[_averagePosition] = _step;
			_averagePosition = (_averagePosition+1) % _averageStep.length;
			
			if (_timeStep > .25) 
				_timeStep = .25;
			
			oldTime = actTime;
		}
		
		public function getAverageStep():Number
		{
			var average:Number = 0;
			for each(var v:uint in _averageStep)
			{
				average += v;
			}			
			average /= _averageStep.length;
			return average;
		}
		
		public function getAverageTimeStep():Number
		{
			return getAverageStep() / 1000.0;
		}
		
		public function getAverageFrameRate():Number
		{
			return 1000.0 / getAverageStep();
		}
		
		public function get step():uint
		{
			return _step;
		}
		
		public function get timeStep():Number
		{
			return _timeStep;
		}
		
		public function get frameRate():Number
		{
			return _frameRate;
		}
	}
}