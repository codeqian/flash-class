package net 
{
	import flash.events.*;
	import flash.display.*;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import events.netEvent;
	
	public class DataServer extends MovieClip {
		private const HEAD_SIZE = 20; 
		public var isError:Boolean = false;
        private var memoryByte:ByteArray=null;
		//构造方法
		public function DataServer() {
			memoryByte = new ByteArray();
			memoryByte.endian = Endian.LITTLE_ENDIAN;
		}
		//析构方法
		public function destroy() {
		}
		
		//接收缓冲区数据 
		public function receiveBuffer(bufferData:ByteArray) {
			bufferData.position = 0;
			bufferData.endian = Endian.LITTLE_ENDIAN;
			var getData:ByteArray = new ByteArray();
			getData.endian = Endian.LITTLE_ENDIAN;
			if (memoryByte.length > 0) {
				memoryByte.readBytes(getData);
			}
			bufferData.readBytes(getData,getData.length);
			unEncapsulation(getData);
		}
		
		//拆解数据包
		public function unEncapsulation(bytes:ByteArray):void {
			try {
				bytes.position = 0;
				var i:int = 0;
				while (bytes.position < bytes.length) {
					if (isError) {
						isError = false;
						break;
					}
					if (i > 0) { trace("粘包") }
				    if (expByte(bytes) == false) {
						trace("切包");
						break;
					}
					i++;
				}
			}catch (e:Error) {
				//dispatchEvent(new GameDataEvent(GameDataEvent.UNUSEDATA));//无效数据
			}
		}
		public function expByte(bytes:ByteArray):Boolean {
			var myHead:ByteArray = new ByteArray();
			var headData:Object = new Object();
			//判断包头是否完整
			if (bytes.length - bytes.position < HEAD_SIZE) {
				memoryByte = new ByteArray();
				bytes.readBytes(memoryByte);
				trace("---包头不完整---");
				return false;
			}
			//读取包头
			bytes.readBytes(myHead,0, HEAD_SIZE);
			myHead.endian = Endian.LITTLE_ENDIAN;
			myHead.position = 0;
			var nMessageSize:uint = myHead.readUnsignedInt();
			var nMainID:uint = myHead.readUnsignedInt();
			var nAssistantId:uint  = myHead.readUnsignedInt();
			var nHandleCode:uint = myHead.readUnsignedInt();
			var nReserve:uint = myHead.readUnsignedInt();
			var dataLength:uint = nMessageSize-HEAD_SIZE;
			headData.messageSize = nMessageSize;
			headData.mainID = nMainID;
			headData.assistantID = nAssistantId;
			headData.handleCode = nHandleCode;
			headData.reserve = nReserve;
			//判断数据是否完整--数据切包	
			if (bytes.length - bytes.position < dataLength) {
				memoryByte = new ByteArray();
				memoryByte.endian = Endian.LITTLE_ENDIAN;
				bytes.position = bytes.position - HEAD_SIZE;
				bytes.readBytes(memoryByte);
				return false;
			}
			var myContent:ByteArray = new ByteArray();
			myContent.endian = Endian.LITTLE_ENDIAN;
			bytes.readBytes(myContent, 0, dataLength);
			myContent.position = 0;
			dispatchEvent(new netEvent(netEvent.RECEIVE_DATA, myContent, null, headData));
			return true;
		}
	}
}