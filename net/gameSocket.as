package net 
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.system.System;
	import flash.system.Security;
	import events.netEvent;
	import net.TeaEncrypt;
	
	public class gameSocket extends Socket
	{
		private var dataServer:DataServer = null;
		private const HEAD_SIZE  = 20;
		public function gameSocket() 
		{
			dataServer = new DataServer();
			dataServer.addEventListener(netEvent.RECEIVE_DATA,gameDataEventFunc);
			this.addEventListener(ProgressEvent.SOCKET_DATA, getData);
		}
		public function destroy() {
			if (dataServer != null) {
				dataServer.removeEventListener(netEvent.RECEIVE_DATA, gameDataEventFunc);
				this.removeEventListener(ProgressEvent.SOCKET_DATA, getData);
			}
		}
		private function gameDataEventFunc(event:netEvent):void {
			//接收数据包
			var curData:ByteArray = event.data;
			curData.position = 0;
			//接收包头信息
			var curHeadData:Object = event.ObjData;
			//数据包
			var getMyData:ByteArray = new ByteArray();
			getMyData.endian = Endian.LITTLE_ENDIAN;
			curData.readBytes(getMyData, 0, curData.bytesAvailable);
			//数据包处理
			dispatchEvent(new netEvent(netEvent.GETGAMEDATA, getMyData, null, curHeadData));
			curData.clear();
			curData = null;
		}
		private function getData(event:ProgressEvent):void {
			var allData:ByteArray = new ByteArray();
			allData.position=0;
			allData.endian = Endian.LITTLE_ENDIAN;
			this.readBytes(allData, 0, this.bytesAvailable);
			//trace("收到数据长度" + allData.length);
			//处理收到的数据
			dataServer.receiveBuffer(allData);
			allData.clear();
			allData = null;
		}
		public function _sendData(myData:ByteArray, $MainID:uint, $AssistantID:uint):void {
			myData.position = 0;
			myData.endian = Endian.LITTLE_ENDIAN;
			//写包头
			var myHead:ByteArray = new ByteArray();
			myHead.position = 0;
			myHead.endian = Endian.LITTLE_ENDIAN;
			var my_gameData:ByteArray =  new ByteArray();
			my_gameData.position=0;
			my_gameData.endian = Endian.LITTLE_ENDIAN;
			var unlength:uint = 0;
			if (myData.length < 100) {
				//trace("Class::MySocket===加密===");
				//----------------------------加密---------------------------------
				var mData:ByteArray =  new ByteArray();
			    mData.position=0;
			    mData.endian = Endian.LITTLE_ENDIAN;
			    mData = TeaEncrypt.teaEncrypt(myData);
				//----------------------------加密---------------------------------
				mData.position=0;
			    my_gameData.writeBytes(mData,0,mData.length);
			} else {
				//trace("Class::MySocket===压缩===");
				unlength = myData.length;
			    myData.compress();
				myData.position = 0;
				my_gameData.writeBytes(myData,0,myData.length);
			}
			myHead.writeInt(my_gameData.length + HEAD_SIZE);
			myHead.writeInt($MainID);
			myHead.writeInt($AssistantID);
			myHead.writeInt(0);
			myHead.writeInt(unlength);
			var sendData:ByteArray = new ByteArray();
			sendData.position = 0;
			sendData.endian = Endian.LITTLE_ENDIAN;
			//写入包头
			sendData.writeBytes(myHead,0,myHead.length);
			//写入数据
			sendData.writeBytes(my_gameData,0,my_gameData.length);
			//写入缓冲区
			this.writeBytes(sendData,0,sendData.length);
			//发送数据
			this.flush();
			myData.clear();
			myData = null; 
			myHead.clear();
			myHead = null; 
			sendData.clear();
			sendData = null;	
			//trace("发送消息");
		}
	}
}