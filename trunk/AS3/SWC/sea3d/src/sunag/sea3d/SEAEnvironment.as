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
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import sunag.sea.SEAObject;
	import sunag.utils.ByteArrayUtils;
	import sunag.utils.MathHelper;
	
	public class SEAEnvironment extends SEAObject
	{
		public static const TYPE:String = "environment";
		
		public var texture:String;
		
		public function SEAEnvironment(name:String, data:ByteArray, sea:SEA3D)
		{
			super(name, TYPE, data, sea);
			texture = ByteArrayUtils.readUTFTiny(data);
		}
	}
}