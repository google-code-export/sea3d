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

package sunag.sea3d.animation
{
	import flash.geom.Point;
	import flash.geom.Vector3D;

	public class AnimationFrame
	{
		public var data:Vector.<Number>;
		
		public function AnimationFrame(data:Vector.<Number>)
		{
			this.data = data;
		}
				
		public function clone():AnimationFrame
		{
			return new AnimationFrame(data.concat());
		}
		
		public function toVector2D():Point
		{
			return new Point(x, y);
		}
		
		public function toVector3D():Vector3D
		{
			return new Vector3D(x,y,z);
		}
		
		public function toVector4D():Vector3D
		{
			return new Vector3D(x,y,z,w);
		}
		
		public function set x(value:Number):void { data[0] = value; }
		public function get x():Number { return data[0] }
		
		public function set y(value:Number):void { data[1] = value; }
		public function get y():Number { return data[1] }
		
		public function set z(value:Number):void { data[2] = value; }
		public function get z():Number { return data[2] }
		
		public function set w(value:Number):void { data[3] = value; }
		public function get w():Number { return data[3] }
	}
}