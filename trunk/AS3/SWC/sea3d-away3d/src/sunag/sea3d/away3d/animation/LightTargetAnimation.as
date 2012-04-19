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
	import away3d.lights.DirectionalLight;
	
	import flash.geom.Vector3D;
	
	import sunag.sea3d.animation.AnimationSequence;
	import sunag.sea3d.animation.InterpolationType;
	import sunag.sea3d.away3d.animation.standards.AnimationKeys;
	
	public class LightTargetAnimation extends LightAnimationBase
	{
		public static const X:int = AnimationKeys.POSITION_X;
		public static const Y:int = AnimationKeys.POSITION_Y;
		public static const Z:int = AnimationKeys.POSITION_Z;
		
		public static const TARGET_X:int = AnimationKeys.TARGET_X;
		public static const TARGET_Y:int = AnimationKeys.TARGET_Y;
		public static const TARGET_Z:int = AnimationKeys.TARGET_Z;
		
		public static const COLOR:int = AnimationKeys.COLOR;
		public static const MULTIPLIER:int = AnimationKeys.MULTIPLIER;
		
		public static const ATTENUATION_START:int = AnimationKeys.ATTENUATION_START;
		public static const ATTENUATION_END:int = AnimationKeys.ATTENUATION_END;
		
		public static const POSITION:int = AnimationKeys.POSITION;
		public static const TARGET:int = AnimationKeys.TARGET;
		
		public var defaultTarget:Vector3D;		
		
		public var actualTarget:Vector3D;
		
		public function LightTargetAnimation(light:DirectionalLight, data:Vector.<AnimationSequence>, defaultPosition:Vector3D, defaultColor:uint, defaultMultiplier:Number, defaultTarget:Vector3D)
		{
			super(light, data, defaultPosition, defaultColor, defaultMultiplier);
			
			this.defaultTarget = defaultTarget;
			
			actualTarget = defaultTarget.clone();
		}
		
		public override function update():void
		{
			for each(var anm:AnimationSequence in _data)
			{			
				switch(anm.key)					
				{
					case POSITION:						
						_light.position = anm.getInterpolationFrame().toVector3D();	
						_light.lookAt(actualTarget);
						break;		
					case TARGET:
						actualTarget = anm.getInterpolationFrame().toVector3D();
						_light.lookAt(actualTarget);
						break;	
					case COLOR:
						_light.color = anm.getInterpolationFrame(InterpolationType.LINEAR_COLOR).x;						
						break;	
					case MULTIPLIER:
						_light.diffuse = anm.getInterpolationFrame().x;
						break;					
					
					case X:
						_light.x = anm.getInterpolationFrame().x;
						break;		
					case Y:
						_light.y = anm.getInterpolationFrame().x;
						break;		
					case Z:
						_light.z = anm.getInterpolationFrame().x;
						break;	
					
					case TARGET_X:
						actualTarget.x = anm.getInterpolationFrame().x;
						_light.lookAt(actualTarget);
						break;		
					case TARGET_Y:
						actualTarget.y = anm.getInterpolationFrame().x;
						_light.lookAt(actualTarget);
						break;		
					case TARGET_Z:
						actualTarget.z = anm.getInterpolationFrame().x;
						_light.lookAt(actualTarget);
						break;
				}
			}			
		}				
	}
}