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

package sunag.sea3d.texture
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	import sunag.utils.ByteArrayUtils;

	public class Layer
	{
		public var name:String;
		public var blendMode:int;
		public var opacity:Number;
		
		public var texture:LayerBitmap;
		public var mask:LayerBitmap;
		
		public function Layer(data:ByteArray)
		{
			var n:String;
			
			name = ByteArrayUtils.readUTFTiny(data);
			
			blendMode = data.readUnsignedByte();
			opacity = Number(data.readUnsignedByte()) / 100;
			
			n = ByteArrayUtils.readUTFTiny(data);			
			texture = new LayerBitmap(n, data);
			
			n = ByteArrayUtils.readUTFTiny(data);			
			if (n) mask = new LayerBitmap(n, data);
		}				
	}
}