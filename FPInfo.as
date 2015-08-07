package{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.utils.getTimer;

	/*显示当前的基本播放信息
	 * 公共方法：
	 * instance    获取自身
	 * getScreenResolution    获得分辨率
	 * getFlashVersion    获得flashPlayer版本
	 * */
	public class FPInfo extends Sprite{
		private static var _instance:FPInfo = null;
		private var _tft:TextFormat;
		private var _version:TextField;    //fp版本
		private var _resolution:TextField;    //分辨率
		private var _swh:TextField;    //fp的当前宽高
		private var _fps:TextField;    //帧频
		private var _mem:TextField;    //内存
		private var _frame:int;
		private var _lastTimer:int;
		
		public function FPInfo(){
			this.mouseEnabled = false;
			this.mouseChildren = false;
			style();
			addTextField();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveStage);
			this.addEventListener(Event.RESIZE, stageResizeHandler);
		}
		private function addTextField():void{
			/*版本*/
			_version = new TextField();
			_version.x = 10;
			_version.y = 10;
			_version.text = getFlashVersion();
			_version.autoSize = TextFieldAutoSize.LEFT;
			_version.defaultTextFormat = _tft;
			_version.setTextFormat(_tft);
			this.addChild(_version);
			
			/*分辨率*/
			_resolution = new TextField();
			_resolution.x = 10;
			_resolution.y = 25;
			_resolution.text = getScreenResolution();
			_resolution.autoSize = TextFieldAutoSize.LEFT;
			_resolution.defaultTextFormat = _tft;
			_resolution.setTextFormat(_tft);
			this.addChild(_resolution);
			
			/*fp宽高*/
			_swh = new TextField();
			_swh.x = 10;
			_swh.y = 40;
			_swh.autoSize = TextFieldAutoSize.LEFT;
			_swh.defaultTextFormat = _tft;
			_swh.setTextFormat(_tft);
			this.addChild(_swh);
			
			/*帧频*/
			_fps = new TextField();
			_fps.x = 10;
			_fps.y = 55;
			_fps.autoSize = TextFieldAutoSize.LEFT;
			_fps.defaultTextFormat = _tft;
			this.addChild(_fps);
			
			/*内存*/
			_mem = new TextField();
			_mem.x = 10;
			_mem.y = 70;
			_mem.autoSize = TextFieldAutoSize.LEFT;
			_mem.defaultTextFormat = _tft;
			this.addChild(_mem);
		}
		private function style():void{
			this.graphics.clear();
			this.graphics.beginFill(0x000000, 0.5);
			this.graphics.drawRoundRect(0, 0, 140, 100, 0, 0);
			this.graphics.endFill();
			_tft = new TextFormat();
			_tft.size = 12;
			_tft.color = 0xFFFFFF;
		}
		public static function get instance():FPInfo{
			if(_instance == null){
				_instance = new FPInfo();
			}
			return _instance;
		}
		private function onAddStage(event:Event):void{
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		private function onRemoveStage(event:Event):void{
			this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		public function getScreenResolution():String{
			return Capabilities.screenResolutionX + "*" + Capabilities.screenResolutionY;
		}
		public function getFlashVersion():String{
			return Capabilities.version;
		}
		private function stageResizeHandler(event:Event):void{
			if(stage){
				this.x = stage.stageWidth - this.width;
			}
		}
		private function enterFrameHandler(event:Event):void{
			var now:int = getTimer() - _lastTimer;
			_frame++;
			if(now > 1000){
				var fps:Number = Math.floor(_frame / (now * 0.001) * 1000) * 0.001;
				_fps.text = "fps:" + fps.toFixed(2);
				_lastTimer = getTimer();
				_frame = 0;
				var mem:Number = Math.round(System.totalMemory * 0.001 * 0.001);
				_mem.text = "mem:" + mem + "MB";
				
				_swh.text = "width: " + stage.stageWidth + " " + "height: " + stage.stageHeight;
			}
		}
	}
}