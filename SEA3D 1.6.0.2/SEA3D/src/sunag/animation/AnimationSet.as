package sunag.animation
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import sunag.sunag;

	use namespace sunag;

	public class AnimationSet extends EventDispatcher
	{
		sunag var _anmList:Vector.<AnimationNode> = new Vector.<AnimationNode>();	
		sunag var _anm:Object = {};
		sunag var _dataLength:int = -1;
		
		public function addAnimation(node:AnimationNode):void
		{
			if (_dataLength == -1) 
				_dataLength = node._dataList.length;
			
			_anmList.push(_anm[node._name] = node);
			
			notifyChange();
		}
		
		public function getAnimationByName(name:String):AnimationNode
		{
			return _anm[name];
		}
		
		private function notifyChange():void
		{
			if (hasEventListener(Event.CHANGE))
				dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get animations():Vector.<AnimationNode>
		{
			return _anmList;
		}			
	}
}