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
	import sunag.sea3d.animation.AnimationSequence;
	import sunag.sea3d.token.Token;
	import sunag.utils.ByteArrayUtils;

	public class SEAAnimation extends SEAObject
	{
		public static const TYPE:String = "animation";
		
		public var frameRate:int;
		public var length:int;
		
		public var sequence:Vector.<AnimationSequence>;
		public var sequenceCount:int 
		
		public function SEAAnimation(name:String, data:ByteArray, sea:SEA3D)
		{
			super(name, TYPE, data, sea);
			
			var i:int, j:int;
			
			
			// Head
			
			frameRate = data.readUnsignedByte();
			length = data.readUnsignedShort();
			
			sequence = new Vector.<AnimationSequence>(data.readUnsignedByte());						
			
			for(i=0;i<sequence.length;i++)
			{
				var key:int = data.readUnsignedByte();
				var type:uint = data.readUnsignedByte();
				sequence[i] = new AnimationSequence(frameRate, Token.length(type), length, key, type);
			}
			
			
			// Body
						
			for(i=0;i<length;i++)
			{
				for(j=0;j<sequence.length;j++)
				{									
					var seq:AnimationSequence = sequence[j];
					var vec:Vector.<Number> = new Token(seq.type, data).toVector();
					for(var k:int=0;k<vec.length;k++)
					{
						seq.data[(i*seq.count)+k] = vec[k];
					}
				}
			}
		}
	}
}