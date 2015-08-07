package events 
{
	import flash.events.Event;
	
	public class gameEvent extends Event
	{
		//连接状态
		public static const NET_INFO = "net_info";
		public var _info:String;
		public function gameEvent(type:String, info:String = "0") 
		{
			super(type);
			_info = info;
		}
		
	}

}