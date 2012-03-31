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
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	
	import sunag.sea.SEAObject;
	import sunag.sea3d.mesh.SubMesh;
	import sunag.sea3d.mesh.UVData;
	import sunag.sea3d.mesh.UVIndex;
	import sunag.sea3d.token.Token;
	import sunag.utils.ByteArrayUtils;

	public class SEAMesh extends SEAObject 
	{		
		public static const TYPE:String = "mesh";
		
		public var animation:String;
		public var position:Vector3D;
		public var rotation:Vector3D;
		public var scale:Vector3D;
		public var instance:String;
		public var vertex:Vector.<Number>;
		public var subMesh:Vector.<SubMesh>;
		public var uv:Vector.<UVData>;
		public var vertexColor:Vector.<int>;
		public var vertexCount:int;
		public var color:int;
		public var sameMaterial:Boolean = false;
		public var castShadows:Boolean = true;
		
		public function SEAMesh(name:String, data:ByteArray)
		{
			super(name, TYPE, data);
			
			var i:int, j:int;						
			
			Token.read(this, data);
			
			color = ByteArrayUtils.readColor(data);
			animation = ByteArrayUtils.readUTFTiny(data);
			
			position = ByteArrayUtils.readVector3D(data);
			rotation = ByteArrayUtils.readVector3D(data);
			scale = ByteArrayUtils.readVector3D(data);
			
			instance = ByteArrayUtils.readUTFTiny(data);
			
			if (instance.length == 0)
			{
				vertexCount = data.readUnsignedShort();
				vertex = new Vector.<Number>(vertexCount * 3);
				subMesh = new Vector.<SubMesh>(data.readUnsignedByte());
				
				for (i<0;i<subMesh.length;i++) 
				{
					subMesh[i] = new SubMesh(ByteArrayUtils.readUTFTiny(data), data.readUnsignedShort() * 3);					
				}
				
				uv = new Vector.<UVData>(data.readUnsignedByte());
				
				for (i=0;i<uv.length;i++) 
				{
					uv[i] = new UVData(data.readUnsignedShort() * 2);
				}
				
				if (data.readBoolean())
				{
					vertexColor = new Vector.<int>(vertexCount);
				}								
				
				if (vertexColor)
				{
					for(i<0;i<vertexColor.length;i++) 
					{
						vertexColor[i] = ByteArrayUtils.readColor(data);
					}
				}
				
				for (i=0;i<vertex.length;i+=3) 
				{
					vertex[i]   = data.readFloat();
					vertex[i+1] = data.readFloat();
					vertex[i+2] = data.readFloat();
				}
				
				for (i=0;i<subMesh.length;i++) 
				{
					var thisSubMesh:SubMesh = subMesh[i];
					thisSubMesh.uvIndex = new Vector.<UVIndex>(this.uv.length);
					
					for (j=0;j<thisSubMesh.uvIndex.length;j++) 
					{
						thisSubMesh.uvIndex[j] = new UVIndex(thisSubMesh.vertexIndex.length);
					}
					
					for (j=0;j<thisSubMesh.vertexIndex.length;j+=3) 
					{
						thisSubMesh.vertexIndex[j]   = data.readUnsignedShort();
						thisSubMesh.vertexIndex[j+1] = data.readUnsignedShort();
						thisSubMesh.vertexIndex[j+2] = data.readUnsignedShort();
						
						for (var ch:int=0;ch<thisSubMesh.uvIndex.length;ch++) 
						{
							thisSubMesh.uvIndex[ch].data[j]   = data.readUnsignedShort();
							thisSubMesh.uvIndex[ch].data[j+1] = data.readUnsignedShort();
							thisSubMesh.uvIndex[ch].data[j+2] = data.readUnsignedShort();
						}
					}
				}
				
				for (i=0;i<uv.length;i++) 
				{
					var thisUVData:UVData = uv[i];
					
					for (j=0;j<thisUVData.data.length;j+=2) 
					{
						thisUVData.data[j]   = data.readFloat();
						thisUVData.data[j+1] = data.readFloat();
					}
				}
			} 
			else 
			{
				sameMaterial = data.readBoolean();
				
				if (!sameMaterial)
				{
					subMesh = new Vector.<SubMesh>(data.readUnsignedByte());
					
					for (i=0;i<subMesh.length;i++) 
					{
						subMesh[i] = new SubMesh(ByteArrayUtils.readUTFTiny(data));
					}
				}
			}
		}
	}
}
