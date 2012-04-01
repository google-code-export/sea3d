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
	import sunag.sea3d.animation.AnimationFrame;
	import sunag.sea3d.animation.AnimationSequence;
	import sunag.sea3d.animation.InterpolationType;
	
	public class TextureAnimation extends Animation
	{
		private var _subMesh:SubMesh;
		
		public var offsetU:Number;
		public var offsetV:Number;
		public var scaleU:Number;
		public var scaleV:Number;
		public var rotation:Number;
		
		public function TextureAnimation(subMesh:SubMesh, data:Vector.<AnimationSequence>, offsetU:Number, offsetV:Number, scaleU:Number, scaleV:Number, rotation:Number)
		{
			super(data, subMesh);
			
			_subMesh = subMesh;
			
			this.offsetU = offsetU;
			this.offsetV = offsetV;
			this.scaleU = scaleU;
			this.scaleV = scaleV;
			this.rotation = rotation;
		}
		
		public function get subMesh():SubMesh
		{
			return _subMesh;
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
					case "offsetU":
						frame = anm.getInterpolationFrame();						
						_subMesh.offsetU = frame.x;					
						break;					
					case "offsetV":
						frame = anm.getInterpolationFrame();
						_subMesh.offsetV = frame.x;
						break;
					case "scaleU":
						frame = anm.getInterpolationFrame();						
						_subMesh.scaleU = frame.x;					
						break;					
					case "scaleU":
						frame = anm.getInterpolationFrame();
						_subMesh.scaleV = frame.x;
						break;
					case "rotation":
						frame = anm.getInterpolationFrame(InterpolationType.LINEAR_ANGLE);
						_subMesh.uvRotation = frame.x * MathConsts.DEGREES_TO_RADIANS;				
						break;
				}
			}			
		}				
	}
}