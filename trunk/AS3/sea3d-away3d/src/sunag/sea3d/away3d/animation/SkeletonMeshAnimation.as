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
	import away3d.animators.SkeletonAnimatorBase;
	import away3d.animators.data.SkeletonAnimationSequence;
	import away3d.animators.data.SkeletonAnimationState;
	import away3d.animators.skeleton.Skeleton;
	import away3d.animators.skeleton.SkeletonClipNodeBase;
	import away3d.animators.skeleton.SkeletonNaryLERPNode;
	import away3d.bounds.BoundingVolumeBase;
	import away3d.entities.Mesh;
	
	import sunag.sea3d.animation.Animation;
	import sunag.sea3d.animation.AnimationSequence;
	import sunag.sea3d.skeleton.animation.BoundsData;

	public class SkeletonMeshAnimation extends Animation
	{
		private var _mesh:Mesh;
				
		public var animation:SkeletonAnimatorBase;
		public var sequence:SkeletonAnimationSequence;
		
		public function SkeletonMeshAnimation(mesh:Mesh, animation:SkeletonAnimatorBase, sequence:SkeletonAnimationSequence)
		{
			super(data, mesh);
			
			_mesh = mesh;			
			
			this.animation = animation;		
			this.sequence = sequence;
		}
		
		public function get mesh():Mesh
		{
			return _mesh;
		}
		
		public override function update():void
		{
			animation.updateAnimation(realTimeElapsed, timeElapsed);
			
			var clip:SkeletonClipNodeBase = ((_mesh.animationState as SkeletonAnimationState).blendTree as SkeletonNaryLERPNode).getInputAt(0) as SkeletonClipNodeBase;
									
			_mesh.x = clip.rootPosition.x * _mesh.scaleX;
			_mesh.y = clip.rootPosition.y * _mesh.scaleZ;
			_mesh.z = clip.rootPosition.z * _mesh.scaleY;
		}				
	}
}