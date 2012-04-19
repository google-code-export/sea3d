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

package sunag.sea3d.mesh
{
	import flash.geom.Vector3D;

	public class SubMesh
	{
		public var material:String;
		public var vertexIndex:Vector.<uint>;
		public var uvIndex:Vector.<UVIndex>;
		
		// Number of Faces
		public var length:uint;
		
		public function SubMesh(material:String, length:uint=0)
		{
			this.material = material;	
			this.length = length;
			if (length > 0) vertexIndex = new Vector.<uint>(length*3);
		}
	}
}