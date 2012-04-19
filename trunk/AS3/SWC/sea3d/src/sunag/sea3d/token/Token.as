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

package sunag.sea3d.token
{
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	
	import sunag.utils.ByteArrayUtils;

	public class Token
	{
		public static const BYTE:int = 0;
		public static const BOOLEAN:int = 1;
		public static const FLOAT:int = 3;
		public static const STRING:int = 10;
		public static const RGB:int = 20
		public static const VECTOR3D:int = 30;
		
		public var value:*;		
		public var token:int;
		
		public function Token(token:int, data:ByteArray)
		{
			this.token = token;
			
			switch(token)
			{
				case BYTE:
					value = data.readUnsignedByte();
					break;
				case BOOLEAN:
					value = data.readBoolean();
					break;
				case FLOAT:
					value = data.readFloat();
					break;
				case STRING:
					value = ByteArrayUtils.readUTFTiny(data);
					break;
				case RGB:
					value = ByteArrayUtils.readColor(data);
					break;
				case VECTOR3D:
					value = ByteArrayUtils.readVector3D(data);
					break;
				default:
					throw new Error("Invalid token.");
			}
		}
						
		public function toVector():Vector.<Number>
		{
			var vec:Vector.<Number>;
			
			switch(token)
			{
				case BOOLEAN:					
					vec = new Vector.<Number>(1, true);
					vec[0] = Number(value);0
					break;
				
				case BYTE:
				case FLOAT:
				case RGB:
					vec = new Vector.<Number>(1, true);
					vec[0] = value;
					break;
				
				case VECTOR3D:
					vec = new Vector.<Number>(3, true);
					vec[0] = value.x;
					vec[1] = value.y;
					vec[2] = value.z;
					break;
			}
			
			return vec;
		}
		
		public static function read(self:*, data:ByteArray):void 									
		{
			var length:int = data.readUnsignedByte();
			
			for(var i:int=0;i<length;i++)
			{
				var property:String = ByteArrayUtils.readUTFTiny(data);
				var value:* = new Token(data.readUnsignedByte(), data).value;
				
				self[property] = value;
			}
		}
		
		public static function length(token:int):int
		{
			var count:int;
			
			switch(token)
			{
				case BOOLEAN:
				case BYTE:
				case FLOAT:
				case RGB:
					return 1
				case VECTOR3D:
					return 3
				default:
					throw new Error("Invalid token.");
			}
			
			return count;
		}
	}
}