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
	import away3d.animators.SmoothSkeletonAnimator;
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
		private var _frameRate:uint = 30;		
		private var _length:uint;
		
		public var animation:SmoothSkeletonAnimator;
		public var sequence:SkeletonAnimationSequence;
		
		public function SkeletonMeshAnimation(mesh:Mesh, animation:SmoothSkeletonAnimator, sequence:SkeletonAnimationSequence)
		{
			super(null, mesh);
			
			_mesh = mesh;	
			
			this.animation = animation;		
			this.sequence = sequence;
			
			_length = Math.round(sequence.duration / (1000 / frameRate));
		}
		
		public override function get position():Number
		{
			return animation.lerpNode.time % 1;
		}
		
		public override function set position(value:Number):void
		{
			animation.lerpNode.time = value;
		}
		
		public override function get length():uint
		{			
			return _length;
		}
		
		public override function set frameRate(value:uint):void
		{
			_frameRate = value;
		}
		
		public override function get frameRate():uint
		{
			return _frameRate;
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