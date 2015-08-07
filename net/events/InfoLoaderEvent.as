package events {
	import flash.events.*;
	public class InfoLoaderEvent extends Event {
		public static  const LOADEND:String = "loadend";
		public static  const LOADFALSE:String = "loadfalse";
		private var myparent:String="";
		private var myinfo:String = "";
		public function InfoLoaderEvent(type:String,user:String,info:String="") {
			super(type, true);
			myinfo = info;
			myparent=user;
		}
		public function get parent():String {
			return myparent;
		}
		public function get data():String {
			return myinfo;
		}
	}
}