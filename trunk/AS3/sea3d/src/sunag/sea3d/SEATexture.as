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
	import sunag.sea3d.texture.Layer;
	import sunag.sea3d.texture.LayerBitmap;
	
	public class SEATexture extends SEAObject
	{
		public static const TYPE:String = "texture";
		
		public var layer:Vector.<Layer>; 
		public var lightMap:Vector.<Layer>;
		public var detailMap:Vector.<Layer>;
		
		public function SEATexture(name:String, data:ByteArray)
		{
			super(name, TYPE, data);
			
			layer = new Vector.<Layer>(data.readUnsignedByte());			
			readLayer(data);
			
			lightMap = spliceLayer("LightMap");
			detailMap = spliceLayer("DetailMap");
		}
		
		public function spliceLayer(name:String):Vector.<Layer>
		{
			var layer:Layer;
			var data:Vector.<Layer> = new Vector.<Layer>();
			while(layer = getLayerByName(name))
			{
				this.layer.splice(getLayerIndex(layer),1);
				data.push(layer);
			}
			return data;
		}
		
		public function getLayerIndex(layer:Layer):int
		{
			return this.layer.indexOf(layer);
		}
		
		public function getLayerByName(name:String):Layer
		{
			for(var i:int=0;i<layer.length;i++)
			{
				if (layer[i].name === name)
				{
					return layer[i];
				}
			}
			
			return null;
		}
		
		private function readLayer(data:ByteArray):void
		{
			for(var i:int=0;i<layer.length;i++)
			{
				layer[i] = new Layer(data);				
			}
		}
		
		public function get isRepeat():Boolean
		{
			if (layer.length > 0)
			{		
				if (!layer[0].texture.repeatU && !layer[0].texture.repeatV)
				{
					return false;							
				}
			}
			
			return true;
		}
		
		public function get isTransparent():Boolean
		{
			if (layer.length > 0)
			{		
				if (layer[0].texture.name.substr(-3).toLowerCase() == "png")
				{
					return true;								
				}
			}
			
			return false;
		}
		
		public function get texture():LayerBitmap
		{
			return layer[0].texture;
		}
		
		public function get isMultimap():Boolean
		{
			return layer.length > 1;
		}
	}
}