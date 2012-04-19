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
	import away3d.core.math.Quaternion;
	import away3d.entities.Mesh;
	
	import flash.geom.Vector3D;
	
	import sunag.sea3d.animation.Animation;
	import sunag.sea3d.animation.AnimationSequence;
	import sunag.sea3d.animation.InterpolationType;
	import sunag.sea3d.away3d.animation.standards.AnimationKeys;
	import sunag.utils.MathHelper;

	public class MeshAnimation extends Animation
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
		
		public static const POSITION:int = AnimationKeys.POSITION;
		public static const ROTATION:int = AnimationKeys.ROTATION;
		public static const SCALE:int = AnimationKeys.SCALE;
		
		protected var _mesh:Mesh;
		
		public var defaultPosition:Vector3D;
		public var defaultRotation:Vector3D;
		public var defaultScale:Vector3D;
		
		public function MeshAnimation(mesh:Mesh, data:Vector.<AnimationSequence>, defaultPosition:Vector3D, defaultRotation:Vector3D, defaultScale:Vector3D)
		{
			super(data, mesh);
			_mesh = mesh;		
			
			this.defaultPosition = defaultPosition;
			this.defaultRotation = defaultRotation;
			this.defaultScale = defaultScale;		
		}
		
		public function get mesh():Mesh
		{
			return _mesh;
		}
		
		public override function update():void
		{
			for each(var anm:AnimationSequence in _data)
			{			
				switch(anm.key)					
				{						
					case POSITION:						
						_mesh.position = anm.getInterpolationFrame().toVector3D();						
						break;					
					case ROTATION:
						_mesh.rotation = anm.getInterpolationFrame(InterpolationType.LINEAR_EULER).toVector3D();						
						break;										
					case SCALE:
						_mesh.scale = anm.getInterpolationFrame().toVector3D();						
						break;
					
					case X:
						_mesh.x = anm.getInterpolationFrame().x;
						break;		
					case Y:
						_mesh.y = anm.getInterpolationFrame().x;
						break;		
					case Z:
						_mesh.z = anm.getInterpolationFrame().x;
						break;
					
					case ROTATION_X:
						_mesh.rotationX = anm.getInterpolationFrame(InterpolationType.LINEAR_ANGLE).x;
						break;		
					case ROTATION_Y:
						_mesh.rotationY = anm.getInterpolationFrame(InterpolationType.LINEAR_ANGLE).x;
						break;		
					case ROTATION_Z:
						_mesh.rotationZ = anm.getInterpolationFrame(InterpolationType.LINEAR_ANGLE).x;
						break;
					
					case SCALE_X:
						_mesh.x = anm.getInterpolationFrame().x;
						break;		
					case SCALE_Y:
						_mesh.y = anm.getInterpolationFrame().x;
						break;		
					case SCALE_Z:
						_mesh.z = anm.getInterpolationFrame().x;
						break;	
				}
			}			
		}				
	}
}