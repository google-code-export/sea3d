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

package sunag.sea3d.away3d.entities
{
	import flash.geom.Vector3D;

	public class Helper
	{
		public var position:Vector3D;
		public var rotation:Vector3D;
		public var scale:Vector3D;
		public var color:int;
	
		public var name:String;
		
		public function Helper(position:Vector3D, rotation:Vector3D, scale:Vector3D, color:int)
		{
			this.position = position;
			this.rotation = rotation;
			this.scale = scale;
			this.color = color;
		}
	}
}