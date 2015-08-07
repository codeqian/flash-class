package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.utils.Timer;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author qzd
	 */
	public class png_movie extends Bitmap
	{
		private var mov_speed:uint = 25;
		private var png_target:BitmapData;
		private var ar_h:uint = 1;//横帧数
		private var ar_v:uint = 1;//竖帧数
		private var bit_ar:Array = new Array();//各帧bitmapdata
		private var mov_step:uint = 0;
		private var mov_timer:Timer;
		public function png_movie(speed:uint, lib_class:BitmapData, _ar_h:uint, _ar_v:uint = 1)
		{
			mov_speed = speed;
			png_target = lib_class;
			ar_h = _ar_h;
			ar_v = _ar_v;
			var t_w:int = int(png_target.width / ar_h);
			var t_h:int = int(png_target.height / ar_v);
			for (var i:int = 0; i < ar_v; i++) {
				for (var n:int = 0; n < ar_h; n++) {
					var index:uint = bit_ar.length;
					bit_ar[index] = new BitmapData(png_target.width / ar_h, png_target.height / ar_v, true, 0);
					bit_ar[index].copyPixels(png_target, new Rectangle(t_w * n, t_h * i, t_w, t_h), new Point(0, 0));
				}
			}
		}
		public function start_mov() {
			if (mov_timer == null) {
				mov_timer = new Timer(int(1000 / mov_speed), 0);
				mov_timer.addEventListener(TimerEvent.TIMER, mov_play);
			}
			mov_timer.start();
		}
		public function stop_mov() {
			mov_timer.stop();
			mov_timer.removeEventListener(TimerEvent.TIMER, mov_play);
			mov_timer == null;
		}
		public function reset_mov() {
			mov_timer.stop();
			mov_timer.removeEventListener(TimerEvent.TIMER, mov_play);
			mov_step = 0;
			mov_timer == null;
		}
		private function mov_play(e:TimerEvent) {
			this.bitmapData = bit_ar[mov_step];
			if (mov_step < ar_h * ar_v - 1) {
				mov_step++;
			}else {
				mov_step = 0;
			}
		}
		public function mov_gotoAndStop(frame:uint) {
			this.bitmapData = bit_ar[frame];
		}
		public function get_bitmapdata(frame:uint):BitmapData {
			return bit_ar[frame];
		}
		public function destroy() {
			mov_timer.stop();
			mov_timer.removeEventListener(TimerEvent.TIMER, mov_play);
			mov_step = 0;
			mov_timer == null;
			png_target.dispose();
			png_target = null;
			for (var i:int = 0; i < bit_ar.length; i++) {
				bit_ar[i].dispose();
				bit_ar[i] = null;
			}
		}
	}

}