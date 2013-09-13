/*
*
* Copyright (c) 2013 Sunag Entertainment
*
* Permission is hereby granted, free of charge, to any person obtaining a copy of
* this software and associated documentation files (the "Software"), to deal in
* the Software without restriction, including without limitation the rights to
* use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
* the Software, and to permit persons to whom the Software is furnished to do so,
* subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
* FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
* COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
* IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
* CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*
*/

package sunag.sea3d.objects
{
	import flash.utils.ByteArray;
	
	import sunag.sea3d.SEA;
	import sunag.utils.ByteArrayUtils;
	
	public class SEAGeometry extends SEAGeometryBase 
	{
		public static const TYPE:String = "geo";				
								
		public var vertex:Vector.<Number>;
		public var indexes:Array;
		
		public var uv:Array;		
		public var normal:Vector.<Number>;
		public var tangent:Vector.<Number>;
		public var color:Vector.<Number>;
		
		public var joint:Vector.<Number>;
		public var weight:Vector.<Number>;
		
		public function SEAGeometry(name:String, sea:SEA)
		{
			super(name, TYPE, sea);
		}			
		
		override public function load():void
		{
			readGeometryBase(data);
			
			var i:int, j:int, len:uint = numVertex*3, vec:Vector.<Number>;												
			
			// NORMAL
			if (attrib & 4)
			{
				normal = new Vector.<Number>(len);
				
				i = 0;
				while (i < len) 			
					normal[i++] = data.readFloat();	
			}
			
			// TANGENT
			if (attrib & 8)
			{
				tangent = new Vector.<Number>(len);
				
				i = 0;
				while (i < len) 			
					tangent[i++] = data.readFloat();
			}
			
			// UVS
			if (attrib & 32)
			{				
				uv = [];
				uv.length = data.readUnsignedByte();
				
				i = 0;
				while ( i < uv.length )
				{
					// UV_VERTEX
					uv[i++] = vec = new Vector.<Number>(numVertex * 2);									
					j = 0; 
					while(j < vec.length) 
						vec[j++] = data.readFloat();		
				}
			}						
			
			// JOINT_INDEXES | WEIGHTS
			if (attrib & 64)
			{
				jointPerVertex = data.readUnsignedByte();
				
				var jntLen:uint = numVertex * jointPerVertex;
				
				joint = new Vector.<Number>(jntLen);
				weight = new Vector.<Number>(jntLen);
				
				i = 0;
				while (i < jntLen) 		
					joint[i++] = data.readUnsignedShort() * 3;
				
				i = 0;
				while (i < jntLen) 		
					weight[i++] = data.readFloat(); 
			}						
			
			// VERTEX_COLOR
			if (attrib & 128)
			{
				color = new Vector.<Number>(len);
				
				i = 0;
				while (i < len)
					color[i++] = data.readUnsignedByte() / 255.0;				
			}
				
			
			// VERTEX
			vertex = new Vector.<Number>(len);	
			i = 0; 
			while(i < vertex.length) 
				vertex[i++] = data.readFloat();
			
			indexes = [];
			indexes.length = data.readUnsignedByte();			
			
			// INDEXES
			for (i=0;i<indexes.length;i++)
			{
				var vecUint:Vector.<uint>;				
				
				indexes[i] = vecUint = new Vector.<uint>(readUint() * 3);	
				j = 0; 
				while(j < vecUint.length) 
					vecUint[j++] = readUint();			
			}			
		}			
	}
}
