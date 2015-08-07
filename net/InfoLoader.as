package net{
	import flash.display.*;
	import flash.net.*;
	import flash.events.*;
	import events.InfoLoaderEvent
	public class InfoLoader extends Sprite {
		private var myloader:URLLoader;
		private var myObj:Array = [];
		public function InfoLoader() {
			myloader = new URLLoader();
			myloader.addEventListener(Event.COMPLETE,loadEnd);
			myloader.addEventListener(IOErrorEvent.IO_ERROR, loadfalse);
		}
		public function load(url:String, targetInfo:String = ""):void {
			myObj.push({path:url,info:targetInfo});
			if (myObj.length == 1) {
				myloader.load(new URLRequest(myObj[0]["path"]));
			}
		}
		private function loadEnd(event:Event):void {
			var endInfo:String = String(event.target.data);
			dispatchEvent(new InfoLoaderEvent(InfoLoaderEvent.LOADEND,myObj[0]["info"],endInfo));
			myObj.splice(0, 1);
			doMyObj();
		}
		private function loadfalse(event:IOErrorEvent):void {
			dispatchEvent(new InfoLoaderEvent(InfoLoaderEvent.LOADFALSE,myObj[0]["info"]));
			myObj.splice(0, 1);
			doMyObj();
		}
		private function doMyObj():void {
			if (myObj.length >= 1) {
				myloader.load(new URLRequest(myObj[0]["path"]));
			}
		}
	}
}