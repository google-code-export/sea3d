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

package sunag.sea3d
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import sunag.sea.SEAObject;
	import sunag.utils.MathHelper;
	
	public class SEABitmap extends SEAObject
	{
		public static const TYPE:String = "bitmap";
		
		public var bitmapData:BitmapData
		private var loader:Loader = new Loader();
		
		public function SEABitmap(name:String, data:ByteArray, sea:SEA3D)
		{
			super(name, TYPE, data, sea, false);
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			loader.loadBytes(data, new LoaderContext(false, new ApplicationDomain()));
		}
						
		public function getCubeMapBitmapData(side:uint, limit:uint=2048):BitmapData
		{
			limit = MathHelper.upperPowerOfTwo(limit);
			
			loader.width = bitmapData.width;
			loader.height = bitmapData.height;
			
			var bitmap:BitmapData = new BitmapData(bitmapData.height, bitmapData.height, false, 0x00);
			
			bitmap.draw(loader, new Matrix(1,0,0,1,-bitmapData.height * side));
			
			return powerOfTwoBitmapData(bitmap, limit);
		}				
		
		public function get isCubemap():Boolean
		{
			return (bitmapData.height * 6) === bitmapData.width;
		}
		
		public function getPowerOfTwoBitmapData(limit:uint=2048):BitmapData
		{
			return powerOfTwoBitmapData(bitmapData, limit, false);
		}
		
		private function powerOfTwoBitmapData(bitmapData:BitmapData, limit:uint=2048, dispose:Boolean=true):BitmapData
		{
			limit = MathHelper.upperPowerOfTwo(limit);
			
			if (
				bitmapData.width != bitmapData.height || 
				MathHelper.upperPowerOfTwo(bitmapData.width) != bitmapData.width
			)
			{
				var size:uint = MathHelper.upperPowerOfTwo(bitmapData.width);
				if (size > limit) size = limit;
				loader.width = loader.height = size;
				var data:BitmapData = new BitmapData(size, size, true, 0);				
				data.draw(loader, loader.transform.matrix);
				if (dispose) bitmapData.dispose();
				return data;
			}
			
			return bitmapData;
		}
		
		private function onComplete (event:Event):void
		{			
			bitmapData = Bitmap(LoaderInfo(event.target).content).bitmapData;
			complete();
		}
		
		public override function dispose():void
		{
			bitmapData.dispose();
		}
	}
}