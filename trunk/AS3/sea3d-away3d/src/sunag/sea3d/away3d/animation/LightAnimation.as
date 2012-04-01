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
	import away3d.lights.LightBase;
	
	import flash.geom.Vector3D;
	
	import sunag.sea3d.animation.Animation;
	import sunag.sea3d.animation.AnimationFrame;
	import sunag.sea3d.animation.AnimationSequence;
	import sunag.sea3d.animation.InterpolationType;
	
	public class LightAnimation extends Animation
	{
		private var _light:LightBase;
		
		public var defaultPosition:Vector3D;
		public var defaultRotation:Vector3D;
		public var defaultTarget:Vector3D;		
		public var color:uint;
		public var multiplier:Number;
		
		public var actualTarget:Vector3D;
		
		public function LightAnimation(light:LightBase, data:Vector.<AnimationSequence>, defaultPosition:Vector3D, defaultRotation:Vector3D, defaultTarget:Vector3D, color:uint, multiplier:Number)
		{
			super(data, light);
			_light = light;	
			
			this.defaultPosition = defaultPosition;
			this.defaultRotation = defaultRotation;
			this.defaultTarget = defaultTarget;
			this.color = color;	
			this.multiplier = multiplier;
			
			if (defaultTarget) actualTarget = defaultTarget.clone();
		}
		
		public function get light():LightBase
		{
			return _light;
		}
		
		public override function update():void
		{
			for each(var anm:AnimationSequence in _data)
			{
				// Standard Time Animation Sequence				
				anm.step(timeElapsed);
				
				var frame:AnimationFrame;	
				
				switch(anm.name)					
				{
					case "position":
						frame = anm.getInterpolationFrame();
						_light.position = frame.toVector3D();	
						if (actualTarget) _light.lookAt(actualTarget);
						break;		
					case "rotation":
						frame = anm.getInterpolationFrame(InterpolationType.LINEAR_ANGLE);
						_light.rotationX = frame.x;
						_light.rotationY = frame.y;
						_light.rotationZ = frame.z;
						break;	
					case "target":
						frame = anm.getInterpolationFrame();
						actualTarget = frame.toVector3D();
						_light.lookAt(actualTarget);
						break;					
					case "color":
						frame = anm.getInterpolationFrame(InterpolationType.LINEAR_COLOR);
						_light.color = frame.x;						
						break;	
					case "multiplier":
						frame = anm.getInterpolationFrame();
						_light.diffuse = frame.x;
						_light.ambient = 1;
						break;
				}
			}			
		}				
	}
}