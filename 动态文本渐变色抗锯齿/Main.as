package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import myClass.TextAntiAlias;
	/**
	 * ...
	 * @author qzd
	 */
	public class Main extends MovieClip
	{
		var bmText:TextAntiAlias = new TextAntiAlias();
		var bmText2:TextAntiAlias = new TextAntiAlias();
		public function Main() 
		{
			this.addChild(bmText);
			this.addChild(bmText2);
			bmText.setText("这是一句测试文字", "YouYuan", 50, 0xffff00);
			bmText2.setText("这还是一句测试文字", "YouYuan", 50, 0x0066ff,200,300);
			bmText2.y = 100;
			bg.cacheAsBitmap = true;
			bmText.cacheAsBitmap = true;
			bg.mask = bmText;
		}
	}

}