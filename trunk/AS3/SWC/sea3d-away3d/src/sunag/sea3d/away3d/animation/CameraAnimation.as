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

package sunag.sea3d.away3d.animation
{
	import away3d.cameras.Camera3D;
	
	import flash.geom.Vector3D;
	
	import sunag.sea3d.animation.Animation;
	import sunag.sea3d.animation.AnimationSequence;
	
	public class CameraAnimation extends Animation
	{
		protected var _camera:Camera3D;
		
		public var defaultPosition:Vector3D;
		public var defaultFov:Number;		
		
		public function CameraAnimation(camera:Camera3D, data:Vector.<AnimationSequence>, defaultPosition:Vector3D, defaultFov:Number)
		{
			super(data, camera);
			_camera = camera;	
						
			this.defaultPosition = defaultPosition;
			this.defaultFov = defaultFov;		
		}
		
		public function get camera():Camera3D
		{
			return _camera;
		}
		
		public override function update():void
		{
			throw new Error("Abstract method.");
		}				
	}
}