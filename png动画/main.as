package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import lib.*;
	/**
	 * ...
	 * @author qzd
	 */
	public class main extends MovieClip
	{
		//动画处理类
		private var fire_work_mov1:png_movie;
		private var fire_work_mov2:png_movie;
		//舞台bitmap
		private var bitmap_stage:Bitmap = new Bitmap();
		//库里的素材
		private var lib_fire_work1:firework1 = new firework1();
		//导入的素材
		private var pic_loader:Loader = new Loader();
		private var fire2_bmd:BitmapData = null;
		private var fire_step:uint = 0;
		public function main()
		{
			fire_work_mov1 = new png_movie(25, lib_fire_work1, 11, 2);
			addChild(fire_work_mov1);
			fire_work_mov1.start_mov();
			fire_work_mov1.x = 350;
			fire_work_mov1.y = 360;
			
			pic_loader.load(new URLRequest("images/fireworks3.png"));
			pic_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaded_pic);
			
			this.addEventListener(Event.ENTER_FRAME, draw_fire);
			bitmap_stage.bitmapData = new BitmapData(800, 600, true, 0);
			addChild(bitmap_stage);
		}
		private function loaded_pic(e:Event):void {
			fire2_bmd = new BitmapData(pic_loader.width, pic_loader.height, true, 0);
			fire2_bmd.draw(pic_loader);
			fire_work_mov2 = new png_movie(25, fire2_bmd, 19, 1);
		}
		private function draw_fire(e:Event) {
			if (fire2_bmd != null) {
				bitmap_stage.bitmapData.copyPixels(fire_work_mov2.get_bitmapdata(fire_step), new Rectangle(0, 0, fire_work_mov2.get_bitmapdata(fire_step).width, fire_work_mov2.get_bitmapdata(fire_step).height), new Point(0, 5 * fire_step));
				if (fire_step < 18) {
					fire_step++;
				}else {
					fire_step = 0;
				}
			}
		}
	}
}