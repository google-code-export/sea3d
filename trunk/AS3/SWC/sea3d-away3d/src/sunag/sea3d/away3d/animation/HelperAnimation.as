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
	import sunag.sea3d.animation.AnimationSequence;
	import sunag.sea3d.animation.InterpolationType;
	import sunag.sea3d.away3d.animation.standards.AnimationKeys;
	import sunag.sea3d.away3d.entities.Helper;

	public class HelperAnimation extends Animation
	{
		public static const X:int = AnimationKeys.POSITION_X;
		public static const Y:int = AnimationKeys.POSITION_Y;
		public static const Z:int = AnimationKeys.POSITION_Z;
		
		public static const ROTATION_X:int = AnimationKeys.ROTATION_X;
		public static const ROTATION_Y:int = AnimationKeys.ROTATION_Y;
		public static const ROTATION_Z:int = AnimationKeys.ROTATION_Z;
		
		public static const SCALE_X:int = AnimationKeys.SCALE_X;
		public static const SCALE_Y:int = AnimationKeys.SCALE_Y;
		public static const SCALE_Z:int = AnimationKeys.SCALE_Z;
		
		public static const FOV:int = AnimationKeys.FOV;
		
		public static const POSITION:int = AnimationKeys.POSITION;
		public static const ROTATION:int = AnimationKeys.ROTATION;
		public static const SCALE:int = AnimationKeys.SCALE;		
		
		protected var _helper:Helper;
		
		public var defaultPosition:Vector3D;
		public var defaultRotation:Vector3D;
		public var defaultScale:Vector3D;
		
		public function HelperAnimation(helper:Helper, data:Vector.<AnimationSequence>, defaultPosition:Vector3D, defaultRotation:Vector3D, defaultScale:Vector3D)
		{
			super(data, helper);
			
			_helper = helper;		
			
			this.defaultPosition = defaultPosition;
			this.defaultRotation = defaultRotation;
			this.defaultScale = defaultScale;	
		}
		
		public function get helper():Helper
		{
			return _helper;
		}
		
		public override function update():void
		{
			for each(var anm:AnimationSequence in _data)
			{			
				switch(anm.key)					
				{						
					case POSITION:
						_helper.position = anm.getInterpolationFrame().toVector3D();						
						break;
					case ROTATION:
						_helper.rotation = anm.getInterpolationFrame(InterpolationType.LINEAR_EULER).toVector3D();
						break;	
					case SCALE:
						_helper.scale = anm.getInterpolationFrame().toVector3D();						
						break;
					
					case X:
						_helper.position.x = anm.getInterpolationFrame().x;
						break;		
					case Y:
						_helper.position.y = anm.getInterpolationFrame().x;
						break;		
					case Z:
						_helper.position.z = anm.getInterpolationFrame().x;
						break;
					
					case ROTATION_X:
						_helper.rotation.x = anm.getInterpolationFrame().x;
						break;		
					case ROTATION_Y:
						_helper.rotation.y = anm.getInterpolationFrame().x;
						break;		
					case ROTATION_Z:
						_helper.rotation.z = anm.getInterpolationFrame().x;
						break;	
					
					case SCALE_X:
						_helper.scale.x = anm.getInterpolationFrame().x;
						break;		
					case SCALE_Y:
						_helper.scale.y = anm.getInterpolationFrame().x;
						break;		
					case SCALE_Z:
						_helper.scale.z = anm.getInterpolationFrame().x;
						break;							
				}
			}			
		}				
	}
}