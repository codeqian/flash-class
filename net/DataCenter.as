package net 
{
	import adobe.utils.CustomActions;
	import events.gameEvent;
	import events.netEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import net.InfoLoader;
	import net.gameSocket;
	import events.InfoLoaderEvent;
	import flash.system.System;
	import flash.net.navigateToURL;
	import flash.system.Security;
	import flash.utils.Endian;
	import com.adobe.serialization.json.*;
	
	public class DataCenter extends EventDispatcher
	{
		public var _gameSocket:gameSocket;
		private static var myloaderInfo:InfoLoader = new InfoLoader();
		//连接标记
		private static var connected:Boolean = false;
		public static var uinfoUrl:String;
		public static var sinfoUrl:String;
		public static var rootUrl:String;
		
		//数据包头
		private var uMessageSize = 0;//数据包大小（数据大小+包头大小）
		private var bMainID = 0;
		private var bAssistantID = 0;//
		private var bHandleCode = 0;
		private var bReserve = 0;//保留字 标识数据包是否被压缩，无压缩为0，压缩则为压缩前的字节数
        //包头长度
		private const HEAD_SIZE  = 20;
		//重连计时
		private var re_con_timer:Timer = new Timer(10000, 1);
		
		public function DataCenter()
		{
			//Security.allowDomain("*");
			System.useCodePage = true;
			//new StageSetting(stage);
			_gameSocket = new gameSocket();
			_gameSocket.addEventListener(netEvent.GETGAMEDATA, getSocketInfo);
			_gameSocket.addEventListener(IOErrorEvent.IO_ERROR, IoErro_func);
			_gameSocket.addEventListener(Event.CONNECT, socketConnect);
			_gameSocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, SECURITY_EFunc);
			_gameSocket.addEventListener(Event.CLOSE, socketClose);
			myloaderInfo.addEventListener(InfoLoaderEvent.LOADEND, getHttpInfo);
			re_con_timer.addEventListener(TimerEvent.TIMER_COMPLETE, re_connect_time_out);
		}
		public function destroy() {
			if (_gameSocket != null) {
				_gameSocket.destroy();
				_gameSocket.removeEventListener(Event.CONNECT, socketConnect);
				_gameSocket.removeEventListener(netEvent.GETGAMEDATA, getSocketInfo);
				_gameSocket.removeEventListener(IOErrorEvent.IO_ERROR ,IoErro_func);
				_gameSocket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,SECURITY_EFunc);
				_gameSocket.removeEventListener(Event.CLOSE, socketClose);
				close_socket();
				_gameSocket = null;
			}
		}
		private function re_connect_time_out(event:TimerEvent):void {
			re_connect();
		}
		private function re_connect() {
			if (connected == false) {
				get_uInfo();
			}
		}
		public function getHost():void {
			myloaderInfo.load(DataCenter.sinfoUrl, "host");
		}
		public function get_uInfo():void {
			myloaderInfo.load(DataCenter.rootUrl + DataCenter.uinfoUrl, "uInfo");
			re_con_timer.reset();
			re_con_timer.start();
		}
		private function IoErro_func(event:IOErrorEvent):void {
			trace("IO错误");
		}
		private function socketConnect(event:Event):void {
			trace("链接成功");
			connected = true;
			re_con_timer.stop();
			//登陆
			var loginData:ByteArray = new ByteArray();
			loginData.endian = Endian.LITTLE_ENDIAN;
			loginData.position = 0;
			loginData = my_lobby.getloginData(gameData.login_Data);
			_gameSocket._sendData(loginData, 2, 4);
		}
		private function socketClose(event:Event):void {
			trace("链接断开");
			dispatchEvent(new netEvent(netEvent.CLOSE));
		}
		private function SECURITY_EFunc(event:SecurityErrorEvent):void {
			trace("没有权限");
		}
		private function getHttpInfo(event:InfoLoaderEvent):void {
			//trace(event.data, event.parent);
			switch(event.parent) {
				//case "host":
				//处理服务器地址
				//break;
				case "uInfo":
				_uInfo = event.data;
				gameData.login_Data = new Object();
				readJsonData(_uInfo);
				//trace(gameData.login_Data.Unit);
				if (gameData.login_Data.Unit != null) {
					gameData.bomb_coin_name = gameData.login_Data.Unit;
				}
				_gameSocket.connect(gameData.login_Data.RoomIP, int(gameData.login_Data.RoomPort));
				break;
			}
		}
		public function close_socket() {
			_gameSocket.close();
		}
		//解析JSON结构
		private function readJsonData(userInfo:String) {
			var info:String = formatJSON(userInfo);
			var cueUser:Array = JSON.decode(info);//userInfo
			//用户信息
			gameData.login_Data.UserID = cueUser[0].UserID;
			gameData.login_Data.UserName = cueUser[0].UserName;
			gameData.login_Data.Password = cueUser[0].Password;
			gameData.login_Data.RoomID = cueUser[0].RoomID;
			gameData.login_Data.GameID = cueUser[0].GameID;
			gameData.login_Data.RoomIP = cueUser[0].SocketIP;
			gameData.login_Data.RoomPort = cueUser[0].Port;
			gameData.login_Data.Unit = cueUser[0].Unit;
			info = null;
			cueUser = null;
		}
		private function formatJSON(s:String):String {
			var str:String = s;
			var pattern:RegExp = /'/g;
			str = str.replace(pattern, "\"");
			pattern =/ /g;
			str = str.replace(pattern, "");
			pattern =/\{([^"^:]*):/g;
			str = str.replace(pattern, "{\"$1\":");
			pattern =/,([^"^:]*):/g;
			str=str.replace(pattern,",\"$1\":");
			return str;
		}
		private function getSocketInfo(event:netEvent):void {
			var the_time:Date = new Date();
			//trace("操作数：" + event._id + "---数据内容：" + event._data + "---消息时间:" + int(the_time.time / 1000));
			var curHeadData:Object = event.ObjData;
			//记录当前包头信息
			uMessageSize = curHeadData.messageSize;//数据包大小（数据大小+包头大小）
		    bMainID = curHeadData.mainID;
		    bAssistantID = curHeadData.assistantID;
		    bHandleCode = curHeadData.handleCode;
		    bReserve = curHeadData.reserve;
			
			var curData:ByteArray = event.data;
			curData.position = 0;
			var getPData:ByteArray = new ByteArray();
			getPData.position=0;
			getPData.endian = Endian.LITTLE_ENDIAN;
			if(bReserve==0){
				trace("=解密数据=长度"+curData.length);
			    getPData = TeaEncrypt.teaDecrypt(curData);
			}else {
				trace("=解压数据=");
				curData.readBytes(getPData,0,curData.length);
				curData.clear();
				getPData.uncompress();
			}
			getPData.position = 0;
			switch(bAssistantID){
				default:
				break;
			}
			getPData.clear();
		}
	}
}