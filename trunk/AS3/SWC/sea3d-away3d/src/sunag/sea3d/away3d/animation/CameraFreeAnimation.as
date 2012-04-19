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
	
	import sunag.sea3d.animation.AnimationSequence;
	import sunag.sea3d.animation.InterpolationType;
	import sunag.sea3d.away3d.animation.standards.AnimationKeys;
	
	public class CameraFreeAnimation extends CameraAnimation
	{
		public static const X:int = AnimationKeys.POSITION_X;
		public static const Y:int = AnimationKeys.POSITION_Y;
		public static const Z:int = AnimationKeys.POSITION_Z;
		
		public static const ROTATION_X:int = AnimationKeys.ROTATION_X;
		public static const ROTATION_Y:int = AnimationKeys.ROTATION_Y;
		public static const ROTATION_Z:int = AnimationKeys.ROTATION_Z;
		
		public static const FOV:int = AnimationKeys.FOV;
		
		public static const POSITION:int = AnimationKeys.POSITION;
		public static const ROTATION:int = AnimationKeys.ROTATION;
		
		public var defaultRotation:Vector3D;
				
		public function CameraFreeAnimation(camera:Camera3D, data:Vector.<AnimationSequence>, defaultPosition:Vector3D, defaultRotation:Vector3D, defaultFov:Number)
		{
			super(camera, data, defaultPosition, defaultFov);	
			
			this.defaultRotation = defaultRotation;		
		}
		
		public override function update():void
		{
			for each(var anm:AnimationSequence in _data)
			{								
				switch(anm.key)					
				{
					case POSITION:						
						_camera.position = anm.getInterpolationFrame().toVector3D();
						break;							
					case ROTATION:
						_camera.rotation = anm.getInterpolationFrame(InterpolationType.LINEAR_EULER).toVector3D();						
						break;	
					case FOV:						
						(_camera.lens as PerspectiveLens).fieldOfView = anm.getInterpolationFrame().x;						
						break;
					
					case X:
						_camera.x = anm.getInterpolationFrame().x;
						break;		
					case Y:
						_camera.y = anm.getInterpolationFrame().x;
						break;		
					case Z:
						_camera.z = anm.getInterpolationFrame().x;
						break;		
					
					case ROTATION_X:
						_camera.rotationX = anm.getInterpolationFrame(InterpolationType.LINEAR_ANGLE).x;
						break;		
					case ROTATION_Y:
						_camera.rotationY = anm.getInterpolationFrame(InterpolationType.LINEAR_ANGLE).x;
						break;		
					case ROTATION_Z:
						_camera.rotationZ = anm.getInterpolationFrame(InterpolationType.LINEAR_ANGLE).x;
						break;	
				}
			}			
		}				
	}
}