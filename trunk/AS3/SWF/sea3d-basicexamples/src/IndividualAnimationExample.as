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
	import flash.system.System;
	
	import sunag.sea.SEAEvent;
	import sunag.sea3d.SEA3D;
	import sunag.sea3d.animation.Animation;
	import sunag.sea3d.away3d.Away3D;
	import sunag.sea3d.away3d.animation.MeshAnimation;
	
	[SWF(width="1024", height="632", backgroundColor="0x2f3032", frameRate="60")]
	public class IndividualAnimationExample extends Sprite
	{
		private var view:View3D;
		private var scene:Scene3D;
		private var loader:SEA3D;
		private var bridge:Away3D;
		
		[Embed (source="../assets/SimpleScene.sea",mimeType="application/octet-stream")]
		private var SimpleScene:Class;
		
		public function IndividualAnimationExample()
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
			loader.addEventListener(SEAEvent.COMPLETE, onComplete);
			loader.load(new SimpleScene());						
		}
		
		private function onEnterFrame(e:Event):void
		{
			if (loader.loaded) {
				// Custom Code
				
				/**
				 * Set time scale
				 * */
				
				var timeScale:Number = stage.mouseX - (stage.stageWidth/2);				
				timeScale /= stage.stageWidth/12;
																				
				/**
				 * Update individual animation
				 * */
				
				var animation:Animation = bridge.player.getAnimationByName("Torus001");
							
				animation.updateTime(timeScale);
				animation.update();
												
				/**
				 * Accesing mesh
				 * */
				
				var meshAnimation:MeshAnimation = animation as MeshAnimation;					
				meshAnimation.mesh;
			}
			
			view.render();
		}
		
		private function onComplete(e:SEAEvent):void
		{
			/**
			 * Count of animation in the file.		 
			 * */
			
			trace("AnimationCount:", bridge.animation.length);
			
			/**
			 * <Camera001> Camera contained in MAX file.
			 * <bridge.get...> Using for get element.			 
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