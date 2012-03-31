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
	import flash.geom.Vector3D;
	
	import sunag.sea3d.animation.Animation;
	import sunag.sea3d.animation.AnimationFrame;
	import sunag.sea3d.animation.AnimationSequence;
	import sunag.sea3d.animation.InterpolationType;
	import sunag.sea3d.away3d.entities.Helper;

	public class HelperAnimation extends Animation
	{
		private var _helper:Helper;
		
		public var defaultPosition:Vector3D;
		public var defaultRotation:Vector3D;
		public var defaultScale:Vector3D;
		public var defaultColor:int;
		
		public function HelperAnimation(helper:Helper, data:Vector.<AnimationSequence>, defaultPosition:Vector3D, defaultRotation:Vector3D, defaultScale:Vector3D, defaultColor:int)
		{
			super(data, helper);
			
			_helper = helper;		
			
			this.defaultPosition = defaultPosition;
			this.defaultRotation = defaultRotation;
			this.defaultScale = defaultScale;	
			this.defaultColor = defaultColor;
		}
		
		public function get helper():Helper
		{
			return _helper;
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
						_helper.position = anm.getInterpolationFrame().toVector3D();
						break;		
					case "rotation":
						_helper.rotation = anm.getInterpolationFrame(InterpolationType.LINEAR_ANGLE).toVector3D();
						break;					
					case "scale":
						_helper.scale = anm.getInterpolationFrame().toVector3D();
						break;
					case "color":
						_helper.color = anm.getInterpolationFrame(InterpolationType.LINEAR_COLOR).x;
						break;
				}
			}			
		}				
	}
}