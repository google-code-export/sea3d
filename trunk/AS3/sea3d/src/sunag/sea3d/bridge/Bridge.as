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

package sunag.sea3d.bridge
{
	import flash.display.BitmapData;
	
	import sunag.sea.SEAObject;
	import sunag.sea3d.SEAAnimation;
	import sunag.sea3d.SEABitmap;
	import sunag.sea3d.SEACameraFree;
	import sunag.sea3d.SEACameraTarget;
	import sunag.sea3d.SEAHelper;
	import sunag.sea3d.SEALightBase;
	import sunag.sea3d.SEALightFree;
	import sunag.sea3d.SEALightPoint;
	import sunag.sea3d.SEALightTarget;
	import sunag.sea3d.SEAMaterial;
	import sunag.sea3d.SEAMesh;
	import sunag.sea3d.SEASkeletonAnimation;
	import sunag.sea3d.SEASkeletonMesh;
	import sunag.sea3d.SEATexture;
	import sunag.sea3d.animation.Animation;
	import sunag.sea3d.animation.AnimationPlayer;

	public class Bridge
	{
		protected var _sea:Object = {};
		protected var _player:AnimationPlayer = new AnimationPlayer();
		
		public function Bridge()
		{
		}
		
		public function dispose():void
		{									
		}
		
		public function get player():AnimationPlayer
		{
			return _player;
		}
		
		protected function addAnimation(anm:Animation, name:String, isSkeleton:Boolean=false):void
		{
			anm.name = name;		
			if (isSkeleton) anm.frameRate = getSEASkeletonAnimation(name).frameRate;
			else anm.frameRate = getSEAAnimation(name).frameRate;
			_player.addAnimation(anm);
		}
		
		public function getSEAObject(ns:String):SEAObject
		{
			return _sea[ns];
		}
		
		private function getSEAObjectNS(ns:String, name:String):*
		{
			return getSEAObject(ns + "/" + name);
		}
		
		public function getSEAAnimation(name:String):SEAAnimation
		{
			return getSEAObjectNS(SEAAnimation.TYPE, name);
		}
		
		public function getSEABitmap(name:String):SEABitmap
		{
			return getSEAObjectNS(SEABitmap.TYPE, name);
		}
		
		public function getSEACameraTarget(name:String):SEACameraTarget
		{
			return getSEAObjectNS(SEACameraTarget.TYPE, name);
		}
		
		public function getSEACameraFree(name:String):SEACameraFree
		{
			return getSEAObjectNS(SEACameraFree.TYPE, name);
		}
		
		public function getSEALightPoint(name:String):SEALightPoint
		{
			return getSEAObjectNS(SEALightPoint.TYPE, name);
		}
		
		public function getSEALightFree(name:String):SEALightFree
		{
			return getSEAObjectNS(SEALightFree.TYPE, name);
		}
		
		public function getSEALightTarget(name:String):SEALightTarget
		{
			return getSEAObjectNS(SEALightTarget.TYPE, name);
		}
		
		public function getSEAMaterial(name:String):SEAMaterial
		{
			return getSEAObjectNS(SEAMaterial.TYPE, name);
		}
		
		public function getSEAMesh(name:String):SEAMesh
		{
			return getSEAObjectNS(SEAMesh.TYPE, name);
		}
		
		public function getSEASkeletonAnimation(name:String):SEASkeletonAnimation
		{
			return getSEAObjectNS(SEASkeletonAnimation.TYPE, name);
		}
		
		public function getSEASkeletonMesh(name:String):SEASkeletonMesh
		{
			return getSEAObjectNS(SEASkeletonMesh.TYPE, name);
		}
		
		public function getSEATexture(name:String):SEATexture
		{
			return getSEAObjectNS(SEATexture.TYPE, name);
		}
		
		public function getSEAHelper(name:String):SEAHelper
		{
			return getSEAObjectNS(SEAHelper.TYPE, name);
		}
		
		public function containsSEAObject(ns:String):Boolean
		{
			return _sea[ns] != null;
		}
		
		public function read(sea:SEAObject):void
		{
			_sea[sea.ns] = sea;
		}
	}
}