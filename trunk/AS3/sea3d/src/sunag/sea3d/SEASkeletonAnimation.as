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

package sunag.sea3d
{
	import flash.utils.ByteArray;
	
	import sunag.sea.SEAObject;
	import sunag.sea3d.skeleton.animation.BaseFrameData;
	import sunag.sea3d.skeleton.animation.BoundsData;
	import sunag.sea3d.skeleton.animation.FrameData;
	import sunag.sea3d.skeleton.animation.HierarchyData;
	import sunag.utils.ByteArrayUtils;
	
	public class SEASkeletonAnimation extends SEAObject
	{
		public static const TYPE:String = "skeleton-animation";
		
		public var frameRate : int;
		public var numFrames : int;
		public var numJoints : int;
		public var numAnimatedComponents : int;
		
		public var hierarchy : Vector.<HierarchyData>;
		public var bounds : Vector.<BoundsData>;
		public var frameData : Vector.<FrameData>;
		public var baseFrameData : Vector.<BaseFrameData>;
		
		public function SEASkeletonAnimation(name:String, data:ByteArray)
		{
			super(name, TYPE, data);
			
			readHead(data);
			
			readHierarchy(data);
			readBounds(data);
			readBaseFrame(data);
			readFrames(data);
		}
		
		private function readHead(data:ByteArray):void
		{
			frameRate = data.readUnsignedByte();
			numFrames = data.readUnsignedShort();
			numJoints = data.readUnsignedShort();
			numAnimatedComponents = data.readUnsignedShort();
			
			bounds = new Vector.<BoundsData>(numFrames, true);
			frameData = new Vector.<FrameData>(numFrames, true);
			hierarchy = new Vector.<HierarchyData>(numJoints, true);
			baseFrameData = new Vector.<BaseFrameData>(numJoints, true);						
		}
		
		private function readHierarchy(data:ByteArray):void
		{
			for(var i:int=0;i<numJoints;i++)
			{
				var hiearchy:HierarchyData = hierarchy[i] = new HierarchyData();
				hiearchy.name = ByteArrayUtils.readUTFTiny(data);
				hiearchy.parentIndex = data.readUnsignedShort() - 1;
				hiearchy.flags = data.readUnsignedShort();
				hiearchy.startIndex = data.readUnsignedShort();
			}			
		}
		
		private function readBounds(data:ByteArray):void
		{
			for(var i:int=0;i<numFrames;i++)
			{
				var bounds:BoundsData = bounds[i] = new BoundsData();
				bounds.min = ByteArrayUtils.readVector3D(data);
				bounds.max = ByteArrayUtils.readVector3D(data);
			}
		}
		
		private function readBaseFrame(data:ByteArray):void
		{
			for(var i:int=0;i<numJoints;i++)
			{
				var baseFrame:BaseFrameData = baseFrameData[i] = new BaseFrameData();
				baseFrame.position = ByteArrayUtils.readVector3D(data);
				baseFrame.orientation = ByteArrayUtils.readQuaternion(data);
			}
		}
		
		private function readFrames(data:ByteArray):void
		{
			for(var i:int=0;i<numFrames;i++)
			{
				var frame:FrameData = frameData[i] = new FrameData();
				
				frame.components = new Vector.<Number>(numAnimatedComponents, true);
				
				for (var j : int = 0; j < numAnimatedComponents; ++j) {
					frame.components[j] = data.readFloat();
				}				
			}
		}
	}
}