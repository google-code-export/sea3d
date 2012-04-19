/** 
 * Copyright (C) 2012 Sunag Entertainment
 * */

package
{
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.debug.AwayStats;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.system.System;
	
	import sunag.sea.SEAEvent;
	import sunag.sea3d.SEA3D;
	import sunag.sea3d.SEAMaterial;
	import sunag.sea3d.SEAMesh;
	import sunag.sea3d.away3d.Away3D;
	
	[SWF(width="1024", height="632", backgroundColor="0x2f3032", frameRate="60")]
	public class SEAObjectExample extends Sprite
	{
		private var view:View3D;
		private var scene:Scene3D;
		private var loader:SEA3D;
		private var bridge:Away3D;
		
		[Embed (source="../assets/SimpleScene.sea",mimeType="application/octet-stream")]
		private var SimpleScene:Class;
		
		public function SEAObjectExample()
		{
			/**
			 * Basic config.
			 * */
			
			System.useCodePage = true;
			
			stage.stageFocusRect = false;
			stage.showDefaultContextMenu=false;	
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			scene = new Scene3D();			
			
			view = new View3D(scene);			
			view.backgroundColor = stage.color;
			view.antiAlias = 4;			
			addChild(view);
			addChild(new AwayStats(view));
			
			/**
			 * Init loader for Away3D.
			 * */			
			
			bridge = new Away3D();
						
			/**
			 * Alternative config
			 * */
			
			//bridge.ambient = 0x00;
			//bridge.enabledShadow = false;
			
			loader = new SEA3D(bridge);
			
			/**
			 * <SEAEvent.COMPLETE> Called when the file was loaded completely.
			 * <SEAEvent.PROGRESS> Called when the file is progressing.
			 * */
			
			loader.addEventListener(SEAEvent.COMPLETE, onComplete);
			loader.addEventListener(SEAEvent.PROGRESS, onProgress);
			
			/**
			 * Start load.
			 * */
			
			loader.load(new SimpleScene());						
		}
		
		private function getSEAObject():void
		{
			/**
			 * Get SEA3D Mesh
			 * */
									
			var seaMesh:SEAMesh = bridge.getSEAMesh("Box001");
			
			trace("--");
			trace("Contains Animation:", Boolean(seaMesh.animation));
			trace("Color Object: ", "0x" + seaMesh.color.toString(16));
			trace("Is instance: ", Boolean(seaMesh.instance));
			trace("Contains VertexColor: ", Boolean(seaMesh.vertexColor));
			
			/**
			 * Get SEA3D Material
			 * */						
			
			var seaMaterial:SEAMaterial = bridge.getSEAMaterial("02 - Default");
			
			trace("--");
			trace("Contains Texture:", Boolean(seaMaterial.diffuseMap));
			trace("Is Fresnel Reflect:", seaMaterial.fresnel);	
		}
		
		private function onEnterFrame(e:Event):void
		{
			if (loader.loaded) {
				// Custom Code
			}
			
			view.render();
		}
		
		private function onProgress(e:SEAEvent):void
		{
			/**
			 * Trace progress 0 at 1.		 
			 * */
			trace("LoadProgress:", loader.position / loader.length);
		}
		
		private function onComplete(e:SEAEvent):void
		{
			/**
			 * Get SEA3D Object	 
			 * */
			
			getSEAObject();
							
			/**
			 * <Camera001> Camera contained in MAX file.	 
			 * */
			
			view.camera = bridge.getCamera("Camera001");
			
			/**
			 * <bridge.container> contains all elements loaded.
			 * add objects in scene container
			 * */
			
			scene.addChild(bridge.container);
			
			/**
			 * Start render and update.
			 * */
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
	}
}