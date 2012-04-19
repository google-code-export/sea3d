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
	import away3d.core.base.SubMesh;
	import away3d.core.math.MathConsts;
	
	import sunag.sea3d.animation.Animation;
	import sunag.sea3d.animation.AnimationSequence;
	import sunag.sea3d.animation.InterpolationType;
	import sunag.sea3d.away3d.animation.standards.AnimationKeys;
	
	public class TextureAnimation extends Animation
	{
		public static const U:int = AnimationKeys.OFFSET_U;
		public static const V:int = AnimationKeys.OFFSET_V;
		public static const SCALE_U:int = AnimationKeys.SCALE_U;
		public static const SCALE_V:int = AnimationKeys.SCALE_V;
		public static const ROTATION:int = AnimationKeys.ROTATION_UV;		
		
		protected var _subMesh:SubMesh;
		
		public var defaultU:Number;
		public var defaultV:Number;
		public var defaultScaleU:Number;
		public var defaultScaleV:Number;
		public var defaultRotation:Number;
		
		public function TextureAnimation(subMesh:SubMesh, data:Vector.<AnimationSequence>, defaulU:Number, defaultV:Number, defaultScaleU:Number, defaultScaleV:Number, defaultRotation:Number)
		{
			super(data, subMesh);
			
			_subMesh = subMesh;
			
			this.defaultU = defaultU;
			this.defaultV = defaultU;
			this.defaultScaleU = defaultScaleU;
			this.defaultScaleV = defaultScaleV;
			this.defaultRotation = defaultRotation;
		}
		
		public function get subMesh():SubMesh
		{
			return _subMesh;
		}
		
		public override function update():void
		{
			for each(var anm:AnimationSequence in _data)
			{			
				switch(anm.key)					
				{					
					case U:					
						_subMesh.offsetU = anm.getInterpolationFrame(InterpolationType.LINEAR_ROUND).x;					
						break;					
					case V:
						_subMesh.offsetV = anm.getInterpolationFrame(InterpolationType.LINEAR_ROUND).x;
						break;
					case SCALE_U:					
						_subMesh.scaleU = anm.getInterpolationFrame().x;					
						break;					
					case SCALE_V:
						_subMesh.scaleV = anm.getInterpolationFrame().x;
						break;
					case ROTATION:
						_subMesh.uvRotation = anm.getInterpolationFrame(InterpolationType.LINEAR_ANGLE).x * MathConsts.DEGREES_TO_RADIANS;				
						break;
				}
			}			
		}				
	}
}