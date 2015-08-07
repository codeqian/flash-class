package events 
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	public class netEvent extends Event
	{
		//服务器链接成功
		public static const CONNECT_SUCCESS = "connect_success";//
		//服务器链接失败
		public static const CONNECT_ERROR = "connect_error";//
		//服务器链接已关闭
		public static const SERVER_CLOSED = "server_closed";//
		//服务器断开
		public static const SOCKET_CLOSED = "socket_closed";//
		//数据解包完成
        public static const RECEIVE_DATA = "receive_data";//
		//收到数据
		public static const GETGAMEDATA:String = "getGameData";
		
		public var data:ByteArray;
		public var ArrData:Array;
		public var ObjData:Object;
		
		public function netEvent(aType, aData:ByteArray = null, rData:Array = null, uData:Object = null) 
		{
			super(aType, true, true);
			data = aData;
			ArrData = rData;
			ObjData = uData;
		}
	}
}