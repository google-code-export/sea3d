package sunag.sea
{
	import flash.events.Event;
	
	public class SEAEvent extends Event
	{
		public static const COMPLETE_OBJECT:String = "sunag.sea::CompleteObject";
		public static const PROGRESS_OBJECT:String = "sunag.sea::ProgressObject";		
		
		public static const COMPLETE:String = "sunag.sea::Complete";
		public static const PROGRESS:String = "sunag.sea::Progress";
		
		public var object:SEAObject;
		
		public function SEAEvent(type:String, object:SEAObject=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{			
			this.object = object;						
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event
		{
			return new SEAEvent(type, object, bubbles, cancelable);
		}
	}
}