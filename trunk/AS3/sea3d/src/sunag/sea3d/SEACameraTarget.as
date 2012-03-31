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
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	
	import sunag.sea.SEAObject;
	import sunag.utils.ByteArrayUtils;
	
	public class SEACameraTarget extends SEAObject
	{
		public static const TYPE:String = "camera-target";
		
		public var animation:String;
		public var position:Vector3D;
		public var target:Vector3D;
		public var fov:Number;
		
		public function SEACameraTarget(name:String, data:ByteArray)
		{
			super(name, TYPE, data);
			
			animation = ByteArrayUtils.readUTFTiny(data);
			position = ByteArrayUtils.readVector3D(data);
			target = ByteArrayUtils.readVector3D(data);
			fov = data.readFloat();			
		}
	}
}