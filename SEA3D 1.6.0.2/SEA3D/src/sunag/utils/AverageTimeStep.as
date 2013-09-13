/*
*
* Copyright (c) 2013 Sunag Entertainment
*
* Permission is hereby granted, free of charge, to any person obtaining a copy of
* this software and associated documentation files (the "Software"), to deal in
* the Software without restriction, including without limitation the rights to
* use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
* the Software, and to permit persons to whom the Software is furnished to do so,
* subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
* FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
* COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
* IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
* CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*
*/

package sunag.utils
{
	import sunag.sunag;

	use namespace sunag;
	
	public class AverageTimeStep extends TimeStep
	{
		private var _averagePosition:uint = 0;
		private var _averageStep:Vector.<int>;
		
		public function AverageTimeStep(fixedFrameRate:Number=60, autoUpdate:Boolean=true, averageSize:int=30)
		{
			_averageStep = new Vector.<int>(averageSize);
			
			super(fixedFrameRate, autoUpdate);			
		}
		
		override public function update(sameFrame:Boolean=false):void
		{						
			super.update(sameFrame);
			
			if (!sameFrame)
			{
				_averageStep[_averagePosition] = _step;
				_averagePosition = (_averagePosition+1) % _averageStep.length;
			}						
		}
		
		public function getAverageDeltaTime():Number
		{
			var average:Number = 0;
			for each(var v:int in _averageStep)
			{
				average += v;
			}			
			average /= _averageStep.length;
			return average;
		}
		
		public function getAverageFrameRate():Number
		{
			return 1000.0 / getAverageDeltaTime();
		}
	}
}