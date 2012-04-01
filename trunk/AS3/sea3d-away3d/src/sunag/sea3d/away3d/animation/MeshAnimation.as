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
	import away3d.entities.Mesh;
	
	import flash.geom.Vector3D;
	
	import sunag.sea3d.animation.Animation;
	import sunag.sea3d.animation.AnimationFrame;
	import sunag.sea3d.animation.AnimationSequence;
	import sunag.sea3d.animation.InterpolationType;

	public class MeshAnimation extends Animation
	{
		private var _mesh:Mesh;
		
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
				// Standard Time Animation Sequence				
				anm.step(timeElapsed);
				
				switch(anm.name)					
				{
					case "position":
						_mesh.position = anm.getInterpolationFrame().toVector3D();						
						break;		
					case "rotation":
						_mesh.rotation = anm.getInterpolationFrame(InterpolationType.LINEAR_ANGLE).toVector3D();
						break;					
					case "scale":
						_mesh.scale = anm.getInterpolationFrame().toVector3D();						
						break;
				}
			}			
		}				
	}
}