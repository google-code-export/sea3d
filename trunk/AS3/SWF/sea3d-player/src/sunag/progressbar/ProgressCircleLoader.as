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

package sunag.progressbar
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import sunag.display.BlackSprite;

	public class ProgressCircleLoader extends ProgressCircle
	{
		private var _loader:URLLoader = new URLLoader();
		private var _stage:Stage;
		private var _bs:BlackSprite = new BlackSprite();
		
		public function ProgressCircleLoader()
		{
			super();
			
			_loader.dataFormat = URLLoaderDataFormat.BINARY;
			_loader.addEventListener(ProgressEvent.PROGRESS, onProgressDownload);
			
			_bs.visible = false;
		}
				
		public function get backScreen():BlackSprite
		{
			return _bs;
		}
		
		private function onResize(e:Event=null):void
		{					
			_bs.width = stage.stageWidth;
			_bs.height = stage.stageHeight;
			
			x = Math.round(stage.stageWidth/2);
			y = Math.round(stage.stageHeight/2);
		}
		
		public function load(request:URLRequest, stage:Stage):void
		{
			_stage = stage;
			
			_stage.addChild(_bs);
			_stage.addChild(this);
			
			onResize();
			
			_stage.addEventListener(Event.RESIZE, onResize);
			
			progress = NaN;
			loader.load(request);			
		}
	
		public function dispose():void
		{
			_stage.removeChild(_bs);
			_stage.removeChild(this);
			
			_stage.removeEventListener(Event.RESIZE, onResize);
			
			_loader.removeEventListener(ProgressEvent.PROGRESS, onProgressDownload);
		}
		
		private function onProgressDownload(e:ProgressEvent):void
		{
			progress = e.bytesLoaded / e.bytesTotal;
		}
		
		public function get data():ByteArray
		{
			return _loader.data;
		}
		
		public function get loader():URLLoader
		{
			return _loader;
		}
	}
}