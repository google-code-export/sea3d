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
	import sunag.sea3d.skeleton.mesh.JointData;
	import sunag.sea3d.skeleton.mesh.MeshData;
	import sunag.sea3d.skeleton.mesh.VertexData;
	import sunag.sea3d.skeleton.mesh.WeightData;
	import sunag.sea3d.token.Token;
	import sunag.utils.ByteArrayUtils;
	
	public class SEASkeletonMesh extends SEAObject
	{
		public static const TYPE:String = "skeleton-mesh";
		
		public var animation:String;
		
		public var numJoints:int;
		public var numMeshes:int;
		
		public var maxJointCount:int;
		
		public var jointData:Vector.<JointData>;
		public var meshData:Vector.<MeshData>;
		
		public var color:int;
		public var castShadows:Boolean = true;
		
		public function SEASkeletonMesh(name:String, data:ByteArray)
		{
			super(name, TYPE, data);
			
			Token.read(this, data);
			
			color = ByteArrayUtils.readColor(data);
			animation = ByteArrayUtils.readUTFTiny(data);
			
			readHead(data);
			
			readJoints(data);	
			readMesh(data);
		}
		
		private function readHead(data:ByteArray):void
		{
			numJoints = data.readUnsignedShort();
			numMeshes = data.readUnsignedByte();
			
			jointData = new Vector.<JointData>(numJoints);
			meshData = new Vector.<MeshData>(numMeshes);	
		}
		
		private function readJoints(data:ByteArray):void
		{
			for(var i:int=0;i<numJoints;i++)
			{
				var joint:JointData = jointData[i] = new JointData();
				joint.name = ByteArrayUtils.readUTFTiny(data);
				joint.parentIndex = data.readUnsignedShort() - 1;	
				joint.position = ByteArrayUtils.readVector3D(data);
				joint.orientation = ByteArrayUtils.readQuaternion(data);
			}
		}
		
		private function readMesh(data:ByteArray):void
		{			
			for(var i:int=0;i<numMeshes;i++)
			{
				meshData[i] = readMeshData(data);
			}
		}
		
		private function readMeshData(data:ByteArray):MeshData
		{
			var i:int, mesh:MeshData = new MeshData();		
			
			mesh.material = ByteArrayUtils.readUTFTiny(data);
			mesh.vertexData = new Vector.<VertexData>(data.readUnsignedShort());
			mesh.indices = new Vector.<uint>(data.readUnsignedShort() * 3);
			mesh.weight = new Vector.<WeightData>(data.readUnsignedShort());
			
			for (i=0;i<mesh.vertexData.length;i++)
			{
				var vertex:VertexData = mesh.vertexData[i] = new VertexData();
				vertex.index = i;
				vertex.u = data.readFloat();
				vertex.v = data.readFloat();
				vertex.start = data.readUnsignedShort();
				vertex.count = data.readUnsignedShort();
				if (vertex.count > maxJointCount) maxJointCount = vertex.count;
			}
			
			for (i=0;i<mesh.indices.length;i+=3)
			{
				mesh.indices[i]   = data.readUnsignedShort();
				mesh.indices[i+1] = data.readUnsignedShort();
				mesh.indices[i+2] = data.readUnsignedShort();				
			}
			
			for (i=0;i<mesh.weight.length;i++)
			{
				var weight:WeightData = mesh.weight[i] = new WeightData();
				weight.joint = data.readUnsignedShort();
				weight.bias = data.readFloat();
				weight.pos = ByteArrayUtils.readVector3D(data);
			}
			
			return mesh;
		}
	}
}