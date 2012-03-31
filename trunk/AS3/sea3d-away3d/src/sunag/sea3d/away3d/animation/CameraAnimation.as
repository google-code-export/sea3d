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
	import away3d.cameras.lenses.PerspectiveLens;
	
	import flash.geom.Vector3D;
	
	import sunag.sea3d.animation.Animation;
	import sunag.sea3d.animation.AnimationFrame;
	import sunag.sea3d.animation.AnimationSequence;
	import sunag.sea3d.animation.InterpolationType;
	
	public class CameraAnimation extends Animation
	{
		private var _camera:Camera3D;
		
		public var defaultPosition:Vector3D;
		public var defaultRotation:Vector3D;
		public var defaultTarget:Vector3D;
		public var defaultFov:Number;
		
		public var actualTarget:Vector3D;
		
		public function CameraAnimation(camera:Camera3D, data:Vector.<AnimationSequence>, defaultPosition:Vector3D, defaultRotation:Vector3D, defaultTarget:Vector3D, defaultFov:Number)
		{
			super(data, camera);
			_camera = camera;	
						
			this.defaultPosition = defaultPosition;
			this.defaultRotation = defaultRotation;
			this.defaultTarget = defaultTarget;
			this.defaultFov = defaultFov;		
			
			if (defaultTarget) actualTarget = defaultTarget.clone();
		}
		
		public function get camera():Camera3D
		{
			return _camera;
		}
		
		public override function update():void
		{
			super.update();
			
			for each(var anm:AnimationSequence in _data)
			{
				// Standard Time Animation Sequence				
				anm.step(timeElapsed);
				
				var frame:AnimationFrame;		
				
				switch(anm.name)					
				{
					case "position":
						frame = anm.getInterpolationFrame();
						_camera.position = frame.toVector3D();	
						if (actualTarget) _camera.lookAt(actualTarget);
						break;		
					case "rotation":
						frame = anm.getInterpolationFrame(InterpolationType.LINEAR_ANGLE);
						_camera.rotationX = frame.x;
						_camera.rotationY = frame.y;
						_camera.rotationZ = frame.z;
						break;	
					case "target":
						frame = anm.getInterpolationFrame();
						actualTarget = frame.toVector3D();
						_camera.lookAt(actualTarget);
						break;										
					case "fov":
						frame = anm.getInterpolationFrame();
						(_camera.lens as PerspectiveLens).fieldOfView = frame.x;						
						break;
				}
			}			
		}				
	}
}