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

package sunag.ui.away3d
{
	import away3d.textures.BitmapTexture;
	
	import flash.display.Stage;
	import flash.events.Event;
	
	import ru.inspirit.asfeat.detect.ASFEATReference;
	import ru.inspirit.asfeat.event.ASFEATCalibrationEvent;
	import ru.inspirit.asfeat.event.ASFEATDetectionEvent;
	
	import sunag.ui.ArgumentReality;

	public class ArgumentRealityAway3D extends ArgumentReality
	{
		public var lens:Away3D4Lens;
		public var container:Away3DContainer;
		public var texture:BitmapTexture;
		
		private var _completed:Boolean = false;
		
		public function ArgumentRealityAway3D(stage:Stage)
		{
			super(stage);
		}
		
		override public function init():void
		{
			super.init();									
			texture = new BitmapTexture(cameraBitmapData);
		}
		
		override protected function onAsfeatInit(e:Event):void
		{
			super.onAsfeatInit(e);
			lens = new Away3D4Lens(intrinsic, size, size, 1.0);
			container = new Away3DContainer();
			_completed = true;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		override public function update():void
		{
			super.update();
			texture.invalidateContent();
		}
		
		public function get completed():Boolean
		{
			return _completed;
		}
		
		override protected function onModelDetected(e:ASFEATDetectionEvent):void
		{
			super.onModelDetected(e);
			
			var refList:Vector.<ASFEATReference> = e.detectedReferences;
			var ref:ASFEATReference;
			var n:int = e.detectedReferencesCount;
			var state:String;
			
			if (refList.length > 0)
			{
				ref = refList[0];
				state = ref.detectType;
				
				container.setTransform(ref.rotationMatrix, ref.translationVector, ref.poseError);
				
				/*
				if(state == '_detect')
				{
					trace( '\nmathed: ' + ref.matchedPointsCount );
				}
				
				trace( '\nfound id: ' + ref.id );
				*/
			}
			
			//trace( '\ncalib fx/fy: ' + [_intrinsic.fx, _intrinsic.fy] );
		}
		
		override protected function onCalibDone(e:ASFEATCalibrationEvent):void
		{
			super.onCalibDone(e);
			lens.updateIntrinsic(width, height, 1.0);
		}
	}
}