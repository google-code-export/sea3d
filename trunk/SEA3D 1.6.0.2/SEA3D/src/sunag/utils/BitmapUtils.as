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
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.StageQuality;
	import flash.geom.Matrix;
	
	public class BitmapUtils
	{ 
		public static function resize(source:BitmapData, target:BitmapData):void
		{
			var bitmap:Bitmap = new Bitmap(source, PixelSnapping.AUTO, true);
			
			if (target.width >= target.height)
			{
				bitmap.height = target.height;
				bitmap.width = ((source.width / source.height) * target.height);								
			}
			else
			{
				bitmap.height = ((source.height / source.width) * target.width);
				bitmap.width = target.width;
			}
						
			target.drawWithQuality( bitmap, bitmap.transform.matrix, null, null, null, true, StageQuality.HIGH_8X8_LINEAR );
		}
		
		public static function powerOfTwoBitmapData(bitmapData:BitmapData, limit:uint=2048):BitmapData
		{
			if (!MathHelper.isPowerOfTwo(bitmapData.width) || !MathHelper.isPowerOfTwo(bitmapData.height) ||				 				
				bitmapData.width > limit || bitmapData.height > limit)
			{
				var bitmap:Bitmap = new Bitmap(bitmapData, PixelSnapping.AUTO, true);
										
				var width:uint = MathHelper.nearestPowerOfTwo(bitmapData.width),
					height:uint = MathHelper.nearestPowerOfTwo(bitmapData.height);
				
				if (width > limit) width = limit;
				if (height > limit) height = limit;
				
				bitmap.width = width;
				bitmap.height = height;
				
				var data:BitmapData = new BitmapData(width, height, bitmapData.transparent, 0);								
				data.drawWithQuality(bitmap, bitmap.transform.matrix, null, null, null, true, StageQuality.HIGH); 
				
				return data;
			}
			
			return bitmapData;
		}
	}
}