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
	import flash.utils.ByteArray;
	
	import sunag.sea3d.token.Token;
	import sunag.utils.ByteArrayUtils;

	public class LayerBitmap
	{
		public var name:String;
		public var animation:String;
		public var offsetU:Number = 0;
		public var offsetV:Number = 0;		
		public var scaleU:Number = 1;
		public var scaleV:Number = 1;
		public var repeatU:Boolean = true;
		public var repeatV:Boolean = true;
		public var rotation:Number = 0;
		public var channel:int = 0;
		public var mappingType:uint = 0;
		
		public function LayerBitmap(name:String, data:ByteArray)
		{			
			this.name = name;
			Token.read(this, data);	
			animation = ByteArrayUtils.readUTFTiny(data);
		}
	}
}